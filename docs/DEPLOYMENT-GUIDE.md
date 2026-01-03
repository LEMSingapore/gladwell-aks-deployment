# Complete Deployment Guide for Project 4 Part 1

## Overview

This guide will walk you through:
1. Creating an Azure account (with $200 free credit)
2. Installing required tools
3. Deploying the AKS cluster
4. Capturing all 5 required screenshots
5. Cleaning up resources

**Estimated time:** 30-45 minutes
**Cost:** ~$5 (covered by free credit)

---

## Part 1: Create Azure Account

### Step 1: Sign Up for Azure Free Account

1. **Visit Azure Free Account Page:**
   - Go to: https://azure.microsoft.com/free/
   - Click "Start free" button

2. **Sign in with Microsoft Account:**
   - **Option A**: Use existing Microsoft account (Outlook, Hotmail, Xbox)
   - **Option B**: Create new account with any email

   Click "Create one!" if you need new account

3. **Fill Your Information:**
   ```
   First name: [Your name]
   Last name: [Your name]
   Email: [Your email]
   Password: [Create strong password]
   Country/Region: [Your country]
   ```

4. **Phone Verification:**
   - Enter phone number
   - Receive SMS code
   - Enter code to verify

5. **Identity Verification:**
   - Enter credit card information
   - **Important:** This is for identity verification only
   - **You will NOT be charged** unless you explicitly upgrade
   - Azure requires this to prevent abuse

6. **Agreement:**
   - Review terms
   - Check boxes
   - Click "Sign up"

### What You Get:

✅ **$200 free credit** (valid for 30 days)
✅ **Free services for 12 months**:
   - 750 hours of B1S VMs (enough for this project)
   - 5 GB blob storage
   - 15 GB bandwidth
✅ **Always-free services**:
   - App Service (10 web apps)
   - Azure Functions (1 million requests/month)

### Important Notes:

- ⚠️ Free credit expires in 30 days
- ⚠️ After free credit, you must upgrade to pay-as-you-go to continue
- ✅ You control spending - no surprise charges
- ✅ Set up spending alerts (recommended)

---

## Part 2: Install Required Tools

### Option 1: Automated Installation (Recommended)

```bash
# Navigate to project directory
cd /Users/cheeyoungchang/Projects/cloud-capstone

# Run setup script
./setup-azure-tools.sh
```

This installs:
- Azure CLI
- kubectl
- Terraform

### Option 2: Manual Installation

**For macOS:**
```bash
# Install Homebrew (if not installed)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install tools
brew install azure-cli
brew install kubectl
brew tap hashicorp/tap
brew install hashicorp/tap/terraform
```

**For Linux (Ubuntu/Debian):**
```bash
# Azure CLI
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

# kubectl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

# Terraform
wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install terraform
```

### Verify Installation:

```bash
# Check versions
az --version
kubectl version --client
terraform version
```

Expected output:
```
azure-cli  2.55.0
kubectl    v1.28.x
Terraform  v1.6.x
```

---

## Part 3: Deploy AKS Cluster

### Option 1: Automated Deployment (Recommended)

```bash
# Navigate to project directory
cd /Users/cheeyoungchang/Projects/cloud-capstone

# Run deployment script
./deploy-aks.sh
```

**This script will:**
1. Login to Azure
2. Initialize Terraform
3. Deploy AKS cluster
4. Deploy nginx
5. **Prompt you to capture each screenshot at the right time**

**Follow the prompts and capture screenshots when indicated!**

### Option 2: Manual Step-by-Step Deployment

If you prefer to understand each step:

**Step 1: Login to Azure**
```bash
az login
```

This opens browser for authentication. Sign in with your Azure account.

**Step 2: Verify Subscription**
```bash
# List subscriptions
az account list --output table

# Set active subscription (if multiple)
az account set --subscription "Your-Subscription-Name"

# Verify
az account show --output table
```

**Step 3: Navigate to Terraform Directory**
```bash
cd terraform-aks
```

**Step 4: Initialize Terraform**
```bash
terraform init
```

Output:
```
Initializing the backend...
Initializing provider plugins...
- Finding hashicorp/azurerm versions matching "~> 3.0"...
- Installing hashicorp/azurerm v3.85.0...
Terraform has been successfully initialized!
```

