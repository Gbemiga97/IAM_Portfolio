# PVWA Installation Troubleshooting Log
**Environment:** CyberArk PAM Self-Hosted 12.6 | Windows Server 2019 | WIN-PVWA.pitythefool.com

---

## Issue 1 — Prerequisites Script: PVWA_Verify_IIS_Settings Failed

**Date Encountered:** During initial prerequisites script run

**Symptom:**
The `PVWA_Prerequisites.ps1` script ran and completed but the following failure appeared in the output:

```
The following Step failed : PVWA_Verify_IIS_Settings
PVWA Prerequisites script execution ended.
isSucceeded: 1
```

**Root Cause:**
IIS (Internet Information Services) was not installed on the server, so when the prerequisites script attempted to verify that the IIS role and its required role services were configured correctly, the verification step had nothing to check against and failed. The `isSucceeded: 1` in the JSON output was misleading — the overall script flagged partial success but the IIS verification itself did not pass.

**Fix:**
Identified that IIS Manager was not appearing in the Start Menu, which confirmed IIS was not installed. Proceeded to install IIS manually via **Server Manager → Add Roles and Features** before re-running the prerequisites script.

**Status:** ✅ Resolved — see Issue 2 for the IIS installation process.

---

## Issue 2 — IIS Not Appearing in Start Menu After Prerequisites Script

**Date Encountered:** After Issue 1 was identified

**Symptom:**
Searching for "IIS" in the Windows Start Menu returned no results. IIS Manager was not installed or accessible.

**Root Cause:**
The `PVWA_Prerequisites.ps1` script is designed to install and configure IIS automatically. However, the script did not complete the IIS installation successfully in this environment, leaving the server without IIS. This was confirmed when IIS Manager could not be found in the Start Menu.

**Fix:**
Manually installed IIS through **Server Manager**:

1. Opened **Server Manager** → **Add Roles and Features**
2. Selected **Web Server (IIS)** under Server Roles
3. Expanded the role to select the required role services

**Status:** ✅ Resolved — see Issue 3 for the specific role services that were initially missed.

---

## Issue 3 — Wrong IIS Role Services Selected (Insufficient Confirmation Screen)

**Date Encountered:** During manual IIS installation via Server Manager

**Symptom:**
After selecting Web Server (IIS) in Server Manager, the **Confirm Installation Selections** screen showed only a very short list of components being added — specifically only:

```
Web Server (IIS)
  Management Tools
    IIS 6 Management Compatibility
    IIS 6 Management Console
```

This was not enough for CyberArk PVWA to function.

**Root Cause:**
The sub-categories inside Web Server (IIS) → Web Server were not expanded in the Role Services screen. Each sub-section (Application Development, Security, Management Tools) needed to be individually expanded by clicking the arrow next to each group, then the specific checkboxes inside had to be selected manually. The parent checkbox alone does not automatically select all child items.

**Fix:**
Went back to the **Role Services** screen and manually expanded and checked the following:

Under **Web Server → Application Development:**
- .NET Extensibility 4.5
- ASP.NET 4.5
- ISAPI Extensions
- ISAPI Filters

Under **Web Server → Security:**
- Windows Authentication
- Basic Authentication

Under **Management Tools:**
- IIS Management Console

After selecting these, the Confirm Installation screen showed a significantly longer list of components — confirming the correct selections were made. Also checked **"Restart the destination server automatically if required"** before clicking Install.

**Status:** ✅ Resolved

---

## Issue 4 — Features Page "Next" Button Greyed Out

**Date Encountered:** During Server Manager Add Roles and Features wizard

**Symptom:**
After completing the Server Roles page and clicking Next to reach the **Select Features** page, the **Next** button was greyed out and unclickable, preventing progress through the wizard.

**Root Cause:**
The wizard's Next button on the Features page only becomes active when there are valid new selections pending from the previous Server Roles page. Because the required IIS role services had not been properly checked on the Server Roles screen at that point, there was nothing new queued for installation, and the wizard could not proceed.

**Fix:**
Clicked **Previous** to return to the **Server Roles** page and correctly selected all the missing IIS role services as described in Issue 3. After making those selections, clicking Next through to the Features page allowed the Next button to become active because the wizard now had confirmed pending changes to install.

> Note: No additional selections were needed on the Features page itself — .NET Framework 4.6 was already showing as installed. The Features page was a pass-through step.

**Status:** ✅ Resolved

---

## Issue 5 — Prerequisites Script Second Run: isSucceeded: 0 With All Steps Skipping

**Date Encountered:** After IIS was manually installed and prerequisites script was re-run

**Symptom:**
Re-running the `PVWA_Prerequisites.ps1` script produced the following confusing output:

