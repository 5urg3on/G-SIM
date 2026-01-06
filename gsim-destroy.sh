#!/bin/bash

# ===============================
# G-SIM Destroy Script
# ===============================

VM_NAME="gophish-servers"
FIREWALL_RULE="gophish-fw"
OUTPUT_FILE="gsimAccess.txt"
DEFAULT_REGION="us-central1"
DEFAULT_ZONE="us-central1-c"

echo "==============================" | tee $OUTPUT_FILE
echo "G-SIM Destroy Process Started" | tee -a $OUTPUT_FILE
echo "==============================" | tee -a $OUTPUT_FILE

read -p "Do you want to use default region and zone (us-central1 / us-central1-c)? [Y/n]: " REGION_CHOICE
REGION_CHOICE=${REGION_CHOICE:-Y}

if [[ "$REGION_CHOICE" =~ ^[Yy]$ ]]; then
    REGION=$DEFAULT_REGION
    ZONE=$DEFAULT_ZONE
else
    read -p "Enter region: " REGION
    read -p "Enter zone: " ZONE
fi

echo "" | tee -a $OUTPUT_FILE
echo "Region: $REGION" | tee -a $OUTPUT_FILE
echo "Zone: $ZONE" | tee -a $OUTPUT_FILE

echo "" | tee -a $OUTPUT_FILE
echo "Checking VM existence..." | tee -a $OUTPUT_FILE

VM_EXISTS=$(gcloud compute instances list --filter="name=$VM_NAME AND zone:($ZONE)" --format="value(name)")

if [[ -z "$VM_EXISTS" ]]; then
    echo "VM not found. Nothing to delete." | tee -a $OUTPUT_FILE
else
    echo "Deleting VM: $VM_NAME" | tee -a $OUTPUT_FILE
    gcloud compute instances delete $VM_NAME --zone=$ZONE --quiet
    echo "VM deleted successfully" | tee -a $OUTPUT_FILE
fi

echo "" | tee -a $OUTPUT_FILE
echo "Checking firewall rule..." | tee -a $OUTPUT_FILE

FW_EXISTS=$(gcloud compute firewall-rules list --filter="name=$FIREWALL_RULE" --format="value(name)")

if [[ -z "$FW_EXISTS" ]]; then
    echo "Firewall rule not found." | tee -a $OUTPUT_FILE
else
    echo "Deleting firewall rule: $FIREWALL_RULE" | tee -a $OUTPUT_FILE
    gcloud compute firewall-rules delete $FIREWALL_RULE --quiet
    echo "Firewall rule deleted successfully" | tee -a $OUTPUT_FILE
fi

echo "" | tee -a $OUTPUT_FILE
echo "Status:" | tee -a $OUTPUT_FILE
echo "G-SIM resources destroyed successfully" | tee -a $OUTPUT_FILE
echo "==============================" | tee -a $OUTPUT_FILE
