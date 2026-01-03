# Project 5 Part 1 - Step-by-Step Checklist

Use this checklist to ensure you complete all requirements for the project.

## Pre-Deployment Checklist

- [ ] Azure subscription is active with sufficient credits
- [ ] Azure CLI is installed
  - Test: `az --version`
  - Should show version 2.x or higher
- [ ] Logged into Azure
  - Run: `az login`
  - Browser should open for authentication
- [ ] Verified current subscription
  - Run: `az account show`
  - Confirm this is the correct subscription

## Template Preparation

- [ ] Located the project5 directory
  - Path: `~/Projects/cloud-capstone/project5`
- [ ] Verified template file exists
  - File: `az-capstone-vms-loop-template.json`
- [ ] Verified parameters file exists
  - File: `az-capstone-vms-loop-parameters.json`
- [ ] Reviewed template to understand the architecture
- [ ] Confirmed all parameters match requirements:
  - [ ] VM size: Standard_D2s_v3
  - [ ] VM prefix: newland-vm
  - [ ] VNet name: newland-vnet
  - [ ] NIC prefix: newland-nic
  - [ ] Admin username: admin123
  - [ ] Admin password: Azure123
  - [ ] OS: WindowsServer 2019-Datacenter
  - [ ] Address space: 10.1.0.0/16
  - [ ] Subnet 0: 10.1.0.0/24
  - [ ] Subnet 1: 10.1.1.0/24
  - [ ] Subnet 2: 10.1.2.0/24

## Deployment Process

- [ ] Created resource group
  ```bash
  az group create --name newland-resources --location eastus
  ```
  - [ ] Command succeeded
  - [ ] Resource group visible in Azure Portal

- [ ] Validated ARM template
  ```bash
  az deployment group validate \
    --resource-group newland-resources \
    --template-file az-capstone-vms-loop-template.json \
    --parameters az-capstone-vms-loop-parameters.json
  ```
  - [ ] Validation succeeded (no errors)

- [ ] Started deployment
  ```bash
  az deployment group create \
    --name newland-vm-deployment \
    --resource-group newland-resources \
    --template-file az-capstone-vms-loop-template.json \
    --parameters az-capstone-vms-loop-parameters.json
  ```
  - [ ] Deployment started successfully
  - [ ] Noted deployment start time: ___________
  - [ ] Waited for deployment to complete (typically 10-15 minutes)
  - [ ] Deployment succeeded
  - [ ] Noted deployment end time: ___________

- [ ] Verified deployment in Azure Portal
  - [ ] Navigated to newland-resources resource group
  - [ ] Confirmed all resources created:
    - [ ] 3 Virtual machines (newland-vm0, vm1, vm2)
    - [ ] 3 Network interfaces (newland-nic0, nic1, nic2)
    - [ ] 3 Public IP addresses (newland-pip0, pip1, pip2)
    - [ ] 1 Virtual network (newland-vnet)
    - [ ] 1 Network security group (newland-nsg)
    - [ ] 3 Disks (OS disks for each VM)

## Post-Deployment Verification

- [ ] Listed all VMs
  ```bash
  az vm list --resource-group newland-resources --output table
  ```
  - [ ] All 3 VMs listed
  - [ ] All VMs show "Succeeded" provisioning state

- [ ] Checked VM power state
  ```bash
  az vm list --resource-group newland-resources --show-details --output table
  ```
  - [ ] All VMs show "VM running" status

- [ ] Retrieved public IP addresses
  ```bash
  az network public-ip list --resource-group newland-resources --output table
  ```
  - [ ] VM0 Public IP: ___________________
  - [ ] VM1 Public IP: ___________________
  - [ ] VM2 Public IP: ___________________

- [ ] Verified private IP addresses
  ```bash
  # VM0
  az network nic show --resource-group newland-resources --name newland-nic0 \
    --query "ipConfigurations[0].privateIPAddress" -o tsv

  # VM1
  az network nic show --resource-group newland-resources --name newland-nic1 \
    --query "ipConfigurations[0].privateIPAddress" -o tsv

  # VM2
  az network nic show --resource-group newland-resources --name newland-nic2 \
    --query "ipConfigurations[0].privateIPAddress" -o tsv
  ```
  - [ ] VM0 Private IP: ___________ (should be 10.1.0.x)
  - [ ] VM1 Private IP: ___________ (should be 10.1.1.x)
  - [ ] VM2 Private IP: ___________ (should be 10.1.2.x)

