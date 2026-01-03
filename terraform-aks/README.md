# Terraform IaC for Gladwell Engineering AKS Cluster

This directory contains Infrastructure as Code (Terraform) to deploy the Azure Kubernetes Service cluster for Gladwell Engineering.

## Prerequisites

1. **Azure CLI installed**
   ```bash
   curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
   ```

2. **Terraform installed**
   ```bash
   # Download and install Terraform 1.6+
   wget https://releases.hashicorp.com/terraform/1.6.0/terraform_1.6.0_linux_amd64.zip
   unzip terraform_1.6.0_linux_amd64.zip
   sudo mv terraform /usr/local/bin/
   ```

3. **Azure subscription**
   - Active subscription with Contributor role

## Deployment Steps

### Step 1: Login to Azure

```bash
# Login to Azure
az login

# Set subscription (if multiple)
az account set --subscription "Your-Subscription-Name"

# Verify
az account show
```

### Step 2: Initialize Terraform

```bash
# Navigate to this directory
cd terraform-aks

# Initialize Terraform
terraform init

# Output:
# Initializing the backend...
# Initializing provider plugins...
# - Finding hashicorp/azurerm versions matching "~> 3.0"...
# - Finding hashicorp/kubernetes versions matching "~> 2.23"...
# Terraform has been successfully initialized!
```

### Step 3: Plan Deployment

```bash
# Preview what will be created
terraform plan

# Review output:
# - azurerm_resource_group.aks will be created
# - azurerm_kubernetes_cluster.aks will be created
# - kubernetes_deployment.nginx will be created
# - kubernetes_service.nginx will be created
#
# Plan: 4 to add, 0 to change, 0 to destroy
```

### Step 4: Deploy Infrastructure

```bash
# Deploy (takes 5-10 minutes)
terraform apply

# Type 'yes' when prompted
# Or use auto-approve:
terraform apply -auto-approve
```

### Step 5: Get Kubectl Credentials

```bash
# Get cluster credentials
az aks get-credentials \
  --resource-group rg-gladwell-aks \
  --name aks-gladwell-cluster

# Or using Terraform output:
terraform output -raw kube_config > ~/.kube/config
```

### Step 6: Verify Deployment

```bash
# Verify nodes (Screenshot 1.2)
kubectl get nodes -o wide

# Verify nginx pod (Screenshot 1.4)
kubectl get pods -o wide

# Verify deployment (Screenshot 1.5)
kubectl get deployment nginx-deployment -o wide

# Get service external IP
kubectl get service nginx-service

# Wait for EXTERNAL-IP (takes 1-2 minutes)
# Then test: curl http://<EXTERNAL-IP>
```

## Screenshots for Submission

### Screenshot 1.1: AKS Cluster Properties
```bash
az aks show \
  --resource-group rg-gladwell-aks \
  --name aks-gladwell-cluster \
  --output table
```

### Screenshot 1.2: Node Status
```bash
kubectl get nodes -o wide
```

### Screenshot 1.3: Deploy Nginx
```bash
# If using manual kubectl (not Terraform):
kubectl create deployment nginx-deployment --image=nginx:latest
```

### Screenshot 1.4: Verify Pods
```bash
kubectl get pods -o wide
```

### Screenshot 1.5: Deployment State
```bash
kubectl get deployment nginx-deployment -o wide
```

## Cleanup

```bash
# Destroy all resources
terraform destroy

# Type 'yes' when prompted
# Or: terraform destroy -auto-approve
```

## Customization

Edit `variables.tf` to customize:
- `node_count`: Number of nodes (default: 2)
- `node_vm_size`: VM size (default: Standard_DS2_v2)
- `location`: Azure region (default: eastus)
- `kubernetes_version`: Kubernetes version (default: 1.28)

## Troubleshooting

**Issue: Terraform init fails**
```bash
# Clear cache and retry
rm -rf .terraform .terraform.lock.hcl
terraform init
```

**Issue: Azure authentication fails**
```bash
# Re-login
az login
az account show
```

**Issue: Cluster creation times out**
```bash
# Check Azure portal for status
# May need to increase timeout or try different region
```

## Cost Estimate

- 2 x Standard_DS2_v2 nodes: ~$140/month
- Load Balancer: ~$20/month
- Total: ~$160-170/month

## Files

- `main.tf`: AKS cluster and resource group
- `variables.tf`: Configuration variables
- `outputs.tf`: Output values
- `kubernetes.tf`: Nginx deployment and service
