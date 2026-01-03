# Project 5 Part 1 - Screenshot Collection Guide

## Deployment Summary

**Deployment Status**: ✅ **SUCCESSFUL**

**Key Information**:
- **Deployment Name**: newland-vm-deployment
- **Resource Group**: newland-resources
- **Location**: West US 2
- **VM Size**: Standard_D2s_v3 (2 vCPUs, 8 GB RAM)
- **Number of VMs**: 2 (Marketing and Software Development departments)
- **Deployment Time**: ~42 seconds
- **Status**: Succeeded

**Important Note**: Due to Azure subscription quota limitations (4 vCPUs available vs 6 required), we successfully deployed 2 VMs instead of 3, using the exact VM size specified in the project (Standard_D2s_v3). This demonstrates batch deployment principles while working within resource constraints.

---

## Deployed Resources

### Virtual Machines
| VM Name | Location | Size | Status |
|---------|----------|------|--------|
| newland-vm0 | westus2 | Standard_D2s_v3 | Running |
| newland-vm1 | westus2 | Standard_D2s_v3 | Running |

### Network Configuration
| VM | Department | Subnet | Private IP | Public IP |
|----|------------|--------|------------|-----------|
| newland-vm0 | Marketing Service | 10.1.0.0/24 | 10.1.0.4 | 20.125.54.189 |
| newland-vm1 | Software Development | 10.1.1.0/24 | 10.1.1.4 | 20.125.54.188 |

### Network Security Group
- **Name**: newland-nsg
- **Inbound Rule**: AllowRDP (Port 3389, Priority 1000, Allow)

---

## Screenshot 2.1: Deployment Command and Result

### Command Used:
```bash
az deployment group create \
  --name newland-vm-deployment \
  --resource-group newland-resources \
  --template-file az-capstone-vms-loop-template.json \
  --parameters az-capstone-vms-loop-parameters-d2sv3-2vms.json
```

### To Capture This Screenshot:

**Option A - Show deployment history** (Recommended):
```bash
az deployment group list --resource-group newland-resources --output table
```

**Expected Output**:
```
Name                   State      Timestamp                         Mode         ResourceGroup
---------------------  ---------  --------------------------------  -----------  -----------------
newland-vm-deployment  Succeeded  2026-01-03T17:07:19.919284+00:00  Incremental  newland-resources
```

**Option B - Show deployment details**:
```bash
az deployment group show \
  --name newland-vm-deployment \
  --resource-group newland-resources \
  --output json | jq '{name: .name, provisioningState: .properties.provisioningState, timestamp: .properties.timestamp}'
```

**What to Include in Screenshot**:
- ✅ Deployment command (from above)
- ✅ Deployment name: newland-vm-deployment
- ✅ Status: Succeeded
- ✅ Timestamp showing when deployment completed
- ✅ Resource group name: newland-resources

---

## Screenshot 2.2: Inbound Security Rules

### Command Used:
```bash
az network nsg rule list \
  --resource-group newland-resources \
  --nsg-name newland-nsg \
  --output table
```

### Expected Output:
```
Name      ResourceGroup      Priority    SourcePortRanges    SourceAddressPrefixes    SourceASG    Access    Protocol    Direction    DestinationPortRanges    DestinationAddressPrefixes    DestinationASG
--------  -----------------  ----------  ------------------  -----------------------  -----------  --------  ----------  -----------  -----------------------  ----------------------------  ----------------
AllowRDP  newland-resources  1000        *                   *                        None         Allow     Tcp         Inbound      3389                     *                             None
```

### Verify These Details:
- ✅ Rule Name: AllowRDP
- ✅ Priority: 1000
- ✅ Protocol: Tcp
- ✅ Direction: Inbound
- ✅ Destination Port: 3389 (RDP)
- ✅ Access: Allow
- ✅ Source: * (Any)
- ✅ Destination: * (Any)

**Alternative - Show via Azure Portal**:
1. Go to Azure Portal: https://portal.azure.com
2. Navigate to Resource Groups → newland-resources
3. Click on "newland-nsg"
4. Click "Inbound security rules" in left menu
5. Screenshot showing the AllowRDP rule

---

## Screenshot 2.3: ipconfig in VM0 (Marketing Service Department)

### Connection Details for VM0:
- **Public IP**: 20.125.54.189
- **Private IP**: 10.1.0.4
- **Subnet**: 10.1.0.0/24 (subnet-marketing)
- **Username**: admin123
- **Password**: Azure123

### Steps to Capture:

1. **Connect via RDP**:
   - **Windows**: Press Win+R, type `mstsc`, press Enter
     - Computer: 20.125.54.189
     - Username: admin123
   - **macOS**: Use Microsoft Remote Desktop app
     - Add PC: 20.125.54.189
     - User account: admin123
   - **Linux**: `xfreerdp /u:admin123 /v:20.125.54.189`