```
Operation Succeeded
PVWA Prerequisites script execution ended.

isSucceeded: 0,
errorData: "Step Install Redistributable Skipping prerequisites check.
Step Verify OS version Skipping prerequisites check.
Step Verify IIS Settings Skipping prerequisites check.
Step PVWA Install Web Server Roles Skipping prerequisites check.
Step Disable IPV6 Skipping prerequisites check.
Step PVWA Config Self Certificate Skipping prerequisites check.
Step Setting IIS SSL TLS Configuration Skipping prerequisites check."
```

The banner said **"Operation Succeeded"** but the JSON result showed `isSucceeded: 0` and every step said "Skipping prerequisites check."

**Root Cause:**
The script detected that the relevant components were already installed or previously configured, and skipped re-running those steps. The `isSucceeded: 0` value was contradicted by the "Operation Succeeded" banner — the TLS 1.2 and SSL/TLS configuration steps completed successfully as shown in the output above the result block. The "Skipping" messages indicated that the script found those steps already satisfied rather than indicating failures.

**Fix:**
Verified IIS Manager was now present and accessible via **Server Manager → Tools → Internet Information Services (IIS) Manager**. IIS was confirmed installed with `WIN-PVWA` showing as Online. Treated the "Operation Succeeded" banner as the reliable indicator and proceeded to the main installation.

**Lesson Learned:** When the script skips steps and shows "Operation Succeeded," verify IIS externally rather than relying solely on the JSON `isSucceeded` value. If IIS Manager opens and Default Web Site is present, the server is ready.

**Status:** ✅ Resolved — proceeded to Setup.exe

---

## Issue 6 — Error -1603: Fatal Error During Installation (Setup.exe)

**Date Encountered:** During main PVWA installation via Setup.exe

**Symptom:**
The CyberArk Password Vault Web Access Setup wizard started, began configuring the installation, then stopped mid-way with a pop-up error:

```
Feature transfer error

Error: -1603  Fatal error during installation.
Consult Windows Installer Help (Msi.chm) or MSDN for more information.
```

The installation halted and did not complete.

**Root Cause:**
The Windows Installer (MSI) encountered a fatal error during the feature transfer phase. In this environment the most likely contributing factor was the partial state left by the failed prerequisites script runs — the installer attempted to configure components that were in an inconsistent state.

**Fix Applied:**
1. Clicked OK on the error dialog and cancelled the installer
2. Rebooted the server to clear any locked files or partial registry entries from the failed install attempt
3. Logged back in as the **local Administrator** account (confirmed via `whoami` returning `WIN-PVWA\Administrator`)
4. Closed all other open applications
5. Re-ran `Setup.exe` by right-clicking → **Run as Administrator**

On the second attempt, the installation completed successfully and the PasswordVault application appeared in IIS Manager under Default Web Site.

**Status:** ✅ Resolved — installation completed on second attempt after reboot

---

## Issue 7 — HTTP 503: Service Unavailable on First Browser Access

**Date Encountered:** After Setup.exe completed, on first attempt to access PVWA

**Symptom:**
After installation completed and the server was rebooted, navigating to `https://localhost/PasswordVault` in Chrome returned:

```
Service Unavailable
HTTP Error 503. The service is unavailable.
```

The page loaded (confirming DNS and IIS were working) but the application itself was not responding.

**Root Cause:**
The **PasswordVault Application Pool** in IIS was in a stopped state. This was caused by the earlier -1603 installation error (Issue 6) which left the Application Pool in a crashed/stopped condition even after the installation eventually succeeded.

**Fix:**
1. Opened **IIS Manager**
2. Clicked **Application Pools** in the left panel
3. Located **PasswordVault** in the list — Status showed it was stopped
4. Right-clicked **PasswordVault** → **Stop** (to fully reset it), then right-clicked again → **Start**
5. Refreshed the browser

The PVWA application responded immediately after the Application Pool was restarted.

**Verification:** Confirmed Application Pool settings were correct:
- .NET CLR Version: `v4.0`
- Managed Pipeline Mode: `Integrated`
- Identity: `ApplicationPoolIdentity`

**Status:** ✅ Resolved

---

## Issue 8 — "This Site Can't Be Reached" When Accessing via FQDN

**Date Encountered:** When attempting to access PVWA from another machine using `https://pvwa.pitythefool.com/PasswordVault`

**Symptom:**
Accessing PVWA using the FQDN from a client machine returned:

```
This site can't be reached
The webpage at https://pvwa.pitythefool.com/PasswordVault might be temporarily down
or it may have moved permanently to a new address.
```

