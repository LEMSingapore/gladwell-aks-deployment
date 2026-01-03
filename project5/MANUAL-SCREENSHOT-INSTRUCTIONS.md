# Manual RDP Screenshot Instructions

## ⚠️ ACTION REQUIRED: You Must Capture These Screenshots Manually

I cannot capture Screenshots 2.3 and 2.4 because they require RDP access to the Windows VMs. **You need to do this manually using the instructions below.**

---

## Screenshot 2.3: VM0 ipconfig Output

### Step-by-Step Instructions:

**1. Connect via RDP:**

**Windows Users:**
- Press `Win + R` to open Run dialog
- Type: `mstsc`
- Press Enter
- In the Computer field, enter: `20.125.54.189`
- Click "Connect"
- Username: `admin123`
- Password: `Azure123`
- Click "OK"

**macOS Users:**
- Open "Microsoft Remote Desktop" app (install from App Store if needed)
- Click "Add PC"
- PC name: `20.125.54.189`
- User account: "Add User Account"
  - Username: `admin123`
  - Password: `Azure123`
- Click "Add"
- Double-click the PC to connect

**Linux Users:**
```bash
xfreerdp /u:admin123 /p:Azure123 /v:20.125.54.189
# or
rdesktop 20.125.54.189
```

**2. Once Connected to VM0:**
- Click the Start button (Windows logo)
- Type: `cmd`
- Press Enter to open Command Prompt
- In the Command Prompt, type: `ipconfig`
- Press Enter

**3. Capture Screenshot:**
- Make sure the Command Prompt window shows:
  - The window title (should include the computer name)
  - The full ipconfig output
  - **IMPORTANT**: The Private IP should be `10.1.0.4`
  - Subnet mask: `255.255.255.0`
  - Default gateway: `10.1.0.1`

**4. Save Screenshot:**
- Press `PrtScn` (Print Screen) key or use Snipping Tool
- Save as: `Screenshot_2-3_VM0_ipconfig.png`
- Verify the private IP `10.1.0.4` is clearly visible

---

## Screenshot 2.4: VM1 ipconfig Output

### Step-by-Step Instructions:

**1. Disconnect from VM0 (if still connected)**
- Close the RDP window

**2. Connect to VM1 via RDP:**

**Windows Users:**
- Press `Win + R`
- Type: `mstsc`
- Press Enter
- Computer: `20.125.54.188` (note different IP!)
- Username: `admin123`
- Password: `Azure123`
- Click "OK"

**macOS Users:**
- Open "Microsoft Remote Desktop"
- Click "Add PC"
- PC name: `20.125.54.188`
- Username: `admin123`
- Password: `Azure123`
- Connect

**Linux Users:**
```bash
xfreerdp /u:admin123 /p:Azure123 /v:20.125.54.188
```

**3. Once Connected to VM1:**
- Click Start button
- Type: `cmd`
- Press Enter
- Type: `ipconfig`
- Press Enter

**4. Capture Screenshot:**
- Ensure the Command Prompt shows:
  - Window title with computer name
  - Full ipconfig output
  - **IMPORTANT**: Private IP should be `10.1.1.4` (different subnet!)
  - Subnet mask: `255.255.255.0`
  - Default gateway: `10.1.1.1`

**5. Save Screenshot:**
- Press `PrtScn` or use Snipping Tool
- Save as: `Screenshot_2-4_VM1_ipconfig.png`
- Verify the private IP `10.1.1.4` is clearly visible

---

## Quick Reference Card

| Item | VM0 (Marketing) | VM1 (Software) |
|------|-----------------|----------------|
| **Public IP (for RDP)** | 20.125.54.189 | 20.125.54.188 |
| **Expected Private IP** | 10.1.0.4 | 10.1.1.4 |
| **Expected Gateway** | 10.1.0.1 | 10.1.1.1 |
| **Username** | admin123 | admin123 |
| **Password** | Azure123 | Azure123 |
| **Subnet** | 10.1.0.0/24 | 10.1.1.0/24 |
| **Department** | Marketing Service | Software Development |

---

## Verification Checklist

Before submitting, verify each screenshot shows:

