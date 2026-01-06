# G‑SIM

**Gophish Simulation Provisioning Tool for Google Cloud Platform**

## Overview

**G‑SIM** is an open source phishing assistance tool designed for security professionals who conduct **authorized phishing simulations** using **Gophish**.

Setting up phishing infrastructure in cloud environments often involves multiple steps such as virtual machine provisioning, firewall configuration, dependency installation, container deployment, and access validation. In practice, these steps are frequently performed under time constraints, increasing the likelihood of configuration errors, missed firewall rules, or incomplete setups.

Having gone through this process repeatedly in real‑world security operations, G‑SIM was created to reduce operational overhead, minimize human error, and provide a consistent, repeatable deployment process for phishing simulation infrastructure.

G‑SIM standardizes Gophish deployments so teams can focus on campaign execution and analysis rather than infrastructure preparation.

---

## Key Capabilities

G‑SIM automates the following:

* Provisioning a GCP Compute Engine virtual machine
* Automatic firewall rule creation for phishing and admin access
* Docker installation and configuration
* Deployment of Gophish as a Docker container
* Automatic detection of the public external IP address
* Extraction of Gophish admin credentials from container logs
* Consolidated output of access details in terminal
* Persistent storage of deployment information in a local file
* Inclusion of authorized use and compliance warnings

---

## Intended Audience

G‑SIM is intended for:

* Security engineers
* Red team and blue team operators
* Security awareness and phishing simulation teams
* Consultants performing authorized phishing assessments

This tool must only be used within approved and authorized security programs.

---

## Supported Environment

* **Cloud Provider:** Google Cloud Platform
* **Operating System:** Debian 12 (Bookworm)
* **Deployment Method:** Docker‑based Gophish container
* **Networking:** Automated firewall configuration

---

## Prerequisites

Before running G‑SIM, ensure the following:

* An active Google Cloud Platform project
* Sufficient permissions to create compute instances and firewall rules
* `gcloud` CLI installed
* Authentication completed using:

  ```bash
  gcloud auth login
  ```
* A default project configured:

  ```bash
  gcloud config set project <project-id>
  ```

---

## Region and Zone Selection

G‑SIM supports both **default deployment locations** and **custom region and zone selection**.

By default, G‑SIM deploys resources using predefined, stable locations to ensure a smooth and consistent setup without requiring additional input.

For environments with regulatory, latency, or regional testing requirements, operators may specify a custom **region** and **zone** during execution. When provided, these values override the defaults and are used throughout the deployment process.

This flexibility allows G‑SIM to align with organizational policies while maintaining ease of use.

---

## Deployment Instructions

Run the following commands from your terminal:

```bash
curl -LO https://raw.githubusercontent.com/5urg3on/G-SIM/main/gsim.sh
chmod +x gsim.sh
./gsim.sh

```

The script handles the full deployment automatically.

---

## Deployment Output

Upon successful execution, G‑SIM generates a file named:

```
gsimAccess.txt
```

This file contains:

* External public IP address
* Gophish admin interface URL with port
* Phishing landing page URL
* Deployment timestamp
* Authorized use notice

The same information is displayed in the terminal for immediate access.

---

### Check Gophish Admin login passwird
```bash
docker logs gophish
```

## Default Configuration

* **VM Name:** `gophish-servers`
* **Machine Type:** `e2-micro`
* **Exposed Ports:**

  * `80` for phishing content
  * `3333` for Gophish admin interface
* **Docker Container Name:** `gophish`
* **Restart Policy:** `unless-stopped`

These defaults are selected for cost efficiency, simplicity, and operational reliability.

---

## Security and Compliance Considerations

* **Authorized Use Only:** G‑SIM is intended exclusively for authorized phishing simulations.
* **Operational Risk Reduction:** Automation reduces the likelihood of human error such as missing firewall rules, incorrect port exposure, or incomplete service startup.
* **Audit Support:** Deployment details are captured and stored to support internal documentation and audit requirements.

I will not be responsible for misuse of this tool as it is intended for security professional only.

---

## License

This tool is released under an open source license.
---

## Roadmap

Planned enhancements include:

* Interactive and non‑interactive region selection
* Domain and TLS automation
* Environment cleanup and teardown scripts
* Backup and recovery options
* Multi‑cloud deployment support


## Destroying the G‑SIM Deployment

G‑SIM includes a destroy script to safely remove all resources created during deployment.
This ensures clean teardown and avoids unnecessary cloud cost.

The destroy process will remove:

* The Gophish Compute Engine VM
* Associated firewall rules created by G‑SIM
* Deployment artifacts generated by the script

### Run the Destroy Script

Download and execute the destroy script:

```bash
curl -LO https://raw.githubusercontent.com/5urg3on/G-SIM/main/gsim-destroy.sh
chmod +x gsim-destroy.sh
./gsim-destroy.sh
```

---

### What the Script Does

* Prompts for VM name and zone
* Uses defaults if not provided
* Deletes the Compute Engine instance
* Removes firewall rules for ports 80 and 3333 if created by G‑SIM
* Confirms successful cleanup in the terminal

---

### Important Notes

* This action is irreversible
* All data on the VM will be permanently deleted
* Ensure campaigns and data are backed up if required

---

### Recommended Use

Use the destroy script:

* After completing phishing simulations
* Before redeploying a fresh environment
* To prevent unintended cloud charges

## Author
For updates on security tooling, automation, offsec and cloud security:

LinkedIn: https://www.linkedin.com/in/sylvesterbaruch
X (Twitter): https://x.com/coo119578151920


G‑SIM is designed to be simple, transparent, and reliable.
Every action performed by the script is visible and auditable, ensuring confidence in both security operations and compliance.

---
