# Project 5 Part 1 - Submission Guide

## Overview
This guide provides the exact steps and information needed for your project submission.

---

## Answer 1: Advantages of Batch Deployment Using Templates

### 1. Consistency and Standardization
- **Uniform Configuration**: All three VMs (newland-vm0, newland-vm1, newland-vm2) are deployed with identical specifications, ensuring no configuration drift between departmental servers
- **Reduced Human Error**: Automated deployment through ARM templates eliminates manual mistakes that could occur when configuring three separate VMs through the Azure Portal
- **Version Control**: JSON templates can be stored in source control systems (Git), providing a complete audit trail of infrastructure changes

### 2. Efficiency and Speed
- **Time Savings**: Deploy three VMs with a single command instead of manually creating each VM, which could take 30-45 minutes per VM through the portal
- **Parallel Deployment**: Azure Resource Manager processes the copy loop concurrently, deploying all three VMs simultaneously rather than sequentially
- **Reduced Administrative Overhead**: One deployment command replaces approximately 50+ clicks in the Azure Portal

### 3. Scalability
- **Easy Replication**: To add more VMs for additional departments, simply change the `vmCount` parameter from 3 to any higher number
- **Department Expansion**: If Newland Solutions adds more departments (e.g., Sales, HR), new VMs can be deployed by modifying one parameter and adding subnet definitions
- **Infrastructure as Code (IaC)**: Template-based approach supports rapid scaling from 3 VMs to 300 VMs without additional complexity

### 4. Repeatability and Testing
- **Predictable Outcomes**: The same template with same parameters will always produce identical infrastructure, critical for consistency across environments
- **Environment Parity**: Easily replicate dev, test, staging, and production environments with confidence they are identical
- **Disaster Recovery**: In case of region failure or data loss, the entire infrastructure can be rebuilt in minutes using the same templates

### 5. Documentation and Audit Trail
- **Self-Documenting**: The JSON template serves as living documentation of the infrastructure configuration
- **Compliance**: Easier to demonstrate compliance with organizational IT standards and security policies
- **Change Management**: Template versions track infrastructure evolution over time, showing who changed what and when

### 6. Cost Management
- **Resource Optimization**: Ensures all VMs use the specified Standard_D2s_v3 SKU, preventing accidental deployment of more expensive VM sizes
- **Reduced Deployment Time**: Faster deployment means less time spent by system engineers, reducing labor costs
- **Standardized Resources**: Easier to track and forecast Azure spending when all departmental VMs are identical

### 7. Maintenance and Updates
- **Centralized Updates**: To change VM specifications for all departments, modify the template once rather than updating three separate VMs
- **Consistent Patching**: All VMs start from the same baseline OS image, simplifying patch management
- **Simplified Troubleshooting**: When all VMs have identical configurations, diagnosing issues becomes easier as there are fewer variables

### 8. Security and Governance
- **Consistent Security Posture**: All VMs receive the same Network Security Group rules, ensuring uniform security policies
- **Policy Enforcement**: Templates can enforce organizational policies (e.g., mandatory tags, disk encryption) automatically
- **Reduced Attack Surface**: Standardization means fewer configuration variations that could introduce security vulnerabilities

---

## Answer 2: Modified JSON VM Template

**File**: `az-capstone-vms-loop-template.json`

See attached file. Key modifications and features:

### Template Structure
- Uses ARM template schema version 2019-04-01
- Implements copy loops for batch deployment
- Parameterized for flexibility and reusability

### Key Components

#### 1. Network Security Group
```json
"securityRules": [
  {
    "name": "AllowRDP",
    "properties": {
      "priority": 1000,
      "protocol": "Tcp",
      "access": "Allow",
      "direction": "Inbound",
      "destinationPortRange": "3389"
    }
  }
]
```

#### 2. Virtual Network with Three Subnets
- **subnet-marketing**: 10.1.0.0/24 (Marketing Service Department)
- **subnet-software**: 10.1.1.0/24 (Software Development Department)
- **subnet-network**: 10.1.2.0/24 (Network Consultancy Department)

#### 3. Copy Loop Implementation
```json
"copy": {
  "name": "vmCopy",
  "count": "[parameters('vmCount')]"
}
```

This creates three instances of:
- Public IP addresses (newland-pip0, newland-pip1, newland-pip2)
- Network interfaces (newland-nic0, newland-nic1, newland-nic2)
- Virtual machines (newland-vm0, newland-vm1, newland-vm2)