- [ ] Verified Network Security Group rules
  ```bash
  az network nsg rule list --resource-group newland-resources \
    --nsg-name newland-nsg --output table
  ```
  - [ ] AllowRDP rule exists
  - [ ] Port 3389 is open
  - [ ] Direction is Inbound
  - [ ] Access is Allow

## Screenshot 2.1: Deployment Command and Result

- [ ] Prepared terminal with deployment command visible
- [ ] Captured screenshot showing:
  - [ ] Full deployment command
  - [ ] Deployment output showing "Succeeded"
  - [ ] Timestamp visible
  - [ ] Resource group name visible (newland-resources)
- [ ] Screenshot saved as: `Screenshot_2.1.png`
- [ ] Screenshot is clear and readable

## Screenshot 2.2: Inbound Security Rules

- [ ] Ran NSG rule list command:
  ```bash
  az network nsg rule list --resource-group newland-resources \
    --nsg-name newland-nsg --output table
  ```
- [ ] Captured screenshot showing:
  - [ ] AllowRDP rule listed
  - [ ] Priority: 1000
  - [ ] Port: 3389
  - [ ] Protocol: TCP
  - [ ] Access: Allow
  - [ ] Direction: Inbound
- [ ] Screenshot saved as: `Screenshot_2.2.png`
- [ ] Screenshot is clear and readable

## Screenshot 2.3: VM0 ipconfig (Marketing Service)

- [ ] Connected to VM0 via RDP
  - [ ] Used public IP: ___________________
  - [ ] Username: admin123
  - [ ] Password: Azure123
  - [ ] RDP connection successful

- [ ] Opened Command Prompt in VM0
  - [ ] Ran: `ipconfig`

- [ ] Captured screenshot showing:
  - [ ] Window title includes "newland-vm0" or hostname
  - [ ] Private IP address visible
  - [ ] IP is in 10.1.0.0/24 range (e.g., 10.1.0.4)
  - [ ] Subnet mask: 255.255.255.0
  - [ ] Default gateway visible
  - [ ] Full ipconfig output readable

- [ ] Screenshot saved as: `Screenshot_2.3.png`
- [ ] Screenshot is clear and readable
- [ ] VM0 Private IP from screenshot: ___________

## Screenshot 2.4: VM1 ipconfig (Software Development)

- [ ] Connected to VM1 via RDP
  - [ ] Used public IP: ___________________
  - [ ] Username: admin123
  - [ ] Password: Azure123
  - [ ] RDP connection successful

- [ ] Opened Command Prompt in VM1
  - [ ] Ran: `ipconfig`

- [ ] Captured screenshot showing:
  - [ ] Window title includes "newland-vm1" or hostname
  - [ ] Private IP address visible
  - [ ] IP is in 10.1.1.0/24 range (e.g., 10.1.1.4)
  - [ ] Subnet mask: 255.255.255.0
  - [ ] Default gateway visible
  - [ ] Full ipconfig output readable

- [ ] Screenshot saved as: `Screenshot_2.4.png`
- [ ] Screenshot is clear and readable
- [ ] VM1 Private IP from screenshot: ___________

## Screenshot 2.5: VM2 ipconfig (Network Consultancy)

- [ ] Connected to VM2 via RDP
  - [ ] Used public IP: ___________________
  - [ ] Username: admin123
  - [ ] Password: Azure123
  - [ ] RDP connection successful

- [ ] Opened Command Prompt in VM2
  - [ ] Ran: `ipconfig`

- [ ] Captured screenshot showing:
  - [ ] Window title includes "newland-vm2" or hostname
  - [ ] Private IP address visible
  - [ ] IP is in 10.1.2.0/24 range (e.g., 10.1.2.4)
  - [ ] Subnet mask: 255.255.255.0
  - [ ] Default gateway visible
  - [ ] Full ipconfig output readable

- [ ] Screenshot saved as: `Screenshot_2.5.png`
- [ ] Screenshot is clear and readable
- [ ] VM2 Private IP from screenshot: ___________

