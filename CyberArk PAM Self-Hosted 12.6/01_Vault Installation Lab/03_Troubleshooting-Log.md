**✅ CyberArk PAM 12.6 – Digital Vault Installation**  
**Troubleshooting Log**  
**Project:** Self-Hosted CyberArk Lab (VMware Workstation)  
**Date:** 18 April 2026  
**Component:** Vault Server (IP 192.168.100.11, Workgroup)  
**Prepared for:** Project Documentation / Portfolio  

---

### Executive Summary
The Vault installed successfully using the `Server-Rls-v12.6.13` package from the Google Drive lab materials.  
All issues encountered were **post-install / first-login related** and were resolved without reinstalling the Vault.  
Total resolution time: ~45 minutes across 3 troubleshooting sessions.

### Detailed Troubleshooting Log

| # | Issue / Error | Symptoms | Root Cause | Resolution | Status |
|---|---------------|----------|------------|------------|--------|
| 1 | **Operator CD Path screen failed** (Installer could not find Server key, Recovery Public key, Initial random data file) | Installer prompted for Operator CD but path was rejected even though `Setup.exe` + `data1/data2` folders were copied | Only the large 2.75 GB `Privileged Access Manager Self-Hosted_12.6_...` package was partially copied. The three required key files (`Server.key`, `RecPub.key`, `RndBase.Dat`) were missing from the target folder. | Copied **only** the three key files from Google Drive → `Programs > CyberArk 12.6 > ... > CorePAS > Keys` into the `Server-Rls-v12.6.13` folder on the Vault VM (no need to copy the full 2.75 GB). | **Resolved** |
| 2 | **Vault VM domain membership conflict** | Official documentation required Workgroup; VM was previously joined to `pitythefool.com` (per Zoom video) | Vault component has a **hard requirement** to be installed in a local Workgroup (not domain-joined) | Removed Vault VM from domain (`System Properties → Change → Workgroup = WORKGROUP`). Rebooted and logged in with local Administrator. | **Resolved** (AD, PVWA, CPM, PSM remain domain-joined) |
| 3 | **Second NAT / Internet access** | Question whether NAT adapter was needed on Vault VM | Vault is designed to be isolated. Internet is not a prerequisite for installation or basic operation. | **Not added**. Used existing lab LAN segment only. Prerequisites (.NET 4.8 + Visual C++) were copied over the internal network. | **Not required** |
| 4 | **ITACM012S Timeout has expired** (PrivateArk login failure) | PrivateArk showed “Timeout has expired” even though Vault service was running | PrivateArk client was trying to connect using hostname **`vault`** (which could not be resolved because Vault is in Workgroup + no DNS configured on the isolated network) | In PrivateArk → right-click server entry → Properties → Advanced → Connection tab → changed Address from `vault` to **`192.168.100.11`** | **Resolved** |
| 5 | **Network configuration anomalies** | `ipconfig /all` showed:<br>• Correct IP (192.168.100.11)<br>• Invalid Default Gateway (255.255.255.0)<br>• No DNS servers listed | VMware lab network + static IP misconfiguration | Cleared Default Gateway field (left blank). DNS remains pointed to AD server (.10) for future components. | **Resolved** |
| 6 | **Host RAM constraint** | Host laptop only has 12 GB RAM | Vault VM was allocated too much RAM | Reduced Vault VM memory to **6 GB** (recommended 6–8 GB max on 12 GB host). Powered off other VMs during installation. | **Resolved** |
| 7 | **Post-install service & port readiness** | Initial login attempts failed even after reboot | CyberArk Vault service sometimes needs manual start/restart after first boot | Verified `netstat -an | find "1858"` → confirmed LISTENING + ESTABLISHED connections on port 1858. Restarted **PrivateArk Server** service in `services.msc`. | **Resolved** |

---

### Lessons Learned & Best Practices (for your project report)
- Always keep the **Operator CD Keys** folder separate — you only need the three tiny `.key` + `.Dat` files.
- Vault **must** stay in Workgroup (official requirement). All other components (PVWA, CPM, PSM) can be domain-joined.
- Use **IP address** (not hostname) in PrivateArk for isolated lab environments.
- Keep Vault VM lean on resources — 6 GB RAM is sufficient for a home lab.
- Document every change (especially network settings) for future reproducibility.