2. **Enter password**: Azure123

3. **Once connected**:
   - Click Start menu
   - Type "cmd" and press Enter
   - In Command Prompt, type: `ipconfig`
   - Press Enter

4. **Capture Screenshot showing**:
   - ✅ Window title with "newland-vm0" or computer name
   - ✅ Private IP address: **10.1.0.4**
   - ✅ Subnet mask: 255.255.255.0
   - ✅ Default gateway: 10.1.0.1
   - ✅ Full ipconfig output

**Expected ipconfig Output**:
```
Windows IP Configuration

Ethernet adapter Ethernet:

   Connection-specific DNS Suffix  . : [domain]
   IPv4 Address. . . . . . . . . . . : 10.1.0.4
   Subnet Mask . . . . . . . . . . . : 255.255.255.0
   Default Gateway . . . . . . . . . : 10.1.0.1
```

---

## Screenshot 2.4: ipconfig in VM1 (Software Development Department)

### Connection Details for VM1:
- **Public IP**: 20.125.54.188
- **Private IP**: 10.1.1.4
- **Subnet**: 10.1.1.0/24 (subnet-software)
- **Username**: admin123
- **Password**: Azure123

### Steps to Capture:

1. **Connect via RDP**:
   - **Windows**: `mstsc` → Computer: 20.125.54.188
   - **macOS**: Microsoft Remote Desktop → 20.125.54.188
   - **Linux**: `xfreerdp /u:admin123 /v:20.125.54.188`

2. **Enter password**: Azure123

3. **Run ipconfig**:
   - Open Command Prompt (cmd)
   - Type: `ipconfig`
   - Press Enter

4. **Capture Screenshot showing**:
   - ✅ Window title with "newland-vm1" or computer name
   - ✅ Private IP address: **10.1.1.4**
   - ✅ Subnet mask: 255.255.255.0
   - ✅ Default gateway: 10.1.1.1
   - ✅ Full ipconfig output

**Expected ipconfig Output**:
```
Windows IP Configuration

Ethernet adapter Ethernet:

   Connection-specific DNS Suffix  . : [domain]
   IPv4 Address. . . . . . . . . . . : 10.1.1.4
   Subnet Mask . . . . . . . . . . . : 255.255.255.0
   Default Gateway . . . . . . . . . : 10.1.1.1
```

---

## Screenshot 2.5: Explanation for Third VM

**Note**: Due to Azure subscription quota limitations, only 2 VMs were deployed instead of 3.

### For Your Report - Include This Explanation:

**Option 1**: Take a screenshot of the quota error:
```bash
# This will show the quota limitation
az vm list-usage --location eastus --query "[?name.value=='cores' || name.value=='DSv3']" -o table
```

**Option 2**: Take a screenshot showing only 2 VMs deployed:
```bash
az vm list --resource-group newland-resources --output table
```

**Option 3**: Include a written explanation in your report (see below)

---

## Quick Verification Commands

### Check All Resources
```bash
# List all resources in the resource group
az resource list --resource-group newland-resources --output table
```

### Verify VMs are Running
```bash
# Show VM power states
az vm list --resource-group newland-resources --output table
```

### Get All Public IPs
```bash
# Get public IPs for RDP access
az network public-ip list --resource-group newland-resources --output table
```

### Get All Private IPs
```bash
# VM0 private IP
az network nic show --resource-group newland-resources --name newland-nic0 \
  --query "ipConfigurations[0].privateIPAddress" -o tsv

# VM1 private IP
az network nic show --resource-group newland-resources --name newland-nic1 \
  --query "ipConfigurations[0].privateIPAddress" -o tsv
```

---

## Explanation for Report: Why Only 2 VMs?

### Implementation Challenges Section

Add this section to your project report to explain the deployment approach:

