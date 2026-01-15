# Project 4 - Part 2: Allow the nginx website to be accessible from the Internet

## Overview
This part deploys nginx to the Kubernetes cluster and exposes it to the internet using a LoadBalancer service.

## Prerequisites
- Part 1 completed (AKS cluster running)
- kubectl configured with cluster credentials
- Cluster has 2 nodes in Ready status

## Deployment Steps

### Step 1: Deploy nginx from DockerHub

**Screenshot_1.3: Command to deploy nginx into your cluster from DockerHub**
```bash
kubectl create deployment nginx-deployment --image=nginx:latest
```

Alternative using kubectl run:
```bash
kubectl run nginx-pod --image=nginx:latest
```

For deployment with 1 replica (recommended):
```bash
kubectl create deployment nginx-deployment --image=nginx:latest --replicas=1
```

### Step 2: Verify the Pod Deployment

**Screenshot_1.4: Command & result that verify the pod deployed in your cluster**
```bash
kubectl get pods
```
Expected output: 1 pod with STATUS "Running"

**Screenshot_1.5: Command & result that identify the state of deployment**
```bash
kubectl get deployment nginx-deployment
```
Expected output: READY 1/1, UP-TO-DATE 1, AVAILABLE 1

Alternative detailed view:
```bash
kubectl describe deployment nginx-deployment
```

### Step 3: Expose nginx to the Internet

**Screenshot_1.6: Command & result that makes the pod available from the internet**
```bash
kubectl expose deployment nginx-deployment --type=LoadBalancer --port=80 --target-port=80 --name=nginx-service
```

Verify service creation:
```bash
kubectl get service nginx-service
```

### Step 4: Get the Public IP Address

**Screenshot_1.7: Command & Result that identify the public IP address of the nginx-service**
```bash
kubectl get service nginx-service
```

Watch for EXTERNAL-IP (may take 1-2 minutes):
```bash
kubectl get service nginx-service --watch
```

Get just the IP:
```bash
kubectl get service nginx-service -o jsonpath='{.status.loadBalancer.ingress[0].ip}'
```

### Step 5: Access nginx in Browser

**Screenshot_1.8: Browser page showing message "Welcome to nginx!"**
1. Copy the EXTERNAL-IP from Step 4
2. Open browser and navigate to: `http://<EXTERNAL-IP>`
3. You should see the "Welcome to nginx!" page
4. Take a screenshot showing the full browser window with the URL and nginx welcome page

## Verification Commands

### Check all resources
```bash
# All resources
kubectl get all

# Detailed pod info
kubectl describe pod -l app=nginx-deployment

# Service details
kubectl describe service nginx-service

# Check logs
kubectl logs -l app=nginx-deployment
```

### Troubleshooting
If EXTERNAL-IP shows `<pending>`:
- Wait 1-2 minutes for Azure to provision the Load Balancer
- Check: `kubectl describe service nginx-service`
- Verify: `az aks show --resource-group rg-gladwell-aks --name aks-gladwell-cluster --query "networkProfile"`

## What Gets Created
- Kubernetes Deployment: `nginx-deployment` (1 replica)
- Kubernetes Service: `nginx-service` (LoadBalancer type)
- Azure Load Balancer (automatically provisioned)
- Public IP address (automatically assigned)

## Next Steps
After Part 2 is complete, proceed to Part 3 to scale the cluster and pods.

## Cleanup Commands (DO NOT RUN until project is complete)
```bash
kubectl delete service nginx-service
kubectl delete deployment nginx-deployment
```
