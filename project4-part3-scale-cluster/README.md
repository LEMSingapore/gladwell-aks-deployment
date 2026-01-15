# Project 4 - Part 3: Expand the Kubernetes Cluster

## Overview
This part demonstrates the scalability of Kubernetes by:
- Scaling cluster nodes from 2 to 3 (horizontal node scaling)
- Scaling pods from 2 to 10 (horizontal pod scaling)

This simulates handling increased traffic from 200 to 5000 visitors per day.

## Prerequisites
- Part 1 and Part 2 completed
- AKS cluster running with 2 nodes
- nginx-deployment running with 1 pod
- nginx-service exposed to internet

## Scaling Operations

### Step 1: Scale Cluster Nodes (2 → 3)

**Screenshot_1.9: Command and result of scaling the cluster nodes from 2 to 3 units**
```bash
az aks scale --resource-group rg-gladwell-aks --name aks-gladwell-cluster --node-count 3
```

This operation takes approximately 3-5 minutes.

**Screenshot_1.10: Command and result that show the list of nodes**
```bash
kubectl get nodes
```
Expected output: 3 nodes in "Ready" status

Alternative detailed view:
```bash
kubectl get nodes -o wide
```

### Step 2: Scale Pods (1 → 2, then 2 → 10)

First, scale to 2 replicas to prepare for distributed scaling:
```bash
kubectl scale deployment nginx-deployment --replicas=2
```

**Screenshot_1.11: Command that scales the pods from 2 to 10 units across distributed cluster nodes**
```bash
kubectl scale deployment nginx-deployment --replicas=10
```

**Screenshot_1.12: Command and result showing the list of pods created**
```bash
kubectl get pods
```
Expected output: 10 pods with STATUS "Running"

Alternative view with more details:
```bash
kubectl get pods -o wide
```

**Screenshot_1.13: Command and result that show the pod distribution across cluster nodes**
```bash
kubectl get pods -o wide
```
This shows which NODE each pod is running on. You should see pods distributed across all 3 nodes.

Alternative detailed view:
```bash
kubectl get pods -o custom-columns=NAME:.metadata.name,STATUS:.status.phase,NODE:.spec.nodeName
```

## Verification Commands

### Check scaling status
```bash
# Deployment status
kubectl get deployment nginx-deployment

# Replica set status
kubectl get replicaset

# Pod distribution summary
kubectl get pods -o wide | awk '{print $7}' | sort | uniq -c
```

### Monitor resource usage
```bash
# Node resource usage
kubectl top nodes

# Pod resource usage
kubectl top pods
```

### Detailed deployment info
```bash
kubectl describe deployment nginx-deployment
```

## Answer: 3 Differences Between Scaling VMs vs Containers

### 1. Speed and Efficiency
- **Virtual Machines**: Scaling takes 5-15 minutes per VM because you need to provision entire OS instances. Each VM requires full OS overhead (GB of memory, CPU for OS processes).
- **Containers**: Scaling takes seconds because containers share the host OS kernel. Only the application and its dependencies need to be started.

### 2. Resource Utilization
- **Virtual Machines**: Each VM includes a complete OS, requiring significant resources (typically 2+ GB RAM minimum). Less efficient resource utilization with higher overhead.
- **Containers**: Containers are lightweight (MB-sized), allowing many more instances on the same hardware. Better resource density and utilization.

### 3. Granularity and Flexibility
- **Virtual Machines**: Scaling unit is the entire VM. You scale by adding/removing whole VMs, which is coarse-grained and may result in over-provisioning.
- **Containers**: Scaling unit is the individual container. Fine-grained scaling allows you to precisely match workload demands. Can scale from 2 to 10 instances in seconds.

### Additional Context:
- **Cost**: Container scaling is more cost-effective as you pay for the actual compute nodes (3 nodes in our case) and can run many containers on them. VM scaling requires paying for each VM.
- **Management**: Kubernetes automates container orchestration, health checks, and distribution. VM scaling requires more manual intervention or complex auto-scaling configurations.
- **Startup Time**: Container: seconds, VM: minutes

## Auto-Scaling (Bonus)

### Horizontal Pod Autoscaler
```bash
# Enable metrics-server if not already enabled
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml

# Create HPA to auto-scale based on CPU usage
kubectl autoscale deployment nginx-deployment --cpu-percent=70 --min=2 --max=50

# Check HPA status
kubectl get hpa
```

### Cluster Autoscaler
Azure AKS can automatically scale nodes based on pod resource requests. This would be configured in the Terraform (not required for this project).

## Testing Load Distribution

### Access the service from multiple clients
```bash
# Get the external IP
EXTERNAL_IP=$(kubectl get service nginx-service -o jsonpath='{.status.loadBalancer.ingress[0].ip}')

# Test with curl (run multiple times)
for i in {1..20}; do
  curl -s -o /dev/null -w "Request $i: %{http_code}\n" http://$EXTERNAL_IP
done
```

### Check which pods are serving requests
```bash
# View access logs from all pods
kubectl logs -l app=nginx-deployment --tail=5
```

## Cleanup (DO NOT RUN until project is complete)
```bash
# Scale down pods
kubectl scale deployment nginx-deployment --replicas=1

# Scale down nodes
az aks scale --resource-group rg-gladwell-aks --name aks-gladwell-cluster --node-count 2

# Delete all resources
kubectl delete service nginx-service
kubectl delete deployment nginx-deployment
cd ../project4-part1-aks-cluster
terraform destroy -auto-approve
```

## Cost Impact
- Scaling from 2 to 3 nodes increases cost by ~$70/month in production
- For testing: ~$2.50 additional for a few hours
- **IMPORTANT**: Scale back down or destroy resources after testing to avoid charges
