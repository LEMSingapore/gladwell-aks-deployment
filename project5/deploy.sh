#!/bin/bash

# Project 5 Part 1 - Batch VM Deployment Script
# This script deploys 3 Windows Server VMs for Newland Solutions using ARM templates

set -e  # Exit on error

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Configuration
RESOURCE_GROUP="newland-resources"
LOCATION="eastus"
DEPLOYMENT_NAME="newland-vm-deployment-$(date +%Y%m%d-%H%M%S)"
TEMPLATE_FILE="az-capstone-vms-loop-template.json"
PARAMETERS_FILE="az-capstone-vms-loop-parameters.json"

echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}Newland Solutions - VM Batch Deployment${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""

# Check if Azure CLI is installed
if ! command -v az &> /dev/null; then
    echo -e "${RED}Error: Azure CLI is not installed${NC}"
    echo "Please install Azure CLI from: https://docs.microsoft.com/cli/azure/install-azure-cli"
    exit 1
fi

# Check if logged in to Azure
echo -e "${YELLOW}Checking Azure login status...${NC}"
if ! az account show &> /dev/null; then
    echo -e "${RED}Error: Not logged in to Azure${NC}"
    echo "Please run: az login"
    exit 1
fi

SUBSCRIPTION=$(az account show --query name -o tsv)
echo -e "${GREEN}Logged in to Azure subscription: ${SUBSCRIPTION}${NC}"
echo ""

# Check if template files exist
if [ ! -f "$TEMPLATE_FILE" ]; then
    echo -e "${RED}Error: Template file not found: $TEMPLATE_FILE${NC}"
    exit 1
fi

if [ ! -f "$PARAMETERS_FILE" ]; then
    echo -e "${RED}Error: Parameters file not found: $PARAMETERS_FILE${NC}"
    exit 1
fi

# Create resource group
echo -e "${YELLOW}Step 1: Creating resource group...${NC}"
if az group show --name "$RESOURCE_GROUP" &> /dev/null; then
    echo -e "${YELLOW}Resource group '$RESOURCE_GROUP' already exists${NC}"
else
    az group create --name "$RESOURCE_GROUP" --location "$LOCATION"
    echo -e "${GREEN}Resource group created: $RESOURCE_GROUP${NC}"
fi
echo ""

# Validate template
echo -e "${YELLOW}Step 2: Validating ARM template...${NC}"
if az deployment group validate \
    --resource-group "$RESOURCE_GROUP" \
    --template-file "$TEMPLATE_FILE" \
    --parameters "$PARAMETERS_FILE" &> /dev/null; then
    echo -e "${GREEN}Template validation successful${NC}"
else
    echo -e "${RED}Template validation failed${NC}"
    exit 1
fi
echo ""

# Deploy template
echo -e "${YELLOW}Step 3: Deploying VMs (this may take 10-15 minutes)...${NC}"
echo -e "${YELLOW}Deployment name: $DEPLOYMENT_NAME${NC}"
echo ""

az deployment group create \
    --name "$DEPLOYMENT_NAME" \
    --resource-group "$RESOURCE_GROUP" \
    --template-file "$TEMPLATE_FILE" \
    --parameters "$PARAMETERS_FILE"

if [ $? -eq 0 ]; then
    echo ""
    echo -e "${GREEN}========================================${NC}"
    echo -e "${GREEN}Deployment completed successfully!${NC}"
    echo -e "${GREEN}========================================${NC}"
    echo ""
else
    echo -e "${RED}Deployment failed${NC}"
    exit 1
fi

# Get deployment outputs
echo -e "${YELLOW}Step 4: Retrieving deployment information...${NC}"
echo ""

# List VMs
echo -e "${GREEN}Virtual Machines:${NC}"
az vm list --resource-group "$RESOURCE_GROUP" --output table
echo ""

# Get public IPs
echo -e "${GREEN}Public IP Addresses for RDP:${NC}"
az network public-ip list --resource-group "$RESOURCE_GROUP" --output table
echo ""

# Get private IPs
echo -e "${GREEN}Private IP Addresses:${NC}"
for i in 0 1 2; do
    PRIVATE_IP=$(az network nic show \
        --resource-group "$RESOURCE_GROUP" \
        --name "newland-nic$i" \
        --query "ipConfigurations[0].privateIPAddress" -o tsv)
    echo "  newland-vm$i: $PRIVATE_IP"
done
echo ""

# Get NSG rules
echo -e "${GREEN}Network Security Group Rules:${NC}"
az network nsg rule list \
    --resource-group "$RESOURCE_GROUP" \
    --nsg-name "newland-nsg" \
    --output table
echo ""

# Display RDP connection info
echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}RDP Connection Information${NC}"
echo -e "${GREEN}========================================${NC}"
echo "Username: admin123"
echo "Password: Azure123"
echo ""
echo "To connect via RDP, use the public IP addresses listed above"
echo ""

# Display next steps
echo -e "${YELLOW}Next Steps:${NC}"
echo "1. Connect to each VM via RDP using the public IP addresses"
echo "2. Run 'ipconfig' in each VM to verify private IP addresses"
echo "3. Take screenshots as required for the project submission"
echo ""
echo -e "${YELLOW}To delete all resources:${NC}"
echo "  az group delete --name $RESOURCE_GROUP --yes --no-wait"
echo ""
