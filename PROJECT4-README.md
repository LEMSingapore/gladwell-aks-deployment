# Project 4: Designing a Scalable Kubernetes Solution

## Project Overview
Gladwell Engineering needs a scalable Kubernetes infrastructure to host their company website. This project demonstrates deploying, exposing, and scaling a Kubernetes cluster on Azure AKS.

## Three-Part Structure

### Part 1: Setting up company's website using Kubernetes cluster
- **Directory**: `project4-part1-aks-cluster/`
- **Technology**: Terraform
- **What it does**: Creates AKS cluster with 2 nodes
- **Screenshots**: 1.1, 1.2
- **Time**: ~5-10 minutes

### Part 2: Allow the nginx website to be accessible from the Internet
- **Directory**: `project4-part2-expose-nginx/`
- **Technology**: kubectl commands
- **What it does**: Deploys nginx container and exposes it via LoadBalancer
- **Screenshots**: 1.3, 1.4, 1.5, 1.6, 1.7, 1.8
- **Time**: ~3-5 minutes

### Part 3: Expand the Kubernetes Cluster
- **Directory**: `project4-part3-scale-cluster/`
- **Technology**: az aks and kubectl commands
- **What it does**: Scales nodes (2→3) and pods (2→10)
- **Screenshots**: 1.9, 1.10, 1.11, 1.12, 1.13
- **Time**: ~5-10 minutes

## Quick Start

### Complete Workflow
```bash
# Part 1: Deploy AKS cluster
cd project4-part1-aks-cluster
terraform init
terraform apply -auto-approve
az aks get-credentials --resource-group rg-gladwell-aks --name aks-gladwell-cluster

# Part 2: Deploy and expose nginx
cd ../project4-part2-expose-nginx
# Follow README.md for kubectl commands

# Part 3: Scale the cluster
cd ../project4-part3-scale-cluster
# Follow README.md for scaling commands
```

## Documentation Requirements

### Written Deliverables
1. **Advantages and Disadvantages of Containerization**
   - Advantages: Fast deployment, resource efficiency, portability, consistency, easy scaling
   - Disadvantages: Security concerns (shared kernel), complexity, learning curve, networking challenges

2. **Service Type Recommendation: Deployment**
   - **Recommendation**: Use Deployment (not StatefulSet or CronJob)
   - **Justification**:
     - Web applications are stateless
     - Deployment provides rolling updates and rollback capabilities
     - Easy horizontal scaling
     - Built-in health checks and self-healing
     - LoadBalancer service type exposes deployment to internet

3. **3 Differences Between Scaling VMs vs Containers**
   - See Part 3 README for detailed explanation
   - Speed: VMs (minutes) vs Containers (seconds)
   - Resources: VMs (GB overhead) vs Containers (MB overhead)
   - Granularity: VMs (coarse) vs Containers (fine-grained)

### Screenshot Requirements
Total: 13 screenshots showing commands and results for each step

## Architecture

```
Azure Resource Group: rg-gladwell-aks
├── AKS Cluster: aks-gladwell-cluster
│   ├── Node Pool (default)
│   │   ├── Node 1 (Standard_D2s_v3)
│   │   ├── Node 2 (Standard_D2s_v3)
│   │   └── Node 3 (Standard_D2s_v3) [Added in Part 3]
│   │
│   └── Workloads
│       ├── Deployment: nginx-deployment
│       │   └── Pods: 1 → 2 → 10 (scaled in Part 3)
│       │
│       └── Service: nginx-service (LoadBalancer)
│           └── External IP: <public-ip>
│
└── Azure Load Balancer (auto-provisioned)
```

## Prerequisites

### Required Tools
- Azure CLI (`az --version`)
- Terraform (`terraform --version`)
- kubectl (`kubectl version --client`)
- Azure subscription with credits

### Azure Login
```bash
az login
az account show
```

## Cost Management

### Estimated Costs
- **AKS (2 nodes)**: ~$140/month
- **AKS (3 nodes)**: ~$210/month
- **Load Balancer**: ~$20/month
- **Testing (few hours)**: ~$5 (covered by $200 free tier)

### Cost Optimization
```bash
# After completing all parts and taking screenshots:
cd project4-part1-aks-cluster
terraform destroy -auto-approve
```

## Troubleshooting

### Common Issues

**Issue 1: External IP shows `<pending>`**
- Wait 1-2 minutes for Azure to provision Load Balancer
- Check: `kubectl describe service nginx-service`

**Issue 2: Pods not starting**
- Check: `kubectl describe pod <pod-name>`
- Check: `kubectl logs <pod-name>`

**Issue 3: Terraform quota errors**
- Check vCPU quota: `az vm list-usage --location westus2 -o table`
- Try different VM size: `Standard_DS2_v2`

**Issue 4: kubectl not connecting**
- Get credentials: `az aks get-credentials --resource-group rg-gladwell-aks --name aks-gladwell-cluster`
- Verify: `kubectl cluster-info`

## Project Timeline
- **Part 1**: 10 minutes (Terraform deployment)
- **Part 2**: 5 minutes (kubectl commands)
- **Part 3**: 10 minutes (scaling operations)
- **Total**: ~25-30 minutes of active work

## Success Criteria
- ✅ AKS cluster with 2 nodes deployed
- ✅ nginx accessible via public IP
- ✅ Cluster scaled to 3 nodes
- ✅ Pods scaled to 10 replicas
- ✅ Pods distributed across nodes
- ✅ All 13 screenshots captured
- ✅ Documentation questions answered

## Additional Resources
- [Azure AKS Documentation](https://docs.microsoft.com/en-us/azure/aks/)
- [Kubernetes Documentation](https://kubernetes.io/docs/)
- [Terraform AzureRM Provider](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)

## Next Steps After Completion
1. Review all screenshots for clarity
2. Write report with containerization advantages/disadvantages
3. Explain service type recommendation (Deployment)
4. Explain VM vs Container scaling differences
5. Clean up resources to avoid charges
