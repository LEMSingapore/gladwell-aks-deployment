# Azure Quota Limitation - Solutions and Workarounds

## Issue Identified

Your Azure subscription has a **4 vCPU quota limit** for the Standard DSv3 Family in all regions, but the project requires:
- 3 VMs × Standard_D2s_v3 (2 cores each) = **6 vCPUs needed**
- Current quota: **4 vCPUs available**
- **Shortfall: 2 vCPUs**

## Solution Options

### Option 1: Request Quota Increase (RECOMMENDED for Project Requirements)

This is the proper solution to meet the exact project requirements.

#### Steps to Request Quota Increase:

1. **Via Azure Portal** (Fastest - usually approved within hours):
   ```
   1. Go to Azure Portal: https://portal.azure.com
   2. Search for "Quotas" in the top search bar
   3. Select "Compute" quotas
   4. Filter by:
      - Provider: Microsoft.Compute
      - Location: East US
      - Quota: Standard DSv3 Family vCPUs
   5. Click on "Standard DSv3 Family vCPUs"
   6. Click "Request Quota Increase"
   7. Enter new limit: 6 (or 8 for buffer)
   8. Provide justification: "Educational project requiring 3 Windows Server VMs for cloud computing coursework"
   9. Submit request
   ```

2. **Via Azure CLI**:
   ```bash
   az support tickets create \
     --ticket-name "Increase DSv3 vCPU quota" \
     --title "Request Standard DSv3 vCPU quota increase to 6" \
     --description "Need to deploy 3 Standard_D2s_v3 VMs for educational cloud computing project" \
     --problem-classification "/providers/Microsoft.Support/services/quota_service_guid/problemClassifications/cores_service_guid" \
     --severity minimal
   ```

3. **Direct Link**:
   - Visit: https://aka.ms/ProdportalCRP/#blade/Microsoft_Azure_Capacity/UsageAndQuota.ReactView
   - Select your subscription
   - Request increase for "Standard DSv3 Family vCPUs" in East US region

**Approval Time**: Usually 1-4 hours for student subscriptions, can be same day for small increases.

---

### Option 2: Use Smaller VM Size - Standard_B2s (QUICK WORKAROUND)

Deploy **2 VMs** instead of 3 using Standard_B2s (2 cores, 4 GB RAM each).

**Pros**:
- Fits within current quota (2 VMs × 2 cores = 4 cores)
- Similar specs to project requirements
- Can deploy immediately
- Lower cost ($~0.04/hour vs $~0.13/hour per VM)

**Cons**:
- Only 2 VMs instead of 3 (can explain in report)
- Not the exact VM size specified in project
- Burstable performance (not dedicated cores)

**Modified Specs**:
- VM Size: Standard_B2s (2 vCPUs, 4 GB RAM)
- Number of VMs: 2
- Subnet 0: Marketing Service (10.1.0.0/24)
- Subnet 1: Software Development (10.1.1.0/24)
- Omit Subnet 2: Network Consultancy

---

### Option 3: Use Smaller VM Size - Standard_B1s (ALTERNATIVE WORKAROUND)

Deploy **3 VMs** using Standard_B1s (1 core, 1 GB RAM each).

**Pros**:
- Maintains 3 VMs as required
- Fits within quota (3 VMs × 1 core = 3 cores)
- Can deploy immediately
- Much lower cost ($~0.01/hour per VM)
- Still demonstrates batch deployment concepts

**Cons**:
- Significantly smaller than project requirements
- Only 1 GB RAM (may be slow for Windows Server)
- Burstable performance
- May need to explain deviation in report

**Modified Specs**:
- VM Size: Standard_B1s (1 vCPU, 1 GB RAM)
- Number of VMs: 3 (all departments covered)
- All 3 subnets used as specified

---

### Option 4: Try Different Azure Region with Higher Quota

Some Azure regions may have different quota allocations.

**Less Common Regions to Try**:
- South Central US
- West US 3
- East US 2
- West Europe
- UK South

**Note**: Based on our checks, most regions have the same 4 vCPU quota for your subscription tier.

---

## Recommended Approach

### If Time Permits (1-4 hours wait):
1. ✅ **Request quota increase** (Option 1)
2. Wait for approval
3. Deploy with exact specifications

### If Immediate Deployment Needed:
1. 🔄 **Use Option 3** (Standard_B1s, 3 VMs)
2. Complete all screenshots and documentation
3. **Add explanation section** to your report:
   - Explain quota limitation encountered
   - Document the workaround used
   - Show understanding of proper VM sizing
   - Note that in production, proper quota planning is essential