**Root Cause:**
The DNS A record for `pvwa.pitythefool.com` did not exist in the domain's DNS zone. The DNS server at `192.168.100.10` had no entry mapping the hostname `pvwa` to the PVWA server's IP address (`192.168.100.13`). This was confirmed by running:

```powershell
nslookup pvwa.pitythefool.com
```

Which returned:
```
*** UnKnown can't find pvwa.pitythefool.com: Non-existent domain
```

Note: A `WIN-PVWA` A record already existed in DNS (pointing to `192.168.100.13`) but there was no `pvwa` record specifically.

**Fix:**
On the DNS server (`192.168.100.10`), opened **DNS Manager**:

1. Expanded **Forward Lookup Zones** → `pitythefool.com`
2. Right-clicked → **New Host (A or AAAA)**
3. Set **Name** to `pvwa`
4. Set **IP Address** to `192.168.100.13`
5. Clicked **Add Host**

After the DNS record was created, `nslookup pvwa.pitythefool.com` correctly resolved to `192.168.100.13` and the site became accessible from other machines on the network.

**Status:** ✅ Resolved

---

## Issue 9 — Certificate Warning: NET::ERR_CERT_COMMON_NAME_INVALID

**Date Encountered:** When accessing PVWA via both `localhost` and `pvwa.pitythefool.com`

**Symptom:**
Chrome displayed a privacy error page instead of the PVWA login page:

```
Your connection is not private
NET::ERR_CERT_COMMON_NAME_INVALID

This server could not prove that it is pvwa.pitythefool.com;
its security certificate is from WIN-PVWA.pitythefool.com.
```

**Root Cause:**
The `PVWA_Prerequisites.ps1` script automatically creates a **self-signed SSL certificate** during setup. This certificate was issued to the server's computer name (`WIN-PVWA.pitythefool.com`) rather than the FQDN being used to access PVWA (`pvwa.pitythefool.com`). Chrome flags this hostname mismatch as an untrusted certificate warning.

This is expected behaviour in a lab environment when using a self-signed certificate.

**Temporary Fix (Lab Environment):**
Clicked **Advanced** → **"Proceed to pvwa.pitythefool.com (unsafe)"** to bypass the warning and access the PVWA login page. This is acceptable for lab use only.

**Permanent Fix (Recommended for Production):**
Replace the self-signed certificate with a certificate issued by the internal Certificate Authority (Active Directory Certificate Services) for the correct FQDN:

1. Install **AD CS** on the Domain Controller if not already present
2. In **IIS Manager** on the PVWA server → **Server Certificates** → **Create Domain Certificate**
3. Set Common Name to `pvwa.pitythefool.com`
4. Select the internal CA to sign the certificate
5. Bind the new certificate to the **https (port 443)** binding on Default Web Site
6. Run `iisreset` to apply changes
7. Run `gpupdate /force` on domain-joined client machines to automatically trust the internal CA

**Status:** ✅ Bypassed for lab | 🔲 Permanent fix pending (AD CS certificate)

---

## Summary Table

| # | Issue | Root Cause | Fix | Status |
|---|---|---|---|---|
| 1 | PVWA_Verify_IIS_Settings failed in prerequisites script | IIS not installed | Installed IIS manually via Server Manager | ✅ Resolved |
| 2 | IIS Manager not in Start Menu | Prerequisites script did not install IIS | Manual IIS installation | ✅ Resolved |
| 3 | Wrong IIS role services selected | Sub-categories not expanded in wizard | Went back and selected all required role services | ✅ Resolved |
| 4 | Features page Next button greyed out | No valid new selections from Server Roles page | Fixed role service selections; Next became active | ✅ Resolved |
| 5 | isSucceeded: 0 with all steps skipping | Components already installed; script skipped re-running | Verified IIS externally; confirmed ready to proceed | ✅ Resolved |
| 6 | Error -1603 Fatal error during Setup.exe | Inconsistent server state from failed prereq runs | Rebooted; re-ran Setup.exe as local Administrator | ✅ Resolved |
| 7 | HTTP 503 Service Unavailable | PasswordVault Application Pool stopped | Stopped and started the Application Pool in IIS | ✅ Resolved |
| 8 | Site can't be reached via FQDN | Missing DNS A record for pvwa.pitythefool.com | Added A record in DNS Manager pointing to 192.168.100.13 | ✅ Resolved |
| 9 | NET::ERR_CERT_COMMON_NAME_INVALID | Self-signed cert issued to wrong hostname | Bypassed in lab; permanent fix via AD CS certificate pending | ✅ Bypassed |

---

*Log maintained for: CyberArk PAM Self-Hosted 12.6 — PVWA Installation*
*Server: WIN-PVWA.pitythefool.com | IP: 192.168.100.13*
