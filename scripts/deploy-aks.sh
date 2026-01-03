#!/bin/bash

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}"
echo "=============================================="
echo "  Gladwell Engineering AKS Deployment"
echo "  Project 4 - Part 1"
echo "=============================================="
echo -e "${NC}"

# Function to prompt user
prompt_continue() {
    echo -e "${YELLOW}Press Enter to continue...${NC}"
    read
}

# Function to check command success
check_status() {
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✓ Success${NC}"
    else
        echo -e "${RED}✗ Failed${NC}"
        echo -e "${RED}Please fix the error above and try again${NC}"
        exit 1
    fi
}

echo -e "${BLUE}Step 1: Verify Azure CLI is installed${NC}"
if command -v az &> /dev/null; then
    echo -e "${GREEN}✓ Azure CLI is installed${NC}"
    az version --output table
else
    echo -e "${RED}✗ Azure CLI not found${NC}"
    echo "Please run ./setup-azure-tools.sh first"
    exit 1
fi

prompt_continue

echo ""
echo -e "${BLUE}Step 2: Login to Azure${NC}"
echo "This will open a browser window for authentication..."
az login
check_status

echo ""
echo -e "${GREEN}Successfully logged in!${NC}"
echo "Your subscriptions:"
az account list --output table

prompt_continue

echo ""
echo -e "${BLUE}Step 3: Set Active Subscription${NC}"
echo "If you have multiple subscriptions, set the one you want to use:"
echo ""
az account list --output table
echo ""
echo -e "${YELLOW}Enter subscription ID (or press Enter for default):${NC}"
read subscription_id

if [ ! -z "$subscription_id" ]; then
    az account set --subscription "$subscription_id"
    check_status
fi

echo ""
echo "Active subscription:"
az account show --output table

prompt_continue

echo ""
echo -e "${BLUE}Step 4: Navigate to Terraform directory${NC}"
cd terraform-aks || { echo -e "${RED}terraform-aks directory not found${NC}"; exit 1; }
echo -e "${GREEN}✓ In terraform-aks directory${NC}"
pwd

prompt_continue

echo ""
echo -e "${BLUE}Step 5: Initialize Terraform${NC}"
echo "Downloading Azure provider plugins..."
terraform init
check_status

prompt_continue

echo ""
echo -e "${BLUE}Step 6: Preview Deployment (Terraform Plan)${NC}"
echo "This shows what will be created..."
terraform plan
check_status

echo ""
echo -e "${YELLOW}Review the plan above. This will create:${NC}"
echo "  - Resource Group: rg-gladwell-aks"
echo "  - AKS Cluster: aks-gladwell-cluster"
echo "  - 2 x Standard_DS2_v2 nodes"
echo "  - Nginx deployment"
echo ""
echo -e "${YELLOW}Estimated cost: ~$0.30/hour (~$5 for testing)${NC}"

prompt_continue

echo ""
echo -e "${BLUE}Step 7: Deploy AKS Cluster${NC}"
echo -e "${YELLOW}⏱  This will take 5-10 minutes...${NC}"
echo "Starting deployment..."
terraform apply -auto-approve
check_status

echo ""
echo -e "${GREEN}🎉 Deployment complete!${NC}"

prompt_continue

echo ""
echo -e "${BLUE}Step 8: Get Kubernetes Credentials${NC}"
az aks get-credentials \
  --resource-group rg-gladwell-aks \
  --name aks-gladwell-cluster \
  --overwrite-existing
check_status

echo ""
echo -e "${GREEN}✓ Kubernetes credentials configured${NC}"

prompt_continue

echo ""
echo -e "${BLUE}Step 9: Verify Cluster${NC}"

echo ""
echo "📸 SCREENSHOT 1.1: AKS Cluster Properties"
echo "=========================================="
az aks show \
  --resource-group rg-gladwell-aks \
  --name aks-gladwell-cluster \
  --output table

echo ""
echo -e "${YELLOW}📸 Take Screenshot 1.1 now!${NC}"
prompt_continue

echo ""
echo "📸 SCREENSHOT 1.2: Node Status"
echo "=============================="
kubectl get nodes -o wide

echo ""
echo -e "${YELLOW}📸 Take Screenshot 1.2 now!${NC}"
prompt_continue

echo ""
echo "📸 SCREENSHOT 1.3: Deploy Nginx"
echo "==============================="
echo "Command: kubectl create deployment nginx-deployment --image=nginx:latest"
echo ""
kubectl create deployment nginx-deployment --image=nginx:latest 2>/dev/null || echo "(Already deployed via Terraform)"

echo ""
echo -e "${YELLOW}📸 Take Screenshot 1.3 now!${NC}"
prompt_continue

echo ""
echo "Waiting for nginx pod to be ready..."
kubectl wait --for=condition=ready pod -l app=nginx --timeout=120s
check_status

echo ""
echo "📸 SCREENSHOT 1.4: Verify Pods"
echo "=============================="
kubectl get pods -o wide

echo ""
echo -e "${YELLOW}📸 Take Screenshot 1.4 now!${NC}"
prompt_continue

echo ""
echo "📸 SCREENSHOT 1.5: Deployment State"
echo "==================================="
kubectl get deployment nginx-deployment -o wide

echo ""
echo -e "${YELLOW}📸 Take Screenshot 1.5 now!${NC}"
prompt_continue

echo ""
echo -e "${BLUE}Step 10: Get Nginx External IP (Optional)${NC}"
echo "Waiting for LoadBalancer external IP..."
kubectl get service nginx-service --watch &
WATCH_PID=$!
sleep 30
kill $WATCH_PID 2>/dev/null

echo ""
kubectl get service nginx-service

EXTERNAL_IP=$(kubectl get service nginx-service -o jsonpath='{.status.loadBalancer.ingress[0].ip}')

if [ ! -z "$EXTERNAL_IP" ]; then
    echo ""
    echo -e "${GREEN}✓ Nginx is accessible at: http://$EXTERNAL_IP${NC}"
    echo "You can test it in your browser!"
else
    echo ""
    echo -e "${YELLOW}External IP pending... Check later with:${NC}"
    echo "  kubectl get service nginx-service"
fi

echo ""
echo -e "${GREEN}"
echo "=============================================="
echo "  ✓ Deployment Complete!"
echo "=============================================="
echo -e "${NC}"

echo ""
echo "Summary:"
echo "  ✓ AKS Cluster created (2 nodes)"
echo "  ✓ Nginx deployed"
echo "  ✓ All 5 screenshots captured"
echo ""
echo "What's deployed:"
kubectl get all

echo ""
echo -e "${BLUE}Important:${NC}"
echo "1. All required screenshots should be captured"
echo "2. Add screenshots to your DOCX document"
echo "3. Submit Project4-Part1-AKS-Kubernetes-Solution.docx"
echo ""
echo -e "${YELLOW}To clean up resources (avoid charges):${NC}"
echo "  cd terraform-aks"
echo "  terraform destroy"
echo ""
echo -e "${GREEN}Good luck with your submission!${NC}"