## Documentation Preparation

- [ ] Written explanation of advantages of batch deployment
  - [ ] Consistency and Standardization explained
  - [ ] Efficiency and Speed explained
  - [ ] Scalability explained
  - [ ] Repeatability and Testing explained
  - [ ] Documentation and Audit Trail explained
  - [ ] Cost Management explained
  - [ ] Maintenance and Updates explained
  - [ ] Used specific examples from this project
  - [ ] Explanation is 300-500 words (or as required)

- [ ] Prepared modified JSON template for submission
  - [ ] File: `az-capstone-vms-loop-template.json`
  - [ ] Template is properly formatted
  - [ ] Template includes all required resources
  - [ ] Template uses copy loops correctly

- [ ] Prepared modified JSON parameters file for submission
  - [ ] File: `az-capstone-vms-loop-parameters.json`
  - [ ] All parameters match project requirements
  - [ ] Parameters file is properly formatted

## Final Submission Checklist

- [ ] All 5 screenshots captured and saved
  - [ ] Screenshot_2.1.png (Deployment command and result)
  - [ ] Screenshot_2.2.png (Inbound security rules)
  - [ ] Screenshot_2.3.png (VM0 ipconfig - 10.1.0.x)
  - [ ] Screenshot_2.4.png (VM1 ipconfig - 10.1.1.x)
  - [ ] Screenshot_2.5.png (VM2 ipconfig - 10.1.2.x)

- [ ] All screenshots are:
  - [ ] Clear and readable
  - [ ] Show relevant information
  - [ ] Include context (window titles, command prompts)
  - [ ] In PNG or JPG format

- [ ] Documentation prepared:
  - [ ] Advantages explanation written
  - [ ] JSON template file ready
  - [ ] JSON parameters file ready

- [ ] Verified all requirements met:
  - [ ] 3 VMs deployed (one per department)
  - [ ] Each VM in correct subnet
  - [ ] All VMs accessible via RDP
  - [ ] NSG rules allow RDP
  - [ ] All screenshots show correct information

- [ ] Project report organized with:
  - [ ] Introduction/Overview
  - [ ] Advantages explanation (Answer 1)
  - [ ] Modified JSON template (Answer 2)
  - [ ] Modified parameters file (Answer 3)
  - [ ] All 5 screenshots (Answer 4)
  - [ ] Conclusion (optional)

## Cleanup (AFTER Submission)

⚠️ **IMPORTANT: Only do this AFTER you have submitted the project!**

- [ ] Verified project is submitted successfully
- [ ] Deleted Azure resources to avoid charges:
  ```bash
  az group delete --name newland-resources --yes --no-wait
  ```
- [ ] Confirmed deletion:
  ```bash
  az group exists --name newland-resources
  ```
  - [ ] Command returns "false"

- [ ] Checked Azure Portal
  - [ ] Resource group no longer exists
  - [ ] No unexpected charges

## Notes Section

Use this space for any additional notes, observations, or issues encountered:

### Deployment Notes:
- Deployment start time: ___________
- Deployment end time: ___________
- Total deployment duration: ___________
- Any errors encountered: ___________________________________________
- How errors were resolved: ________________________________________

### Observations:
- Differences noted between template and portal deployment: _______
_______________________________________________________________
- Benefits observed from using template: _______________________
_______________________________________________________________
- Challenges faced: ____________________________________________
_______________________________________________________________

### Additional Information:
_______________________________________________________________
_______________________________________________________________
_______________________________________________________________

---

## Submission Deadline

Project Due Date: ___________
Time Remaining: ___________

## Self-Assessment

Rate your confidence in each area (1-5, where 5 is very confident):

- [ ] Understanding of ARM templates: ___/5
- [ ] Understanding of batch deployment: ___/5
- [ ] Azure CLI proficiency: ___/5
- [ ] Networking concepts (VNets, subnets, NSGs): ___/5
- [ ] RDP connectivity and troubleshooting: ___/5
- [ ] Overall project completion: ___/5

---

**Good luck with your project submission!**

Remember: Delete resources immediately after capturing screenshots and submitting the project to avoid unnecessary charges.
