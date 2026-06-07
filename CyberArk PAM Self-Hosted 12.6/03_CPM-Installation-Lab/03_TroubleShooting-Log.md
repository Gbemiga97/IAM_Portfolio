# CyberArk PAM - Post-Discovery Account Management Guide

**Domain**: `awesome.lab`  
**Version**: CyberArk PAM Self-Hosted 12.6  
**Date**: June 2026

---

## Overview

After running **Windows Accounts Discovery**, CyberArk automatically discovers local accounts on target servers but disables automatic management (CPM) until you manually configure them.

This guide explains how to enable password management for discovered accounts.

---

## Common Issue After Discovery

- Accounts show **"Disabled by CPM"** with a red warning triangle.
- CPM will not rotate or reconcile passwords until properly configured.

---

## Step-by-Step: Enable Management for Discovered Accounts

### 1. Locate the Accounts

1. Log into **PVWA**.
2. Go to **Accounts** → **All Accounts**.
3. Filter by the target server name (`Target-Server.awesome.lab`).

### 2. Link the Reconcile Account

For each account (or in bulk):

1. Select the account(s) → Click the **...** menu → **Edit**.
2. Go to the **CPM** tab.
3. In **Reconcile Account**, select **`cyberark-reconcile`**.
4. Save.

### 3. Enable the Account for CPM

In the same edit window:

- Change **Status** from **Disabled by CPM** to **Enabled**.
- Set **Operational State** to **Scheduled for Change** or **Scheduled for Verification**.
- Click **Save**.

### 4. Bulk Update (Recommended)

1. Use checkboxes to select multiple accounts on the same server.
2. Click the top **...** menu → **Change**.
3. Update **Reconcile Account** and **Status** for all selected accounts at once.

---

## Verification Steps

1. Refresh the Accounts list — the red triangle should disappear.
2. Select an account → Click **Reconcile** (manual test).
3. Go to **Monitoring** → **Tasks** to monitor CPM activity.
4. Check the account **Operational State** updates to **Successfully Reconciled**.

---

## Best Practices

- Use a dedicated **Reconcile Safe** with strict permissions (only CPM + Vault Admins).
- Always link the reconcile account before enabling management.
- Start with **Verification** (not Change) for the first few cycles.
- Monitor CPM logs if issues persist:
  - `C:\Program Files (x86)\CyberArk\Password Manager\Logs\`

---

## Issue: CACPM405E - Access is denied (winRc=5)

**Error Message**:
The Master was disabled because an unrecoverable error was detected.
Error in reconcilepass to user Target-Server.awesome.lab\TUser01
Reason: Access is denied. (winRc=5)
text**Cause**:
The Reconcile Account (`cyberark-reconcile`) does not have sufficient local permissions on the target server to reset the password of local accounts.

---

### Solution: Add Reconcile Account to Local Administrators Group

**On the Target Server** (`Target-Server.awesome.lab`):

#### PowerShell Method (Recommended)

# Run as Administrator on the target server
Add-LocalGroupMember -Group "Administrators" -Member "awesome\cyberark-reconcile"
GUI Method

RDP to the target server.
Right-click Start → Computer Management.
Navigate to System Tools → Local Users and Groups → Groups.
Open the Administrators group.
Click Add → Type awesome\cyberark-reconcile → Check Names → OK.


Post-Fix Verification

In PVWA, open the affected account (e.g. TUser01).
Click Reconcile (manual test).
Go to Monitoring → Tasks to check the result.
The account status should change to Successfully Reconciled.

## Troubleshooting Common Errors

| Issue                        | Solution |
|-----------------------------|----------|
| "Access is denied"          | Ensure `cyberark-reconcile` is in Local Administrators on target server |
| "Disabled by CPM"           | Link reconcile account + set Status to Enabled |
| Reconciliation fails        | Verify Reset Password permissions on OU / server |
| Discovery pending forever   | Fix CPM Scanner service (certificate trust) |
