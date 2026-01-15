# Project 4 - Part 1: Setting up Kubernetes Cluster

## Overview
This part creates the AKS (Azure Kubernetes Service) cluster infrastructure with 2 nodes for Gladwell Engineering's website.

## What Gets Deployed
- Azure Resource Group: `rg-gladwell-aks`
- AKS Cluster: `aks-gladwell-cluster`
- 2 worker nodes (Standard_D2s_v3)
- Kubernetes version 1.33

## Prerequisites
- Azure CLI installed and logged in (`az login`)
- Terraform installed (>= 1.0)

## Deployment Steps

### 1. Initialize Terraform
```bash
cd project4-part1-aks-cluster
terraform init
```

### 2. Review the Plan
```bash
terraform plan
```

### 3. Deploy the Cluster
```bash
terraform apply -auto-approve
```
This will take approximately 5-10 minutes.

### 4. Get Cluster Credentials
```bash
az aks get-credentials --resource-group rg-gladwell-aks --name aks-gladwell-cluster
```

### 5. Verify Cluster
```bash
# Check nodes
kubectl get nodes

# Check cluster info
kubectl cluster-info
```

## Required Screenshots for Part 1

### Screenshot_1.1: Properties of your AKS-cluster
```bash
# In Azure Portal, navigate to the AKS cluster and capture the Overview page
# OR use CLI:
az aks show --resource-group rg-gladwell-aks --name aks-gladwell-cluster --output table
```

### Screenshot_1.2: Command & result that verify the status of nodes in your cluster
```bash
kubectl get nodes
```
Expected output: 2 nodes in "Ready" status

## Next Steps
After Part 1 is complete, proceed to Part 2 to deploy nginx and expose it to the internet.

## Cleanup (DO NOT RUN until project is complete)
```bash
terraform destroy -auto-approve
```

## Cost Estimate
- ~$170/month for production use
- ~$5 for testing (covered by Azure free tier $200 credit)
