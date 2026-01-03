#!/bin/bash

# Verification script for Project 5 Part 1
# This script verifies the deployment and collects information for screenshots

set -e

RESOURCE_GROUP="newland-resources"

# Color codes
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}Deployment Verification${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""

# Check if resource group exists
if ! az group show --name "$RESOURCE_GROUP" &> /dev/null; then
    echo -e "${RED}Error: Resource group '$RESOURCE_GROUP' not found${NC}"
    echo "Please run the deployment script first"
    exit 1
fi

# Screenshot 2.1: Deployment command and result
echo -e "${BLUE}[Screenshot 2.1] Latest Deployment Status:${NC}"
echo -e "${YELLOW}Command: az deployment group list --resource-group $RESOURCE_GROUP --output table${NC}"
az deployment group list --resource-group "$RESOURCE_GROUP" --output table
echo ""

# Screenshot 2.2: Inbound security rules
echo -e "${BLUE}[Screenshot 2.2] Inbound Security Rules:${NC}"
echo -e "${YELLOW}Command: az network nsg rule list --resource-group $RESOURCE_GROUP --nsg-name newland-nsg --output table${NC}"
az network nsg rule list \
    --resource-group "$RESOURCE_GROUP" \
    --nsg-name "newland-nsg" \
    --output table
echo ""

# Show detailed security rule
echo -e "${YELLOW}Detailed AllowRDP Rule:${NC}"
az network nsg rule show \
    --resource-group "$RESOURCE_GROUP" \
    --nsg-name "newland-nsg" \
    --name "AllowRDP" \
    --output table
echo ""

# Screenshots 2.3, 2.4, 2.5: Private IP addresses
echo -e "${BLUE}[Screenshots 2.3-2.5] Private IP Address Assignments:${NC}"
echo -e "${YELLOW}After connecting via RDP, run 'ipconfig' in each VM${NC}"
echo ""

for i in 0 1 2; do
    echo -e "${GREEN}VM$i Configuration:${NC}"

    # Get NIC details
    NIC_INFO=$(az network nic show \
        --resource-group "$RESOURCE_GROUP" \
        --name "newland-nic$i" \
        --query "{PrivateIP:ipConfigurations[0].privateIPAddress, Subnet:ipConfigurations[0].subnet.id}" -o json)

    PRIVATE_IP=$(echo $NIC_INFO | jq -r '.PrivateIP')
    SUBNET=$(echo $NIC_INFO | jq -r '.Subnet' | awk -F'/' '{print $(NF)}')

    echo "  VM Name: newland-vm$i"
    echo "  Private IP: $PRIVATE_IP"
    echo "  Subnet: $SUBNET"

    # Get public IP for RDP
    PUBLIC_IP=$(az network public-ip show \
        --resource-group "$RESOURCE_GROUP" \
        --name "newland-pip$i" \
        --query "ipAddress" -o tsv)
    echo "  Public IP (for RDP): $PUBLIC_IP"

    # Get VM status
    VM_STATUS=$(az vm show \
        --resource-group "$RESOURCE_GROUP" \
        --name "newland-vm$i" \
        --show-details \
        --query "powerState" -o tsv)
    echo "  Status: $VM_STATUS"
    echo ""
done

# Verify subnet assignments
echo -e "${BLUE}Subnet Assignment Verification:${NC}"
echo "Expected subnet assignments:"
echo "  VM0: Should be in subnet-marketing (10.1.0.0/24)"
echo "  VM1: Should be in subnet-software (10.1.1.0/24)"
echo "  VM2: Should be in subnet-network (10.1.2.0/24)"
echo ""

# RDP Connection Instructions
echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}RDP Connection Instructions${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""
echo "To complete screenshots 2.3, 2.4, and 2.5:"
echo ""
echo "1. Connect to each VM using Remote Desktop:"
for i in 0 1 2; do
    PUBLIC_IP=$(az network public-ip show \
        --resource-group "$RESOURCE_GROUP" \
        --name "newland-pip$i" \
        --query "ipAddress" -o tsv)
    echo "   - VM$i: mstsc /v:$PUBLIC_IP"
done
echo ""
echo "2. Login credentials:"
echo "   Username: admin123"
echo "   Password: Azure123"
echo ""
echo "3. Once connected, open Command Prompt and run:"
echo "   ipconfig"
echo ""
echo "4. Take a screenshot showing:"
echo "   - The ipconfig output"
echo "   - The private IP address (should match the IP shown above)"
echo "   - The VM name in the title bar or prompt"
echo ""

# Resource summary
echo -e "${BLUE}Resource Summary:${NC}"
echo "Resource Group: $RESOURCE_GROUP"
az resource list --resource-group "$RESOURCE_GROUP" --output table
echo ""

echo -e "${GREEN}Verification complete!${NC}"
echo ""