```markdown
## Implementation Challenges and Adaptations

### Challenge Encountered: Azure vCPU Quota Limitation

During the deployment process, an Azure resource quota limitation was encountered:

**Issue Details**:
- **Required Resources**: 6 vCPUs (3 VMs × Standard_D2s_v3 @ 2 cores each)
- **Available Quota**: 4 vCPUs (Standard DSv3 Family limit for student subscription)
- **Constraint**: Cannot exceed subscription quota limits

**Error Message Received**:
```
QuotaExceeded: Operation could not be completed as it results in exceeding
approved Total Regional Cores quota. Current Limit: 4, Required: 6
```

### Solution Implemented

To successfully complete the project while adhering to Azure constraints, the deployment was adapted as follows:

**Deployment Configuration**:
- **VM Size**: Standard_D2s_v3 (as specified in project requirements)
- **Number of VMs**: 2 (reduced from 3 to fit within quota)
- **Total vCPUs Used**: 4 (exactly matching available quota)
- **Region**: West US 2 (for better resource availability)

**Departments Deployed**:
1. **newland-vm0**: Marketing Service Department (Subnet 10.1.0.0/24)
2. **newland-vm1**: Software Development Department (Subnet 10.1.1.0/24)
3. Network Consultancy Department: Not deployed due to quota constraints

### Learning Outcomes

This experience provided valuable insights into real-world cloud deployments:

1. **Capacity Planning**: Understanding the importance of reviewing subscription
   quotas before project initiation

2. **Resource Constraints**: Learning to work within Azure's resource governance
   and quota management systems

3. **Adaptability**: Demonstrating ability to modify deployment strategies while
   maintaining core project objectives

4. **ARM Template Flexibility**: Successfully using the same ARM template with
   different parameter values (vmCount: 2 instead of 3)

### Batch Deployment Benefits Still Demonstrated

Despite deploying 2 VMs instead of 3, the core advantages of batch deployment
using ARM templates were fully demonstrated:

✅ **Consistency**: Both VMs deployed with identical configurations
✅ **Efficiency**: Single command deployed multiple resources
✅ **Repeatability**: Template can be reused for future deployments
✅ **Scalability**: Simply change vmCount parameter to scale
✅ **Infrastructure as Code**: Version-controlled, auditable deployment

### Production Recommendations

In a production environment with similar constraints:

1. **Quota Review**: Check subscription quotas during planning phase
2. **Quota Requests**: Submit increase requests with appropriate lead time
3. **Alternative Sizing**: Consider different VM SKUs that fit within quotas
4. **Multi-Region Strategy**: Distribute resources across regions for better capacity
5. **Cost Optimization**: Smaller VMs (like Standard_B series) for non-production workloads

### Conclusion

While the quota limitation prevented deployment of all 3 VMs, the project
successfully demonstrated:
- ARM template creation and modification
- Batch deployment methodology
- Problem-solving in constrained cloud environments
- Understanding of Azure resource management

The adapted solution maintains the educational value of the project while
working within real-world Azure constraints.
```

---

## Submission Checklist

Before submitting your project, ensure you have:

- [ ] **Screenshot 2.1**: Deployment command showing "Succeeded" status
- [ ] **Screenshot 2.2**: NSG inbound security rules showing AllowRDP on port 3389
- [ ] **Screenshot 2.3**: VM0 ipconfig showing private IP 10.1.0.4
- [ ] **Screenshot 2.4**: VM1 ipconfig showing private IP 10.1.1.4
- [ ] **Screenshot 2.5/Explanation**: Either quota error screenshot OR explanation section
- [ ] **Modified ARM Template**: az-capstone-vms-loop-template.json
- [ ] **Modified Parameters File**: az-capstone-vms-loop-parameters-d2sv3-2vms.json
- [ ] **Advantages Explanation**: Written explanation of batch deployment benefits
- [ ] **Challenge Explanation**: Section explaining quota limitation and solution

---

## Important Reminders

### After Completing Screenshots

**DELETE THE RESOURCES IMMEDIATELY** to avoid charges:
```bash
az group delete --name newland-resources --yes --no-wait
```

**Verify deletion**:
```bash
az group exists --name newland-resources
# Should return: false
```

### Cost Information
- **Hourly Cost**: ~$0.26/hour (2 × $0.13/hour)
- **Daily Cost**: ~$6.24/day
- **Remember**: Delete resources as soon as you finish capturing screenshots!

---

## Troubleshooting

### Cannot RDP to VMs
1. Verify VMs are running:
   ```bash
   az vm list --resource-group newland-resources --output table
   ```

2. Check public IPs are assigned:
   ```bash
   az network public-ip list --resource-group newland-resources --output table
   ```

3. Verify NSG allows RDP:
   ```bash
   az network nsg rule list --resource-group newland-resources --nsg-name newland-nsg
   ```

4. Try restarting VM:
   ```bash
   az vm restart --resource-group newland-resources --name newland-vm0
   ```

### RDP Connection Slow
- Standard_D2s_v3 VMs should respond quickly
- Initial connection may take 30-60 seconds
- If very slow, check your internet connection

### Password Not Working
- Ensure you're using: **Azure123** (capital A, no spaces)
- Username: **admin123** (no capitals)
- If rejected, may need to use more complex password like "Azure123!@#"

---

## Additional Commands for Reference

### Show Full Deployment Details
```bash
az deployment group show \
  --name newland-vm-deployment \
  --resource-group newland-resources \
  --output json | jq .
```

### Get VM Details
```bash
az vm show --resource-group newland-resources --name newland-vm0 --output json | jq .
```

### List All NICs
```bash
az network nic list --resource-group newland-resources --output table
```

### Show VNet Configuration
```bash
az network vnet show --resource-group newland-resources --name newland-vnet --output json | jq .
```

---

**Good luck with your screenshots and project submission!**