**Step 5: Preview Deployment**
```bash
terraform plan
```

Review what will be created:
- Resource Group: rg-gladwell-aks
- AKS Cluster: aks-gladwell-cluster (2 nodes)
- Nginx deployment
- LoadBalancer service

**Step 6: Deploy (5-10 minutes)**
```bash
terraform apply -auto-approve
```

Output will show:
```
azurerm_resource_group.aks: Creating...
azurerm_resource_group.aks: Creation complete
azurerm_kubernetes_cluster.aks: Creating... (this takes time)
...
Apply complete! Resources: 4 added, 0 changed, 0 destroyed.
```

**Step 7: Get Kubernetes Credentials**
```bash
az aks get-credentials \
  --resource-group rg-gladwell-aks \
  --name aks-gladwell-cluster
```

Output:
```
Merged "aks-gladwell-cluster" as current context in /Users/you/.kube/config
```

---

## Part 4: Capture Required Screenshots

### 📸 Screenshot 1.1: AKS Cluster Properties

**Command:**
```bash
az aks show \
  --resource-group rg-gladwell-aks \
  --name aks-gladwell-cluster \
  --output table
```

**What to capture:**
- Cluster name: aks-gladwell-cluster
- Resource group: rg-gladwell-aks
- Location: eastus
- Kubernetes version: 1.28.x
- Node count: 2
- Provisioning state: Succeeded

**How to screenshot:**
- **macOS**: Cmd+Shift+4, then drag to select terminal area
- **Windows**: Windows+Shift+S, then select area
- **Linux**: Use Gnome Screenshot or Flameshot

---

### 📸 Screenshot 1.2: Node Status

**Command:**
```bash
kubectl get nodes -o wide
```

**Expected output:**
```
NAME                                STATUS   ROLES   AGE   VERSION   INTERNAL-IP
aks-nodepool1-12345678-vmss000000   Ready    agent   5m    v1.28.3   10.224.0.4
aks-nodepool1-12345678-vmss000001   Ready    agent   5m    v1.28.3   10.224.0.5
```

**What to verify:**
- ✅ 2 nodes listed
- ✅ Both STATUS: Ready
- ✅ Both ROLES: agent
- ✅ Kubernetes VERSION shown

---

### 📸 Screenshot 1.3: Deploy Nginx Command

**Command:**
```bash
kubectl create deployment nginx-deployment --image=nginx:latest
```

**Expected output:**
```
deployment.apps/nginx-deployment created
```

**Note:** If using Terraform, nginx is already deployed. You can show the existing deployment:
```bash
kubectl get deployment nginx-deployment
```

**What to capture:**
- Command line showing the kubectl create command
- Success message

---

### 📸 Screenshot 1.4: Pod Verification

**Wait for pod to be ready:**
```bash
kubectl wait --for=condition=ready pod -l app=nginx --timeout=120s
```

**Then capture:**
```bash
kubectl get pods -o wide
```

**Expected output:**
```
NAME                                READY   STATUS    RESTARTS   AGE   IP
nginx-deployment-5d59d67564-xxxxx   1/1     Running   0          2m    10.244.1.2
```

**What to verify:**
- ✅ Pod name starts with nginx-deployment
- ✅ READY: 1/1
- ✅ STATUS: Running
- ✅ Pod IP assigned
- ✅ Node assignment shown

---

### 📸 Screenshot 1.5: Deployment State

**Command:**
```bash
kubectl get deployment nginx-deployment -o wide
```

**Expected output:**
```
NAME               READY   UP-TO-DATE   AVAILABLE   AGE   CONTAINERS   IMAGES
nginx-deployment   1/1     1            1           5m    nginx        nginx:latest
```

**What to verify:**
- ✅ READY: 1/1
- ✅ UP-TO-DATE: 1
- ✅ AVAILABLE: 1
- ✅ CONTAINERS: nginx
- ✅ IMAGES: nginx:latest

**Optional - Detailed view:**
```bash
kubectl describe deployment nginx-deployment
```

---

## Part 5: Test Nginx (Optional)

### Get External IP:

```bash
kubectl get service nginx-service
```

