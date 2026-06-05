

---

```markdown
# CyberArk PAM - LDAP Integration Troubleshooting Log

**Domain**: `awesome.lab`  
**Environment**: CyberArk PAM Self-Hosted 12.6  
**Date**: May 2026  
**Status**: Successfully Completed

---

## Overview
This document records all issues encountered during LDAP integration and the solutions applied.

---

## Issue 1: "Failed to contact the domain"

**Error Message**:  
"Failed to contact the domain. This can happen because: Domain name, Bind username, Bind user password or Domain base context is incorrect."

**Cause**:  
LDAPS (SSL) was enabled but the Domain Controller certificate was not trusted by the PVWA / Vault.

**Solution**:
- Unchecked **"Use Secure connection (SSL)"** to use plain LDAP (port 389) first.
- Successfully connected after switching to non-SSL.

**Status**: ✅ Resolved (Temporary workaround)

---

## Issue 2: "Failed to connect to the domain controllers"

**Error Message**:  
"Could not establish a connection to the selected domain controllers. Verify that each of the domain controllers was added to the Vault's hosts file."

**Cause**:  
The CyberArk Vault does not fully rely on Windows DNS for LDAP connections.

**Solution**:
On the **Vault Server**, edited the hosts file:

```text
C:\Windows\System32\drivers\etc\hosts
```

Added the line:
```
192.168.225.10    DC01.awesome.lab
```

**Status**: ✅ Resolved

---

## Issue 3: Port Connectivity Problems

**Tested Ports**:
- Port 389 (LDAP) → Confirmed open and working
- Port 636 (LDAPS) → Planned for production

**Verification Commands** (run on Vault Server):

```powershell
Test-NetConnection -ComputerName DC01.awesome.lab -Port 389
Test-NetConnection -ComputerName DC01.awesome.lab -Port 636
```

**Status**: ✅ Port 389 confirmed working

---

## Issue 4: Enabling LDAPS (Port 636) - Future Step

**Steps to Enable Secure LDAPS**:

1. Export Root CA certificate from Domain Controller.
2. Import the certificate into **Trusted Root Certification Authorities** on:
   - Vault Server
   - PVWA Server
3. Re-enable **"Use Secure connection (SSL)"** in LDAP Integration.
4. Update port to **636**.

**Status**: Not yet implemented (Lab currently uses LDAP 389)

---

## Final Configuration Summary

- **Domain**: `awesome.lab`
- **Bind User**: `cyberarkbind@awesome.lab`
- **Base Context**: `dc=awesome,dc=lab`
- **Connection Type**: LDAP (389) - Working
- **Domain Controller**: `DC01.awesome.lab` (192.168.225.10)
- **Hosts file entry**: Added on Vault

---

## Lessons Learned

- Always add Domain Controllers to the Vault’s `hosts` file.
- Start with non-SSL (LDAP) for initial testing.
- Import Root CA certificate before enabling LDAPS.
- Use `Test-NetConnection` and `ldp.exe` for troubleshooting.
- Restart Vault services after making hosts file or certificate changes.

---
