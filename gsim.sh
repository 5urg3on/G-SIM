#!/bin/bash

set -e

echo "======================================="
echo "G-SIM | Gophish Simulation Deployment"
echo "======================================="

PROJECT_ID=$(gcloud config get-value project)
VM_NAME="gophish-servers"
MACHINE_TYPE="e2-micro"
IMAGE_FAMILY="debian-12"
IMAGE_PROJECT="debian-cloud"
ZONE_DEFAULT="us-central1-c"
REGION_DEFAULT="us-central1"
TAG_NAME="gophish-fw"
OUTPUT_FILE="gsimAccess.txt"

echo ""
echo "GCP Project: $PROJECT_ID"
echo ""

read -p "Use default region and zone? (Y/n): " REGION_CHOICE
REGION_CHOICE=${REGION_CHOICE:-Y}

if [[ "$REGION_CHOICE" =~ ^[Yy]$ ]]; then
  REGION=$REGION_DEFAULT
  ZONE=$ZONE_DEFAULT
else
  read -p "Enter GCP region (example us-central1): " REGION
  read -p "Enter GCP zone (example us-central1-c): " ZONE
fi

echo ""
echo "Region: $REGION"
echo "Zone:   $ZONE"
echo ""

echo "Creating firewall rule..."
gcloud compute firewall-rules create gophish-allow-http \
  --allow tcp:80,tcp:3333 \
  --target-tags $TAG_NAME \
  --direction INGRESS \
  --priority 1000 \
  --network default \
  --quiet || echo "Firewall rule already exists"

echo "Creating VM..."
gcloud compute instances create $VM_NAME \
  --zone=$ZONE \
  --machine-type=$MACHINE_TYPE \
  --image-family=$IMAGE_FAMILY \
  --image-project=$IMAGE_PROJECT \
  --tags=$TAG_NAME \
  --quiet

echo "Waiting for VM to initialize..."
sleep 25

echo "Installing Docker and running Gophish..."
gcloud compute ssh $VM_NAME --zone=$ZONE --command="
sudo apt update -y
sudo apt install -y docker.io
sudo systemctl enable docker
sudo systemctl start docker
sudo docker run -d --name gophish -p 3333:3333 -p 80:80 --restart unless-stopped gophish/gophish
"

sleep 10

EXTERNAL_IP=$(gcloud compute instances describe $VM_NAME \
  --zone=$ZONE \
  --format='get(networkInterfaces[0].accessConfigs[0].natIP)')

ADMIN_USER="admin"
ADMIN_PASS=$(gcloud compute ssh $VM_NAME --zone=$ZONE --command="
sudo docker exec gophish grep admin_password /opt/gophish/config.json | cut -d ':' -f2 | tr -d ' \",'
")


echo ""
echo "Saving access details..."

cat <<EOF | tee $OUTPUT_FILE
==============================
G-SIM Deployment Information
==============================

Project ID: $PROJECT_ID
VM Name: $VM_NAME
Region: $REGION
Zone: $ZONE
External IP: $EXTERNAL_IP

Gophish Admin URL:
https://$EXTERNAL_IP:3333

Docker Admin Credentials:
$ADMIN_LOG

Firewall:
Ports 80 and 3333 allowed

Status:
Deployment completed successfully
==============================
EOF

echo ""
echo "Deployment complete"
echo "Access details saved to $OUTPUT_FILE"