#### 4. VM Configuration
- **Size**: Standard_D2s_v3
- **OS**: WindowsServer 2019-Datacenter from MicrosoftWindowsServer publisher
- **Storage**: Premium_LRS (Premium SSD)
- **Authentication**: Username/password (admin123/Azure123)

#### 5. Outputs
Template includes outputs for:
- Private IP addresses of all three VMs
- Public IP addresses for RDP access

---

## Answer 3: Modified JSON Parameter Template

**File**: `az-capstone-vms-loop-parameters.json`

See attached file. Key parameters configured:

| Parameter | Value | Purpose |
|-----------|-------|---------|
| vmNamePrefix | newland-vm | Base name for VMs (results in newland-vm0, vm1, vm2) |
| vmSize | Standard_D2s_v3 | VM SKU with 2 vCPUs and 8 GB RAM |
| adminUsername | admin123 | Administrator account username |
| adminPassword | Azure123 | Administrator account password |
| windowsOSVersion | 2019-Datacenter | Windows Server 2019 Datacenter edition |
| vmCount | 3 | Number of VMs to deploy (one per department) |
| vnetName | newland-vnet | Virtual network name |
| vnetAddressPrefix | 10.1.0.0/16 | VNet address space (65,536 addresses) |
| nicNamePrefix | newland-nic | Base name for network interfaces |

---

## Answer 4: Screenshots

### Screenshot_2.1: Command and Result for Batch Deployment

**Command used**:
```bash
az deployment group create \
  --name newland-vm-deployment \
  --resource-group newland-resources \
  --template-file az-capstone-vms-loop-template.json \
  --parameters az-capstone-vms-loop-parameters.json
```

**Alternative command to view deployment history**:
```bash
az deployment group list --resource-group newland-resources --output table
```

**What to capture in screenshot**:
- The complete az deployment command
- Deployment status showing "Succeeded"
- Timestamp of deployment
- Resource group name (newland-resources)
- Deployment name

**To capture this screenshot**:
1. Run the deployment using `./deploy.sh` or the manual command above
2. Capture the terminal showing the deployment progress and success message
3. Alternatively, show the Azure Portal "Deployments" page showing successful deployment

---

### Screenshot_2.2: Inbound Security Rules

**Command used**:
```bash
az network nsg rule list \
  --resource-group newland-resources \
  --nsg-name newland-nsg \
  --output table
```

**What to capture in screenshot**:
Should show the AllowRDP rule with:
- **Name**: AllowRDP
- **Priority**: 1000
- **Port**: 3389
- **Protocol**: TCP
- **Source**: * (Any)
- **Destination**: * (Any)
- **Access**: Allow
- **Direction**: Inbound

**To capture this screenshot**:
1. Run the command above in terminal, OR
2. In Azure Portal: Go to newland-nsg → Inbound security rules
3. Screenshot should clearly show RDP (port 3389) is allowed

---

### Screenshot_2.3: ipconfig in VM0 (Marketing Service)

**Steps to capture**:
1. Get VM0 public IP:
   ```bash
   az network public-ip show \
     --resource-group newland-resources \
     --name newland-pip0 \
     --query ipAddress -o tsv
   ```

2. Connect via RDP:
   - Windows: `mstsc /v:<public-ip>`
   - macOS: Use Microsoft Remote Desktop app
   - Login: admin123 / Azure123

3. Once connected, open Command Prompt (cmd.exe)

4. Run: `ipconfig`

5. Take screenshot showing:
   - Window title showing "newland-vm0" or the VM's hostname
   - IPv4 Address in the **10.1.0.x** range (e.g., 10.1.0.4)
   - Subnet mask: 255.255.255.0
   - Default gateway in 10.1.0.x range
   - Full ipconfig output

**Expected Private IP Range**: 10.1.0.0/24 (Marketing Department subnet)

---

### Screenshot_2.4: ipconfig in VM1 (Software Development)

**Steps to capture**:
1. Get VM1 public IP:
   ```bash
   az network public-ip show \
     --resource-group newland-resources \
     --name newland-pip1 \
     --query ipAddress -o tsv
   ```

2. Connect via RDP using the public IP

3. Login: admin123 / Azure123

4. Open Command Prompt and run: `ipconfig`

5. Take screenshot showing:
   - Window title showing "newland-vm1" or the VM's hostname
   - IPv4 Address in the **10.1.1.x** range (e.g., 10.1.1.4)
   - Subnet mask: 255.255.255.0
   - Default gateway in 10.1.1.x range
   - Full ipconfig output

**Expected Private IP Range**: 10.1.1.0/24 (Software Development Department subnet)

---