---

## How to Deploy with Workaround

### For Option 2 (Standard_B2s, 2 VMs):

```bash
cd project5

# Edit parameters file
cat > az-capstone-vms-loop-parameters-b2s.json <<'EOF'
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "vmNamePrefix": { "value": "newland-vm" },
    "vmSize": { "value": "Standard_B2s" },
    "adminUsername": { "value": "admin123" },
    "adminPassword": { "value": "Azure123" },
    "windowsOSVersion": { "value": "2019-Datacenter" },
    "vmCount": { "value": 2 },
    "vnetName": { "value": "newland-vnet" },
    "vnetAddressPrefix": { "value": "10.1.0.0/16" },
    "nicNamePrefix": { "value": "newland-nic" }
  }
}
EOF

# Deploy
az deployment group create \
  --name newland-vm-deployment \
  --resource-group newland-resources \
  --template-file az-capstone-vms-loop-template.json \
  --parameters az-capstone-vms-loop-parameters-b2s.json
```

### For Option 3 (Standard_B1s, 3 VMs):

```bash
cd project5

# Edit parameters file
cat > az-capstone-vms-loop-parameters-b1s.json <<'EOF'
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "vmNamePrefix": { "value": "newland-vm" },
    "vmSize": { "value": "Standard_B1s" },
    "adminUsername": { "value": "admin123" },
    "adminPassword": { "value": "Azure123" },
    "windowsOSVersion": { "value": "2019-Datacenter" },
    "vmCount": { "value": 3 },
    "vnetName": { "value": "newland-vnet" },
    "vnetAddressPrefix": { "value": "10.1.0.0/16" },
    "nicNamePrefix": { "value": "newland-nic" }
  }
}
EOF

# Deploy
az deployment group create \
  --name newland-vm-deployment \
  --resource-group newland-resources \
  --template-file az-capstone-vms-loop-template.json \
  --parameters az-capstone-vms-loop-parameters-b1s.json
```

---

## What to Include in Your Project Report

If using a workaround, add a section titled "Implementation Challenges and Solutions":

### Sample Report Section:

```markdown
## Implementation Challenges and Solutions

### Challenge: Azure Subscription vCPU Quota Limitation

During the deployment phase, I encountered an Azure resource quota limitation:

**Issue Details**:
- Required: 6 vCPUs (3 × Standard_D2s_v3 VMs)
- Available: 4 vCPUs (Standard DSv3 Family quota)
- Error: "QuotaExceeded - Operation could not be completed as it results in exceeding approved Total Regional Cores quota"

**Solution Implemented**:
To proceed with the project while maintaining the learning objectives, I implemented the following workaround:
- Modified VM size to Standard_B1s (1 vCPU, 1 GB RAM)
- Successfully deployed all 3 VMs as required
- All networking configurations remained as specified
- All subnets properly configured for each department

**Learning Outcomes**:
1. Understanding of Azure quota management and capacity planning
2. Importance of checking resource quotas before production deployments
3. Ability to adapt ARM templates to different resource constraints
4. Experience with Azure quota increase request process

**Production Considerations**:
In a production environment, proper capacity planning would include:
- Reviewing subscription quotas before project initiation
- Requesting quota increases with appropriate lead time
- Selecting appropriate VM SKUs based on workload requirements
- Implementing resource governance policies

The batch deployment methodology and benefits remain fully demonstrated despite using alternative VM sizing.
```

---

## Cost Comparison

| VM Size | vCPUs | RAM | Cost/Hour | 3 VMs Total | Fits Quota |
|---------|-------|-----|-----------|-------------|------------|
| Standard_D2s_v3 | 2 | 8 GB | $0.13 | $0.39/hour | ❌ No (6 cores) |
| Standard_B2s | 2 | 4 GB | $0.04 | $0.12/hour | ⚠️ Only 2 VMs |
| Standard_B1s | 1 | 1 GB | $0.01 | $0.03/hour | ✅ Yes (3 cores) |

---

## Next Steps

**Choose your option and let me know:**
1. Request quota increase and wait (proper solution)
2. Deploy 2 VMs with Standard_B2s (quick, similar specs)
3. Deploy 3 VMs with Standard_B1s (quick, all departments)

I can immediately deploy with either option 2 or 3, or help you request the quota increase for option 1.

Which would you prefer?
