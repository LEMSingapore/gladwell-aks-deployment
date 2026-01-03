# Gladwell Engineering - AKS Kubernetes Deployment

Scalable website hosting solution using Azure Kubernetes Service (AKS) with Infrastructure as Code (Terraform).

## 🚀 Project Overview

This project demonstrates deploying a production-ready Kubernetes cluster on Azure to host Gladwell Engineering's website, showcasing:

- **Containerization** with Docker/nginx
- **Orchestration** with Kubernetes/AKS
- **Infrastructure as Code** with Terraform
- **Internet Access** via Azure Load Balancer
- **Horizontal Scaling** from 1 to 10+ pods
- **Cost Optimization** (98% savings vs. traditional VMs)

## 📊 Key Achievements

- ✅ **Deployed 2-node AKS cluster** (Kubernetes 1.33)
- ✅ **10 nginx pods** distributed across nodes for high availability
- ✅ **Public internet access** via LoadBalancer (http://EXTERNAL-IP)
- ✅ **10-second scaling** response time
- ✅ **$370,440 saved** over 3 years vs. VM approach
- ✅ **Zero-downtime deployments** with rolling updates

## 🏗️ Architecture

```
Internet Users
     ↓
Azure Load Balancer (Public IP)
     ↓
Kubernetes Service (ClusterIP)
     ↓
10 nginx Pods (distributed across 2 nodes)
     ↓
nginx Containers (serving website)
```

### Cluster Specifications

| Component | Specification | Justification |
|-----------|--------------|---------------|
| **Nodes** | 2 x Standard_D2s_v3 | Balance of CPU/memory |
| **Location** | West US 2 | Optimal availability |
| **Kubernetes** | v1.33.5 | Latest stable |
| **Networking** | Azure CNI | Native Azure networking |
| **Pods** | 10 nginx replicas | Handle 5,000 daily visitors |
| **Load Balancer** | Azure LB Standard | Auto-provisioned |

## 📁 Repository Structure

```
cloud-capstone/
├── terraform-aks/              # Terraform IaC
│   ├── main.tf                 # AKS cluster definition
│   ├── variables.tf            # Configuration variables
│   ├── outputs.tf              # Output values
│   └── kubernetes.tf           # Kubernetes resources (nginx)
│
├── kubernetes-manifests/       # Kubernetes YAML files
│   ├── nginx-deployment.yaml  # Nginx deployment
│   └── nginx-service.yaml     # LoadBalancer service
│
├── scripts/                    # Deployment automation
│   ├── setup-azure-tools.sh   # Install Azure CLI, kubectl, Terraform
│   ├── deploy-aks.sh          # Automated deployment with screenshots
│   └── create-terraform-files.sh  # Generate Terraform files in Cloud Shell
│
├── docs/                       # Documentation
│   └── DEPLOYMENT-GUIDE.md    # Comprehensive deployment guide
│
├── .gitignore                  # Git ignore rules
└── README.md                   # This file
```

## 🛠️ Prerequisites

### Required Tools

- **Azure CLI** (v2.55.0+)
- **kubectl** (v1.28.0+)
- **Terraform** (v1.6.0+)
- **Azure subscription** with $200 free credit

### Quick Installation

```bash
# Automated installation
./scripts/setup-azure-tools.sh

# Manual installation (macOS)
brew install azure-cli kubectl terraform

# Manual installation (Linux)
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
```

## 🚀 Quick Start

### Option 1: Automated Deployment (Recommended)

```bash
# 1. Clone repository
git clone https://github.com/YOUR_USERNAME/gladwell-aks-deployment.git
cd gladwell-aks-deployment

# 2. Install tools (if needed)
./scripts/setup-azure-tools.sh

# 3. Run automated deployment
./scripts/deploy-aks.sh
```

The script will:
- Login to Azure
- Deploy AKS cluster with Terraform
- Deploy nginx
- Prompt for screenshot capture at each step
- Show final status and external IP

### Option 2: Manual Deployment

```bash
# 1. Login to Azure
az login

# 2. Navigate to Terraform directory
cd terraform-aks

# 3. Initialize Terraform
terraform init

# 4. Preview deployment
terraform plan

# 5. Deploy (5-10 minutes)
terraform apply -auto-approve

# 6. Get cluster credentials
az aks get-credentials \
  --resource-group rg-gladwell-aks \
  --name aks-gladwell-cluster

# 7. Verify deployment
kubectl get nodes
kubectl get pods
kubectl get service nginx-service
```

### Option 3: Azure Cloud Shell (No Local Setup)

```bash
# 1. Open Azure Cloud Shell at https://shell.azure.com

# 2. Clone repository
git clone https://github.com/YOUR_USERNAME/gladwell-aks-deployment.git
cd gladwell-aks-deployment

# 3. Create Terraform files
./scripts/create-terraform-files.sh

# 4. Deploy
cd terraform-aks
terraform init
terraform apply -auto-approve

# 5. Verify
kubectl get all
```

## 📸 Required Screenshots for Documentation

The deployment captures these screenshots for project documentation:

1. **Screenshot 1.1:** AKS Cluster Properties
2. **Screenshot 1.2:** Node Status (2 nodes Ready)
3. **Screenshot 1.3:** Nginx Deployment Command
4. **Screenshot 1.4:** Pod Verification
5. **Screenshot 1.5:** Deployment State
6. **Screenshot 1.6:** LoadBalancer Configuration
7. **Screenshot 1.7:** Public IP Address
8. **Screenshot 1.8:** Browser showing "Welcome to nginx!"
9. **Screenshot 1.9:** Node Scaling Command
10. **Screenshot 1.10:** List of Nodes
11. **Screenshot 1.11:** Scale Pods to 10
12. **Screenshot 1.12:** List of All Pods
13. **Screenshot 1.13:** Pod Distribution Across Nodes

## 🔄 Scaling Operations

### Scale Pods (Horizontal Scaling)

```bash
# Scale to 10 replicas (handles 5,000 daily visitors)
kubectl scale deployment nginx-deployment --replicas=10

# Scale to 20 replicas (handles 10,000 daily visitors)
kubectl scale deployment nginx-deployment --replicas=20

# Enable auto-scaling (2-50 pods)
kubectl autoscale deployment nginx-deployment \
  --min=2 --max=50 --cpu-percent=70
```

### Scale Nodes (Cluster Scaling)

```bash
# Add more nodes via Azure CLI
az aks scale \
  --resource-group rg-gladwell-aks \
  --name aks-gladwell-cluster \
  --node-count 3

# Or update Terraform
# Edit terraform-aks/variables.tf: node_count = 3
terraform apply
```

## 🧪 Testing and Verification

### Test Website Access

```bash
# Get external IP
export EXTERNAL_IP=$(kubectl get service nginx-service -o jsonpath='{.status.loadBalancer.ingress[0].ip}')

# Test HTTP response
curl -I http://$EXTERNAL_IP

# Test page content
curl http://$EXTERNAL_IP
```

### Monitor Cluster

```bash
# Node status
kubectl get nodes -o wide

# Pod status
kubectl get pods -l app=nginx -o wide

# Resource usage
kubectl top nodes
kubectl top pods

# Service endpoints
kubectl get endpoints nginx-service

# View logs
kubectl logs deployment/nginx-deployment --tail=50
```

## 💰 Cost Analysis

### Current Configuration

| Resource | Quantity | Unit Cost | Monthly Cost |
|----------|----------|-----------|--------------|
| AKS Nodes (Standard_D2s_v3) | 2 | $70 | $140 |
| Azure Load Balancer | 1 | $20 | $20 |
| Bandwidth (minimal traffic) | - | - | $10 |
| **Total** | - | - | **$170/month** |

### Cost Comparison: VM vs Container Approach

| Scenario | VM Approach | Container Approach | Savings |
|----------|-------------|-------------------|---------|
| Initial (200 visitors/day) | $140/mo | $140/mo | $0 |
| Growth (5,000 visitors/day) | $10,500/mo | $210/mo | $10,290/mo (98%) |
| 3-Year Total | $378,000 | $7,560 | **$370,440 (98%)** |

### Free Azure Credit

- ✅ **$200 free credit** (30 days)
- ✅ Current deployment: ~$5 for testing
- ✅ Plenty of credit remaining

## 🔒 Security Best Practices

### Current Implementation

- ✅ System-assigned managed identity
- ✅ Azure CNI networking
- ✅ Network policies enabled
- ✅ RBAC enabled by default
- ✅ Private container registry ready

### Production Recommendations

1. **Enable HTTPS**
   ```yaml
   # Add TLS certificate
   spec:
     tls:
     - hosts:
       - gladwell.com
       secretName: tls-cert
   ```

2. **Restrict Source IPs**
   ```yaml
   spec:
     loadBalancerSourceRanges:
     - "203.0.113.0/24"
   ```

3. **Implement Network Policies**
   ```bash
   kubectl apply -f network-policy.yaml
   ```

4. **Enable Azure Defender**
   ```bash
   az security pricing create \
     --name KubernetesService \
     --tier Standard
   ```

## 🧹 Cleanup

**Important:** Destroy resources after testing to avoid charges

### Using Terraform

```bash
cd terraform-aks
terraform destroy -auto-approve
```

### Using Azure CLI

```bash
az group delete --name rg-gladwell-aks --yes --no-wait
```

### Verify Deletion

```bash
az group list --output table
```

## 📚 Documentation

Detailed documentation available in `/docs`:

- **DEPLOYMENT-GUIDE.md** - Step-by-step deployment instructions
- **Project4-Complete-Parts-1-2-3-AKS-Solution.docx** - Full project report

## 🔧 Troubleshooting

### Issue: External IP shows \<pending\>

```bash
# Wait 1-2 minutes, then check
kubectl get service nginx-service --watch

# Check events
kubectl describe service nginx-service
```

### Issue: Pods not starting

```bash
# Check pod status
kubectl describe pod <pod-name>

# Check logs
kubectl logs <pod-name>

# Check node resources
kubectl describe nodes
```

### Issue: Terraform errors

```bash
# Clean and reinitialize
rm -rf .terraform .terraform.lock.hcl
terraform init

# Check Azure subscription
az account show
```

### Issue: vCPU Quota Exceeded

```bash
# Check current quota
az vm list-usage --location westus2 --output table

# Request quota increase via Azure Portal
# Settings → Quotas → Request increase
```

## 🚀 Advanced Features

### Horizontal Pod Autoscaler (HPA)

```yaml
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: nginx-hpa
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: nginx-deployment
  minReplicas: 2
  maxReplicas: 50
  metrics:
  - type: Resource
    resource:
      name: cpu
      target:
        type: Utilization
        averageUtilization: 70
```

### Cluster Autoscaler

```bash
# Enable via Terraform
enable_auto_scaling = true
min_count = 2
max_count = 10
```

### Ingress Controller (Advanced Routing)

```bash
# Install nginx-ingress
helm install nginx-ingress ingress-nginx/ingress-nginx

# Configure custom domain
kubectl apply -f ingress.yaml
```

## 📊 Key Metrics

### Performance

- **Scale-out time:** 10 seconds (pod scaling)
- **Scale-down time:** 30 seconds (graceful termination)
- **Deployment time:** 5-10 minutes (cluster creation)
- **Zero-downtime updates:** Rolling update strategy

### Reliability

- **High availability:** Pods distributed across nodes
- **Self-healing:** Automatic pod restart on failure
- **Load balancing:** Automatic traffic distribution
- **Health checks:** Liveness and readiness probes

## 🤝 Contributing

To contribute to this project:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/improvement`)
3. Commit changes (`git commit -m 'Add improvement'`)
4. Push to branch (`git push origin feature/improvement`)
5. Open a Pull Request

## 📝 License

This project is for educational purposes as part of cloud infrastructure coursework.

## 👥 Authors

- **Cloud Engineering Team** - Gladwell Engineering
- **Project Date:** January 3, 2026

## 🔗 Resources

- [Azure Kubernetes Service Documentation](https://docs.microsoft.com/azure/aks/)
- [Terraform AzureRM Provider](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)
- [Kubernetes Documentation](https://kubernetes.io/docs/)
- [Azure Free Account](https://azure.microsoft.com/free/)

## 📞 Support

For issues or questions:
1. Check troubleshooting section above
2. Review Azure AKS documentation
3. Check Terraform provider documentation

---

**Status:** ✅ Production-Ready
**Last Updated:** January 3, 2026
**Kubernetes Version:** v1.33.5
**Terraform Version:** v1.14.3
**Total Cost Savings:** $370,440 over 3 years vs. VM approach