**Screenshot 2.3 (VM0):**
- [ ] Window title visible (shows computer/VM name)
- [ ] Command shows: `ipconfig`
- [ ] IPv4 Address: **10.1.0.4**
- [ ] Subnet Mask: 255.255.255.0
- [ ] Default Gateway: 10.1.0.1
- [ ] Output is clear and readable
- [ ] No sensitive information visible (besides what's required)

**Screenshot 2.4 (VM1):**
- [ ] Window title visible (shows computer/VM name)
- [ ] Command shows: `ipconfig`
- [ ] IPv4 Address: **10.1.1.4** (note different subnet!)
- [ ] Subnet Mask: 255.255.255.0
- [ ] Default Gateway: 10.1.1.1
- [ ] Output is clear and readable
- [ ] No sensitive information visible (besides what's required)

---

## Troubleshooting

### Cannot Connect via RDP

**Issue**: Connection refused or timeout

**Solutions**:
1. Verify VMs are running:
   ```bash
   az vm list --resource-group newland-resources --output table
   ```

2. Verify public IPs are correct:
   ```bash
   az network public-ip list --resource-group newland-resources --output table
   ```

3. Check your internet connection allows RDP (port 3389)

4. Try restarting the VM:
   ```bash
   az vm restart --resource-group newland-resources --name newland-vm0
   ```

### Wrong Password Error

**Issue**: Password rejected

**Solutions**:
- Ensure you're using: `Azure123` (capital A, no spaces)
- Username must be: `admin123` (all lowercase)
- If still fails, the password may have complexity requirements not met

### Slow Connection

**Issue**: RDP is very slow

**Solutions**:
- Connection may take 30-60 seconds initially (normal)
- VMs are in West US 2 region - some latency expected
- Reduce RDP quality settings in connection options
- Try connecting from a different network

### Wrong Private IP Displayed

**Issue**: Private IP is not what's expected

**Solutions**:
- **VM0 should show 10.1.0.4** - if different, you may have the wrong VM
- **VM1 should show 10.1.1.4** - verify you're connected to the correct public IP
- Double-check which public IP you connected to
- Each VM should be in a different subnet

---

## Alternative Screenshot Methods

### Using Snipping Tool (Windows):
1. Press `Win + Shift + S`
2. Select area to capture
3. Screenshot copies to clipboard
4. Open Paint or Word
5. Press `Ctrl + V` to paste
6. Save the file

### Using Screenshot Tool (macOS):
1. Press `Cmd + Shift + 4`
2. Click and drag to select area
3. Screenshot saves to Desktop
4. Rename appropriately

### Using Screenshot Tool (Linux):
- Press `PrtScn` for full screen
- Or use `gnome-screenshot` tool
- Or use `scrot` command:
  ```bash
  scrot screenshot.png
  ```

---

## After Capturing Screenshots

Once you have both screenshots:

1. **Verify Quality**:
   - Screenshots are clear and readable
   - Text is not blurry
   - Private IP addresses are clearly visible
   - Window titles are visible

2. **Name Files Appropriately**:
   - `Screenshot_2-3_VM0_ipconfig.png` (or .jpg)
   - `Screenshot_2-4_VM1_ipconfig.png` (or .jpg)

3. **Add to Report**:
   - Insert screenshots into the DOCX report
   - Place in the appropriate sections
   - Add captions if required

4. **DELETE AZURE RESOURCES**:
   ```bash
   az group delete --name newland-resources --yes --no-wait
   ```

   **Important**: These VMs cost money while running! Delete immediately after screenshots.

---

## Expected Output Examples

### VM0 ipconfig Output Should Look Like:
```
C:\Users\admin123> ipconfig

Windows IP Configuration

Ethernet adapter Ethernet:

   Connection-specific DNS Suffix  . : internal.cloudapp.net
   IPv4 Address. . . . . . . . . . . : 10.1.0.4
   Subnet Mask . . . . . . . . . . . : 255.255.255.0
   Default Gateway . . . . . . . . . : 10.1.0.1
```

### VM1 ipconfig Output Should Look Like:
```
C:\Users\admin123> ipconfig

Windows IP Configuration

Ethernet adapter Ethernet:

   Connection-specific DNS Suffix  . : internal.cloudapp.net
   IPv4 Address. . . . . . . . . . . : 10.1.1.4
   Subnet Mask . . . . . . . . . . . : 255.255.255.0
   Default Gateway . . . . . . . . . : 10.1.1.1
```

**Key Difference**: Note that VM0 is in the 10.1.0.x subnet and VM1 is in the 10.1.1.x subnet!

---

## Time Estimate

- Connecting to VM0: 1-2 minutes
- Capturing Screenshot 2.3: 1 minute
- Disconnecting and connecting to VM1: 1-2 minutes
- Capturing Screenshot 2.4: 1 minute

**Total Time**: 5-10 minutes

---

## Need Help?

If you encounter issues:
1. Check the troubleshooting section above
2. Verify VMs are running in Azure Portal
3. Ensure your network allows RDP connections
4. Try connecting from a different device or network

---

**Ready to capture screenshots? Start with VM0 first!**
