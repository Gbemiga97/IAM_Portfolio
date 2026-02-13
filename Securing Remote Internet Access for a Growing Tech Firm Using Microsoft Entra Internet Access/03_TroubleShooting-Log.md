# Troubleshooting Log: Microsoft Entra Internet Access Pilot Project

**Project Context**  
Scenario-based implementation of Microsoft Entra Internet Access (part of Global Secure Access) for secure web access and content filtering at TechNova (remote/hybrid workforce).  
Test environment: Windows 11 Enterprise Evaluation (Build 26100), using a test Entra tenant.  
Date of issues: ~February 2026  
Goal: Enable traffic forwarding, bypass rules, web content filtering, and verify with tools like ipchicken.com.

This log documents the main client-side issues encountered, diagnostics performed, and resolutions. All issues were resolved without opening a Microsoft support ticket.

## 1. Global Secure Access Client Health Check: "Global Secure Access processes have crashed in the last 24h"

**Symptom**  
- In Advanced Diagnostics → Health check tab: Red error "Global Secure Access processes have crashed in the last 24h".  
- All other health checks passed (e.g., Can connect to the internet: True, Tunneling service running: True, etc.).  
- Client appeared functional otherwise.

**Root Cause (Likely)**  
- Transient process crash (e.g., gsaclient.exe or related service) within the rolling 24-hour window.  
- Common triggers: Initial installation glitches, conflicts with other security software, resource issues, or driver conflicts during early setup.  
- The error is historical—it doesn't mean the client is currently broken, but it won't auto-clear until 24 hours pass without new crashes.

**Resolution Steps**  
1. Restarted the Global Secure Access client (tray icon → Exit → Relaunch).  
2. Rebooted the entire device (cleared any stuck state).  
3. Checked Event Viewer (Windows Logs → Application) for crash entries (Event ID 1000/1001) around the time of issue.  
4. Enabled process dumps for future crashes:  
   - Registry: `HKLM\SOFTWARE\Microsoft\Windows\Windows Error Reporting\LocalDumps`  
   - Added `DumpFolder` REG_SZ value pointing to `C:\Dumps`.  
5. Monitored for recurrence—no further crashes occurred after restart + reboot.

**Outcome**  
- Error persisted in Health check for ~24 hours (by design), then cleared automatically.  
- Client remained stable afterward.  
- Lesson: Restart/reboot often resolves transient client issues; enable dumps early for better diagnostics.

## 2. Bypass Rule for ipchicken.com Configured but Traffic Shows as "Tunnel" (Not Bypassed)

**Symptom**  
- Custom bypass rule added in Entra admin center: Internet Access profile → Custom Bypass → FQDN = **www.ipchicken.com** → Action: Bypass.  
- Rule correctly appeared in client Advanced Diagnostics → Forwarding profile tab (Action: Bypass for www.ipchicken.com).  
- But in Traffic tab (after removing default Action==Tunnel filter): Entries for the site showed Action: Tunnel / Connection Status: Tunneled.  
- Site reported a Microsoft GSA edge IP (not real public IP).

**Root Cause**  
- **FQDN mismatch / exact match requirement**: The bypass rule was configured for the exact FQDN `www.ipchicken.com`.  
  However, on the client device, the test was performed by accessing `https://ipchicken.com` (without the `www` subdomain).  
  Global Secure Access custom bypass rules use **exact FQDN matching** (no automatic subdomain handling or canonical redirects considered for rule evaluation).  
  When the browser resolved and requested `ipchicken.com`, it didn't match the configured `www.ipchicken.com` rule, so the traffic fell back to the default "Tunnel" behavior.  
  (Note: The site itself may serve content on both, but the client's traffic decision is based on the requested hostname/FQDN, not post-redirect.)

**Resolution Steps**  
1. Identified the mismatch by comparing the configured rule (`www.ipchicken.com`) vs. the accessed URL (`ipchicken.com`).  
2. Updated the custom bypass rule in Entra admin center:  
   - Added both `ipchicken.com` and `www.ipchicken.com` (comma-separated: `ipchicken.com,www.ipchicken.com`) to cover common variations.  
   - (Alternatively, could use a wildcard like `*.ipchicken.com` if supported and appropriate, but exact FQDNs were sufficient here.)  
3. Saved the policy and waited for propagation (~5–15 minutes).  
4. Restarted the Global Secure Access client (tray icon → Exit → Relaunch) and rebooted the device.  
5. Re-tested by accessing both `https://ipchicken.com` and `https://www.ipchicken.com` in a new/incognito tab.  
6. Verified in Traffic tab (no Action==Tunnel filter): Action: Bypass / Connection Status: Bypassed.  
7. Confirmed in Hostname acquisition tab: DNS queries matched the updated bypass rule(s).

**Outcome**  
- After adding the non-www variant: Traffic bypassed correctly for both URLs.  
- ipchicken.com reported real public IP → bypass fully confirmed working.  
- Lesson: **Always test with the exact FQDN used in the rule**. Custom bypass rules require precise matching (including subdomains like www). Consider adding both variants or using wildcards when FQDNs have common aliases/redirects. Propagation + client restart is still key after rule changes.

## 3. Prerequisite Configuration: Prefer IPv4 over IPv6 & Disable QUIC in Microsoft Edge

**Symptom**  
- These were flagged early (likely in Health check or known prerequisites).  
- Without fixes: Potential for intermittent tunneling issues, especially with FQDN rules.

**Resolution Steps**  
1. **Prefer IPv4**: Already configured (via registry or network adapter settings to prioritize IPv4). Confirmed in Health check.  
2. **Disable QUIC in Edge**:  
   - edge://flags → Search "QUIC" → Experimental QUIC protocol → Disabled.  
   - Restarted Edge.  
3. Verified no interference from other browsers/software using QUIC/UDP 443.

**Outcome**  
- No direct issues from these after fixes.  
- Prevented potential QUIC-related bypass/tunneling conflicts (e.g., UDP traffic bypassing GSA incorrectly).  
- Lesson: Always address IPv4 preference + QUIC disable before testing forwarding rules (GSA primarily supports IPv4; QUIC can interfere).

## Summary & Key Takeaways
- **Total time lost to troubleshooting**: ~2–3 hours across sessions (mostly waiting for propagation/restarts and rule tweaks).  
- **Most common pitfalls**: Propagation delays (5–15 min after config changes), default Traffic tab filters hiding bypass success, DNS interception requirements for FQDN rules, **exact FQDN matching (including www vs non-www)**, and transient client crashes.  
- **Best practices learned**:  
  - Always use Advanced Diagnostics → remove default filters.  
  - Check Hostname acquisition tab for FQDN rule matching.  
  - Test with the **exact** FQDN(s) configured in bypass rules—add variants if needed.  
  - Restart client/device liberally after changes.  
  - Disable interfering features early (DoH, QUIC, IPv6 preference issues).  
  - Collect logs (Advanced log collection) before major changes for rollback/reference.

This log can be referenced for future deployments or shared with team members.  
No open issues remain—all tests (bypass, Microsoft 365 optimization, web filtering) passed successfully.

Last updated: February 13, 2026
