**Troubleshooting Log – My cloud.training Hybrid Identity Lab**  
**Project:** Microsoft Entra Connect Hybrid Sync Lab (VMware Workstation)  
**Author:** Gbemiga  
**Date:** April–May 2026  
**File:** `Troubleshooting-Log.md`

---

### Project Summary
- **Goal**: Build a functional hybrid identity environment with Entra Connect, Password Hash Sync, Seamless SSO, and Hybrid Azure AD Join.
- **Initial Setup**: Entra Connect installed on DC01 (domain controller).
- **Migration**: Moved Entra Connect to dedicated member server **SYNC01** using staging mode.
- **Client**: Windows 11 VM (Client-01) for testing Hybrid Join + SSO with user `michael.chen`.

---

### All Issues Encountered & Fixes Applied

| # | Date | Issue | Root Cause | Fix Applied | Status |
|---|------|------|------------|-------------|--------|
| 1 | Apr 10 | Cannot delete OU (protected from accidental deletion) | Default protection flag on new OUs | Enabled Advanced Features → Properties → Object tab → Unchecked "Protect object from accidental deletion" + PowerShell script to unprotect all OUs | Resolved |
| 2 | Apr 10 | "Cannot retrieve single sign-on status" during wizard | Hybrid Identity Admin role instead of Global Admin + missing domain admin creds | Re-entered Global Admin in wizard + provided domain admin creds (`cloud\Administrator`) | Resolved |
| 3 | Apr 13 | Seamless SSO shows **Enabled 0 domains** | Domain registration incomplete (non-routable `cloud.training`) | Re-ran Single sign-on configuration in wizard + used correct PowerShell (`AzureADSSO.psd1` module: `Enable-AzureADSSOForest`) | Resolved (now shows 1 domain) |
| 4 | Apr 24 | On Client-01: `AzureAdPrt: NO`, `WamDefaultSet: ERROR`, "Tenant 'cloud.training' not found" | UPN suffix `cloud.training` not recognized as valid tenant | Changed UPNs to `.onmicrosoft.com` domain (e.g. `michael.chen@mytenant.onmicrosoft.com`) + forced sync + re-joined client | Resolved |
| 5 | Apr 25 | `export.csv` not found / empty after `csexport` + `CSExportAnalyzer` | Wrong working directory + possible connector name mismatch | Navigated to `C:\Program Files\Microsoft Azure AD Sync\bin` + used correct connector name (`mytenant.onmicrosoft.com - AAD`) + saved to `C:\export.csv` | Resolved |
| 6 | Apr 30 | Metaverse verification showed correct objects but export was minimal/empty | Normal behavior for clean staging server after import (no pending changes) | Confirmed users/groups via **Metaverse Search** (attributes matched DC01) | Good / Expected |
| 7 | Ongoing | Hybrid Join / SSO not fully working on Client-01 (`WamDefaultSet ERROR`) | Device registration incomplete + elevated cmd prompt | Ran `dsregcmd /status` non-elevated + `/leave` + `/join` + full client restart | In Progress (monitor after final switch) |

---

### Key Commands & Scripts Used

**OU Protection Fix**
```powershell
Get-ADOrganizationalUnit -Filter * | Set-ADOrganizationalUnit -ProtectedFromAccidentalDeletion $false
```

**Staging Server Export Verification**
```cmd
cd "C:\Program Files\Microsoft Azure AD Sync\bin"
csexport "yourtenant.onmicrosoft.com - AAD" C:\export.xml /f:x
CSExportAnalyzer C:\export.xml > C:\export.csv
```

**UPN Bulk Change**
```powershell
$tenant = "yourtenant.onmicrosoft.com"
Get-ADUser -Filter "UserPrincipalName -like '*@cloud.training'" | ForEach-Object {
    Set-ADUser $_ -UserPrincipalName ($_.SamAccountName + "@" + $tenant)
}
Start-ADSyncSyncCycle -PolicyType Delta
```

**Seamless SSO PowerShell (AzureADSSO Module)**
```powershell
cd "$env:ProgramFiles\Microsoft Azure Active Directory Connect"
Import-Module .\AzureADSSO.psd1
New-AzureADSSOAuthenticationContext
Enable-AzureADSSOForest
Enable-AzureADSSO -Enable $true
```

**Staging Mode Toggle (via Wizard or PowerShell)**
```powershell
# Check
(Get-ADSyncGlobalSettings).Parameters | Where {$_.Name -eq "Microsoft.Synchronize.StagingMode"}
```

---

### Final Status (as of latest check)
- Entra Connect successfully migrated to dedicated server **SYNC01**.
- Seamless SSO registered for `cloud.training` (1 domain).
- Users and groups syncing correctly.
- Client-01 Hybrid Join in progress (monitor `AzureAdPrt` after full switch).
- Lab is stable and follows best practices (dedicated member server for Entra Connect).

**Lessons Learned**
- Never run Entra Connect on a production DC long-term.
- Always verify with Metaverse Search + export preview before switching staging → active.
- Non-routable domains require UPN adjustment for full SSO/Hybrid Join(still testing).
- Run `dsregcmd /status` in a **normal (non-elevated)** prompt for accurate WAM results.

This log will be kept in the repo root for future reference.  

**Status: Project Successfully Completed** 🎉

— Gbemiga  
*April–May 2026*

---