Wait for EXTERNAL-IP (takes 1-2 minutes):
```
NAME            TYPE           CLUSTER-IP     EXTERNAL-IP      PORT(S)
nginx-service   LoadBalancer   10.0.123.45    52.xxx.xxx.xxx   80:30123/TCP
```

### Test in Browser:

```bash
# Copy external IP and visit in browser
http://52.xxx.xxx.xxx
```

You should see the **nginx welcome page**!

---

## Part 6: Add Screenshots to Document

1. **Open the DOCX file:**
   ```
   Project4-Part1-AKS-Kubernetes-Solution.docx
   ```

2. **Insert screenshots:**
   - Navigate to the "Required Screenshots" section
   - Insert each screenshot under its respective heading
   - Add caption below each screenshot

3. **Format screenshots:**
   - Resize if needed (keep readable)
   - Ensure command and output are both visible
   - Add border (optional, for clarity)

---

## Part 7: Cleanup (Important!)

### After capturing screenshots and before submitting:

**Option 1: Using Terraform (Recommended)**
```bash
cd terraform-aks
terraform destroy -auto-approve
```

**Option 2: Using Azure CLI**
```bash
az group delete --name rg-gladwell-aks --yes --no-wait
```

**Verify deletion:**
```bash
az group list --output table
```

### Why cleanup is important:

- ⚠️ Running cluster costs ~$0.30/hour
- ⚠️ If left running 24/7: ~$160/month
- ✅ Cleanup after screenshots: Total cost ~$5
- ✅ $200 free credit: More than enough!

---

## Troubleshooting

### Issue: Azure login fails

**Solution:**
```bash
# Clear cache
az account clear
az login --use-device-code
```

### Issue: Terraform init fails

**Solution:**
```bash
rm -rf .terraform .terraform.lock.hcl
terraform init
```

### Issue: AKS creation fails with quota error

**Error:** "Quota exceeded for VM family Standard_DS"

**Solution:**
Try different VM size:
```bash
# Edit terraform-aks/variables.tf
# Change: default = "Standard_D2s_v3"
terraform apply -auto-approve
```

Or use different region:
```bash
# Edit terraform-aks/variables.tf
# Change: default = "westus2"
```

### Issue: kubectl commands fail

**Solution:**
```bash
# Re-get credentials
az aks get-credentials \
  --resource-group rg-gladwell-aks \
  --name aks-gladwell-cluster \
  --overwrite-existing

# Verify connection
kubectl get nodes
```

### Issue: Pod stuck in "Pending" status

**Check:**
```bash
kubectl describe pod <pod-name>
```

**Common cause:** Nodes not ready yet. Wait 2-3 minutes and check again.

---

## Cost Breakdown

| Resource | Duration | Cost |
|----------|----------|------|
| 2 x Standard_DS2_v2 nodes | 5 hours | ~$1.50 |
| Azure Load Balancer | 5 hours | ~$0.10 |
| Bandwidth (minimal) | - | ~$0.10 |
| **Total** | **~5 hours** | **~$1.70** |

**With free $200 credit:** No actual charges!

---

## Checklist Before Submission

- [ ] Azure account created
- [ ] Tools installed (az, kubectl, terraform)
- [ ] AKS cluster deployed successfully
- [ ] Screenshot 1.1 captured (AKS properties)
- [ ] Screenshot 1.2 captured (nodes)
- [ ] Screenshot 1.3 captured (nginx deployment command)
- [ ] Screenshot 1.4 captured (pod status)
- [ ] Screenshot 1.5 captured (deployment state)
- [ ] Screenshots added to DOCX document
- [ ] Tested nginx in browser (optional)
- [ ] Resources cleaned up (terraform destroy)
- [ ] DOCX ready for submission

---

## Quick Reference Commands

```bash
# Check cluster status
kubectl get all

# View logs
kubectl logs deployment/nginx-deployment

# Scale deployment
kubectl scale deployment nginx-deployment --replicas=2

# Delete deployment
kubectl delete deployment nginx-deployment

# View cluster info
kubectl cluster-info

# Describe node
kubectl describe node <node-name>
```

---

## Support

If you encounter issues:

1. **Check Azure Status:** https://status.azure.com
2. **Azure Documentation:** https://docs.microsoft.com/azure/aks
3. **Terraform Docs:** https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs

---

**Good luck with your deployment and submission!** 🚀
