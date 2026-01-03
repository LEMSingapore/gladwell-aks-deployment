# Project 5 - Part 1: Batch VM Deployment with ARM Templates

## Quick Start

### Prerequisites
1. Azure subscription with active credits
2. Azure CLI installed ([Install Guide](https://docs.microsoft.com/cli/azure/install-azure-cli))
3. Logged in to Azure: `az login`

### Deploy the Infrastructure

```bash
cd project5
./deploy.sh
```

This will:
- Create the resource group `newland-resources`
- Deploy 3 Windows Server 2019 VMs
- Configure networking with 3 subnets
- Set up Network Security Group with RDP access
- Display connection information

### Verify the Deployment

```bash
./verify-deployment.sh
```

This will display all information needed for the project screenshots.

## Project Files

| File | Description |
|------|-------------|
| `az-capstone-vms-loop-template.json` | Main ARM template with copy loops |
| `az-capstone-vms-loop-parameters.json` | Parameters file with configuration values |
| `deploy.sh` | Automated deployment script |
| `verify-deployment.sh` | Verification and screenshot helper script |
| `Project5-Part1-Batch-VM-Deployment.md` | Complete project documentation |

## Architecture Overview

```
Newland Solutions Infrastructure
├── newland-vnet (10.1.0.0/16)
│   ├── subnet-marketing (10.1.0.0/24)
│   │   └── newland-vm0 (Marketing Service)
│   ├── subnet-software (10.1.1.0/24)
│   │   └── newland-vm1 (Software Development)
│   └── subnet-network (10.1.2.0/24)
│       └── newland-vm2 (Network Consultancy)
└── newland-nsg (Allow RDP on port 3389)
```

## VM Specifications

- **VM Size**: Standard_D2s_v3 (2 vCPUs, 8 GB RAM)
- **OS**: Windows Server 2019 Datacenter
- **Admin User**: admin123
- **Admin Password**: Azure123
- **Storage**: Premium SSD

## Screenshots Required for Submission

### Screenshot 2.1: Deployment Command and Result
Run the deployment command and capture:
```bash
az deployment group create \
  --name newland-vm-deployment \
  --resource-group newland-resources \
  --template-file az-capstone-vms-loop-template.json \
  --parameters az-capstone-vms-loop-parameters.json
```

Or view deployment history:
```bash
az deployment group list --resource-group newland-resources --output table
```

### Screenshot 2.2: Inbound Security Rules
```bash
az network nsg rule list \
  --resource-group newland-resources \
  --nsg-name newland-nsg \
  --output table
```

### Screenshots 2.3-2.5: VM ipconfig Output

For each VM:
1. Get the public IP address:
   ```bash
   az network public-ip show \
     --resource-group newland-resources \
     --name newland-pip[0|1|2] \
     --query ipAddress -o tsv
   ```

2. Connect via RDP using the public IP

3. Open Command Prompt in the VM

4. Run: `ipconfig`

5. Capture screenshot showing:
   - Private IP address in the correct subnet range
   - VM name in window title
   - Full ipconfig output

Expected private IP ranges:
- **VM0**: 10.1.0.x (Marketing - subnet-marketing)
- **VM1**: 10.1.1.x (Software - subnet-software)
- **VM2**: 10.1.2.x (Network - subnet-network)

## Advantages of Batch Deployment Using Templates

### 1. Consistency and Standardization
All VMs are deployed with identical configuration, eliminating configuration drift and human error.

### 2. Efficiency and Speed
Deploy multiple VMs simultaneously with a single command instead of configuring each individually.

### 3. Scalability
Easily scale from 3 to 30 VMs by changing one parameter (vmCount).

### 4. Infrastructure as Code (IaC)
- Templates are version-controlled
- Changes are tracked and auditable
- Easy to replicate across environments

### 5. Repeatability
Same template produces identical results every time, crucial for disaster recovery.

### 6. Cost Management
Ensures all resources use standardized, cost-effective SKUs consistently.

### 7. Maintenance
Centralized updates - modify template once to update all future deployments.

## Manual Deployment Commands

If you prefer to run commands manually instead of using the script:

```bash
# 1. Create resource group
az group create --name newland-resources --location eastus

# 2. Validate template
az deployment group validate \
  --resource-group newland-resources \
  --template-file az-capstone-vms-loop-template.json \
  --parameters az-capstone-vms-loop-parameters.json

# 3. Deploy template
az deployment group create \
  --name newland-vm-deployment \
  --resource-group newland-resources \
  --template-file az-capstone-vms-loop-template.json \
  --parameters az-capstone-vms-loop-parameters.json

# 4. List VMs
az vm list --resource-group newland-resources --output table

# 5. Get public IPs for RDP
az network public-ip list --resource-group newland-resources --output table

# 6. Get private IPs
az network nic show \
  --resource-group newland-resources \
  --name newland-nic0 \
  --query "ipConfigurations[0].privateIPAddress" -o tsv
```

## RDP Connection

### Windows
```cmd
mstsc /v:<public-ip-address>
```

### macOS
1. Download Microsoft Remote Desktop from App Store
2. Add PC with public IP address
3. Connect using admin123 / Azure123

### Linux
```bash
rdesktop <public-ip-address>
# or
xfreerdp /u:admin123 /p:Azure123 /v:<public-ip-address>
```

## Troubleshooting

### Cannot Connect via RDP
1. Verify VM is running:
   ```bash
   az vm list --resource-group newland-resources --show-details --output table
   ```

2. Check NSG rules allow RDP:
   ```bash
   az network nsg rule list --resource-group newland-resources --nsg-name newland-nsg
   ```

3. Verify public IP is assigned:
   ```bash
   az network public-ip list --resource-group newland-resources --output table
   ```

### Deployment Fails
1. Check subscription quotas:
   ```bash
   az vm list-usage --location eastus --output table
   ```

2. Verify region supports Standard_D2s_v3:
   ```bash
   az vm list-sizes --location eastus --output table | grep Standard_D2s_v3
   ```

3. Check deployment errors:
   ```bash
   az deployment group show \
     --resource-group newland-resources \
     --name newland-vm-deployment
   ```

### Password Complexity Issues
If "Azure123" doesn't meet complexity requirements, update the parameters file:
```json
"adminPassword": {
  "value": "Azure123!@#"
}
```

## Cleanup

To delete all resources and stop charges:
```bash
az group delete --name newland-resources --yes --no-wait
```

Verify deletion:
```bash
az group exists --name newland-resources
```

## Template Explanation

### Copy Loop Implementation
The template uses ARM's `copy` element to batch-deploy resources:

```json
"copy": {
  "name": "vmCopy",
  "count": "[parameters('vmCount')]"
}
```

This creates 3 instances of each resource (NICs, VMs, Public IPs).

### Subnet Assignment
Each VM is assigned to a different subnet using `copyIndex()`:

```json
"subnet": {
  "id": "[resourceId('Microsoft.Network/virtualNetworks/subnets',
    parameters('vnetName'),
    variables('subnetArray')[copyIndex()].name)]"
}
```

- copyIndex() = 0 → subnet-marketing
- copyIndex() = 1 → subnet-software
- copyIndex() = 2 → subnet-network

### Dependencies
Resources are deployed in order using `dependsOn`:
1. NSG (first)
2. VNet with subnets (depends on NSG)
3. Public IPs (parallel)
4. NICs (depends on VNet and Public IPs)
5. VMs (depends on NICs)

## Cost Estimation

Approximate costs for running this infrastructure:
- 3x Standard_D2s_v3 VMs: ~$0.13/hour each = ~$0.39/hour total
- 3x Premium SSD disks: ~$20/month each = ~$60/month total
- 3x Public IPs: ~$3.60/month each = ~$10.80/month total

**Total estimated cost**: ~$0.39/hour or ~$280/month

Remember to delete resources after completing the project to avoid charges.

## Additional Resources

- [ARM Template Documentation](https://docs.microsoft.com/azure/azure-resource-manager/templates/)
- [ARM Template Functions](https://docs.microsoft.com/azure/azure-resource-manager/templates/template-functions)
- [Copy Element in ARM Templates](https://docs.microsoft.com/azure/azure-resource-manager/templates/copy-resources)
- [Azure VM Sizes](https://docs.microsoft.com/azure/virtual-machines/sizes)

## Next Steps

After completing Part 1:
- Proceed to Project 5 Part 2 (if applicable)
- Document your findings
- Prepare project submission with all screenshots

## Support

If you encounter issues:
1. Check the troubleshooting section above
2. Review Azure deployment error messages
3. Verify Azure CLI is updated: `az upgrade`
4. Ensure sufficient Azure credits/subscription access
