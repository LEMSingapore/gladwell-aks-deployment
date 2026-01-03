# Project 5 - Part 1: Batch-Deploying Virtual Machines using JSON Template

## Project Overview

This project implements a sustainable resource-deployment solution for Newland Solutions, a versatile company with three service departments:
- Marketing Service (Subnet 0)
- Software Development (Subnet 1)
- Network Consultancy (Subnet 2)

The goal is to deploy one virtual server to each department using Azure Resource Manager (ARM) templates to ensure consistent and standardized configuration.

## Advantages of Batch Deployment Using Templates

### 1. Consistency and Standardization
- **Uniform Configuration**: All VMs are deployed with identical settings, eliminating configuration drift
- **Reduced Human Error**: Automated deployment minimizes manual mistakes in configuration
- **Version Control**: Templates can be stored in git repositories for tracking changes over time

### 2. Efficiency and Speed
- **Time Savings**: Deploy multiple VMs simultaneously instead of configuring each one individually
- **Parallel Deployment**: Azure processes multiple resource deployments concurrently
- **Reduced Administrative Overhead**: Single command deploys entire infrastructure

### 3. Scalability
- **Easy Replication**: Add more VMs by simply adjusting the copy count parameter
- **Department Expansion**: Can quickly scale resources when new departments are added
- **Infrastructure as Code**: Template-based approach supports rapid infrastructure scaling

### 4. Repeatability and Testing
- **Predictable Outcomes**: Same template produces identical results every time
- **Environment Parity**: Easily replicate dev, test, and production environments
- **Disaster Recovery**: Quickly rebuild infrastructure from templates if needed

### 5. Documentation and Audit Trail
- **Self-Documenting**: Template serves as documentation of infrastructure configuration
- **Compliance**: Easier to demonstrate compliance with organizational standards
- **Change Management**: Template versions track infrastructure evolution

### 6. Cost Management
- **Resource Optimization**: Ensures all VMs use specified, cost-effective SKUs
- **Reduced Deployment Time**: Less time spent on manual configuration reduces labor costs
- **Standardized Resources**: Easier to track and manage Azure spending

### 7. Maintenance and Updates
- **Centralized Updates**: Modify template once to update all future deployments
- **Consistent Patching**: All VMs start from same baseline configuration
- **Simplified Troubleshooting**: Standardized configurations are easier to diagnose

## VM Specifications

| Parameter | Value |
|-----------|-------|
| VM Size | Standard_D2s_v3 |
| VM Name Prefix | newland-vm |
| Virtual Network | newland-vnet |
| NIC Name Prefix | newland-nic |
| Admin Username | admin123 |
| Admin Password | Azure123 |
| Operating System | WindowsServer 2019-Datacenter (Microsoft) |
| Address Space | 10.1.0.0/16 |

## Subnet Configuration

| Department | Subnet Name | Address Range |
|------------|-------------|---------------|
| Marketing Service | subnet-marketing | 10.1.0.0/24 |
| Software Development | subnet-software | 10.1.1.0/24 |
| Network Consultancy | subnet-network | 10.1.2.0/24 |

## Deployment Instructions

### Prerequisites
1. Azure subscription
2. Azure CLI installed and configured
3. Appropriate permissions to create resources

### Step 1: Create Resource Group
```bash
az group create --name newland-resources --location eastus
```

### Step 2: Deploy VMs using Template
```bash
az deployment group create \
  --name newland-vm-deployment \
  --resource-group newland-resources \
  --template-file az-capstone-vms-loop-template.json \
  --parameters az-capstone-vms-loop-parameters.json
```

### Step 3: Verify Deployment
```bash
# List all VMs in the resource group
az vm list --resource-group newland-resources --output table

# Show VM details
az vm show --resource-group newland-resources --name newland-vm0
az vm show --resource-group newland-resources --name newland-vm1
az vm show --resource-group newland-resources --name newland-vm2

# Get public IP addresses for RDP access
az network public-ip list --resource-group newland-resources --output table
```

### Step 4: Connect via RDP
1. Get the public IP address of each VM from the deployment outputs
2. Use Remote Desktop Connection (mstsc) on Windows or Microsoft Remote Desktop on macOS
3. Connect using:
   - Username: admin123
   - Password: Azure123

### Step 5: Verify Private IP Configuration
Once connected to each VM via RDP:
1. Open Command Prompt
2. Run: `ipconfig`
3. Verify the private IP address matches the subnet assignment:
   - VM0 should have IP in 10.1.0.0/24 range
   - VM1 should have IP in 10.1.1.0/24 range
   - VM2 should have IP in 10.1.2.0/24 range

## Template Architecture

### Main Template (az-capstone-vms-loop-template.json)
The template uses ARM's **copy** function to batch-deploy resources:

1. **Network Security Group**: Single NSG with RDP rule (port 3389) applied to all subnets
2. **Virtual Network**: Creates newland-vnet with three subnets
3. **Public IP Addresses**: Uses copy loop to create 3 public IPs (one per VM)
4. **Network Interfaces**: Uses copy loop to create 3 NICs, each assigned to a different subnet
5. **Virtual Machines**: Uses copy loop to create 3 VMs with identical specifications

### Parameters File (az-capstone-vms-loop-parameters.json)
Contains all configuration values:
- VM naming conventions
- Network configuration
- Administrator credentials
- OS version selection
- VM count for loop deployment

## Security Considerations

**Note**: This project uses simplified credentials for educational purposes. In production environments:
- Use Azure Key Vault for password management
- Implement Just-In-Time (JIT) VM access instead of open RDP ports
- Use Azure Bastion for secure RDP/SSH access
- Enable Azure Disk Encryption
- Implement Network Security Group rules with specific source IP restrictions
- Use Managed Identities for service authentication

## Cleanup Commands

To avoid ongoing charges, delete the resource group when finished:
```bash
az group delete --name newland-resources --yes --no-wait
```

## Screenshots Required

For project submission, capture the following:

1. **Screenshot_2.1**: Command and result of batch deployment
2. **Screenshot_2.2**: Inbound security rules in Network Security Group
3. **Screenshot_2.3**: ipconfig output from VM0 showing private IP (10.1.0.x)
4. **Screenshot_2.4**: ipconfig output from VM1 showing private IP (10.1.1.x)
5. **Screenshot_2.5**: ipconfig output from VM2 showing private IP (10.1.2.x)

## Troubleshooting

### Deployment Fails
- Check Azure subscription quotas for VM cores
- Verify region supports Standard_D2s_v3 VM size
- Ensure unique resource names if previous deployment exists

### Cannot RDP to VMs
- Verify NSG rules allow port 3389
- Check VM is running: `az vm list --resource-group newland-resources --show-details --output table`
- Ensure your local network allows outbound RDP connections

### Password Does Not Meet Requirements
If "Azure123" is rejected:
- Modify parameters file to use more complex password
- Azure requires passwords: 12-123 characters, with 3 of: lowercase, uppercase, numbers, symbols

## Additional Resources

- [Azure Resource Manager Templates Documentation](https://docs.microsoft.com/azure/azure-resource-manager/templates/)
- [ARM Template Best Practices](https://docs.microsoft.com/azure/azure-resource-manager/templates/best-practices)
- [Azure VM Sizes](https://docs.microsoft.com/azure/virtual-machines/sizes)