### Screenshot_2.5: ipconfig in VM2 (Network Consultancy)

**Steps to capture**:
1. Get VM2 public IP:
   ```bash
   az network public-ip show \
     --resource-group newland-resources \
     --name newland-pip2 \
     --query ipAddress -o tsv
   ```

2. Connect via RDP using the public IP

3. Login: admin123 / Azure123

4. Open Command Prompt and run: `ipconfig`

5. Take screenshot showing:
   - Window title showing "newland-vm2" or the VM's hostname
   - IPv4 Address in the **10.1.2.x** range (e.g., 10.1.2.4)
   - Subnet mask: 255.255.255.0
   - Default gateway in 10.1.2.x range
   - Full ipconfig output

**Expected Private IP Range**: 10.1.2.0/24 (Network Consultancy Department subnet)

---

## Verification Checklist

Before submitting, verify:

- [ ] All three VMs are running
- [ ] Each VM is in the correct subnet:
  - [ ] VM0 in 10.1.0.0/24 (Marketing)
  - [ ] VM1 in 10.1.1.0/24 (Software)
  - [ ] VM2 in 10.1.2.0/24 (Network)
- [ ] RDP access works for all three VMs
- [ ] Network Security Group has AllowRDP rule on port 3389
- [ ] All five screenshots captured clearly
- [ ] JSON template file attached to submission
- [ ] JSON parameters file attached to submission
- [ ] Advantages explanation written (see Answer 1 above)

---

## Quick Verification Commands

```bash
# Check all VMs are running
az vm list --resource-group newland-resources --show-details --output table

# Get all private IPs
for i in 0 1 2; do
  echo -n "VM$i: "
  az network nic show \
    --resource-group newland-resources \
    --name newland-nic$i \
    --query "ipConfigurations[0].privateIPAddress" -o tsv
done

# Get all public IPs for RDP
az network public-ip list --resource-group newland-resources --output table

# Check NSG rules
az network nsg rule list \
  --resource-group newland-resources \
  --nsg-name newland-nsg \
  --output table
```

---

## Cleanup After Submission

After capturing all screenshots and submitting the project:

```bash
# Delete resource group to stop charges
az group delete --name newland-resources --yes --no-wait

# Verify deletion (should return 'false')
az group exists --name newland-resources
```

---

## Cost Warning

Running this infrastructure costs approximately:
- **Hourly**: ~$0.39/hour
- **Daily**: ~$9.36/day
- **Monthly**: ~$280/month

**Remember to delete resources immediately after completing the project.**

---

## Submission Files Checklist

Include these files in your submission:

1. **az-capstone-vms-loop-template.json** - Modified ARM template
2. **az-capstone-vms-loop-parameters.json** - Modified parameters file
3. **Screenshot_2.1.png** - Deployment command and result
4. **Screenshot_2.2.png** - Inbound security rules
5. **Screenshot_2.3.png** - VM0 ipconfig showing 10.1.0.x
6. **Screenshot_2.4.png** - VM1 ipconfig showing 10.1.1.x
7. **Screenshot_2.5.png** - VM2 ipconfig showing 10.1.2.x
8. **Written explanation** - Advantages of batch deployment (see Answer 1)

---

## Common Issues and Solutions

### Issue: Cannot connect via RDP
**Solution**:
- Verify VM is running: `az vm list --show-details`
- Check NSG allows port 3389
- Try resetting VM: `az vm restart --resource-group newland-resources --name newland-vm0`

### Issue: Password "Azure123" rejected
**Solution**: Change to more complex password like "Azure123!@#" in parameters file

### Issue: Deployment fails with quota error
**Solution**:
- Check your subscription quotas
- Try a different region
- Use a smaller VM size temporarily for testing

### Issue: Cannot find template files
**Solution**: Ensure you're in the project5 directory: `cd ~/Projects/cloud-capstone/project5`

---

## Additional Tips for High Marks

1. **Explain thoroughly**: In your advantages explanation, provide specific examples from this project
2. **Clear screenshots**: Ensure text is readable, include window titles showing VM names
3. **Verify IPs**: Double-check each VM's private IP is in the correct subnet range
4. **Professional formatting**: Use proper headings and formatting in your report
5. **Include insights**: Add observations about deployment time, ease of use, etc.

---

## Contact Information for Azure Support

If you encounter Azure-specific issues:
- Azure Documentation: https://docs.microsoft.com/azure/
- Azure CLI Reference: https://docs.microsoft.com/cli/azure/
- Azure Portal: https://portal.azure.com

---

Good luck with your submission!
