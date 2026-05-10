# CyberArk PAM Self-Hosted 12.6: CPM Installation Lab

## What is this project?

This lab documents my hands-on experience installing the **Central Policy Manager (CPM)** component of CyberArk PAM Self-Hosted 12.6. After completing the PVWA installation, the CPM is the next critical piece of the architecture — it's what actually *does* the password management work behind the scenes.

This project walks through setting up a dedicated CPM server from scratch, connecting it to the CyberArk Vault, running the hardening process, and verifying that the CPM service is working correctly through PVWA.

---

## What is the CPM and Why Does It Matter?

The **CPM (Central Policy Manager)** is CyberArk's automated password management engine. If the PVWA is the "dashboard" users log into, the CPM is the "engine room" that runs quietly in the background doing the actual work.

Its job is to:
- **Automatically rotate passwords** on target systems (Windows servers, Linux machines, network devices, databases) according to defined schedules and policies
- **Verify** that passwords on remote machines match what's stored in the Vault
- **Reconcile** passwords when they get out of sync between the Vault and the target machine

Without CPM, the Vault is just a static password store. With CPM, it becomes a fully automated Privileged Access Management system.

---

## The Tools and Technologies I Used

- **CyberArk PAM Self-Hosted 12.6** — The PAM platform
- **Central Policy Manager (CPM)** — The automated password management component being installed
- **Windows Server 2019** — Dedicated server for the CPM installation
- **PowerShell** — Used to run CyberArk's pre-installation and hardening scripts
- **Microsoft Visual C++ Redistributable (2015–2022)** — Required dependency for CPM
- **CyberArk Vault** — The Vault that the CPM connects to and authenticates against
- **PVWA** — Used after installation to verify the CPM is active and configure its settings

---

## Architecture Decision: Why a Dedicated Server?

Before touching anything, I want to be clear on *why* CPM gets its own server.

It would seem tempting to install CPM on the PVWA server to save resources. However, CyberArk's hardening scripts for each component are written to lock down the server specifically for that component's role. Running CPM on the PVWA server means two hardening profiles compete against each other, and something breaks. The same applies to PSM.

The clean, correct approach is one dedicated server per component:

| Server | Role |
|---|---|
| WIN-VAULT | CyberArk Digital Vault |
| WIN-PVWA | Password Vault Web Access |
| **WIN-CPM** | **Central Policy Manager ← this lab** |
| WIN-PSM | Privileged Session Manager |

---

## What I Did (Step-by-Step)

### 1. Preparing the CPM Server

I started with a clean **Windows Server 2019** virtual machine named `WIN-CPM`, joined to the `pitythefool.com` domain.

**Key things confirmed before starting:**

- Logged in as the **local Administrator** account — not a domain admin. This is the same requirement as PVWA; domain accounts alone will not work for CyberArk component installations
- Confirmed network connectivity to the **Vault server** — the CPM must be able to reach the Vault on **port 1858**. I tested this with:

```powershell
Test-NetConnection -ComputerName <VaultIP> -Port 1858
```
  If `TcpTestSucceeded` returns `True`, the path is open. If not, a firewall rule needs to be added before proceeding.

- **CPM placement matters:** The CPM should be positioned close to the target systems it will manage (the servers whose passwords it rotates). This reduces network latency during password change operations.

---

### 2. Installing the Visual C++ Prerequisite

Unlike PVWA, the CPM installer requires **Microsoft Visual C++ Redistributable for Visual Studio 2015–2022** to be installed before Setup.exe will proceed. The installer will check for this and prompt you, but it's cleaner to handle it manually first.

Install both versions:
- **Visual C++ Redistributable 2015–2022 (x64)** — 64-bit version
- **Visual C++ Redistributable 2015–2022 (x86)** — 32-bit version

Both are available from Microsoft's official download page. Install x64 first, then x86, and confirm both complete without errors.

> 💡 **Why both?** CyberArk's CPM plugins include both 32-bit and 64-bit components. Missing either version will cause plugin failures later even if the core service appears to be running.

---

### 3. Running the Pre-Installation Script

CyberArk provides a PowerShell pre-installation script that prepares the server before the main installer runs.

1. Copied the `Central Policy Manager` folder from the CyberArk installation package to the CPM server
2. Navigated to the `InstallationAutomation` folder inside it
3. Opened **PowerShell as Administrator**
4. Ran the pre-installation script:

```powershell
.\CPM_PreInstallation.ps1
```

5. Waited for the script to complete and reviewed the output for any failures
6. **Rebooted the server** before proceeding

The pre-installation script handles low-level system preparation tasks so the server is in the correct state for the CPM installer.

> 💡 **Tip:** Always reboot after this script completes, even if it doesn't explicitly ask you to. Skipping the reboot is a common source of installer failures.

---

### 4. Installing CPM (The Main Installation)

With the server rebooted and prerequisites in place, I ran the main CPM installer.

1. Navigated to the `Central Policy Manager` folder from the installation package
2. **Right-clicked** `Setup.exe` → **Run as Administrator**

   > ⚠️ Same rule as PVWA — must be explicitly run as Administrator, not just double-clicked.

3. Clicked **Next** on the welcome screen
4. The installer displayed a list of required applications — clicked **Install** to let it handle any remaining dependencies automatically
5. Accepted the **License Agreement**
6. Entered name and company in the **Customer Information** window
7. Left the **Destination Folder** as the default location and clicked **Next**

8. In the **Vault Connection Details** window, entered:
   - **Vault IP address** — the IP of the CyberArk Vault server
   - **Port** — `1858` (default Vault port)

   > 💡 **This is the most critical step.** If the Vault IP or port is wrong, the CPM will install but will not be able to authenticate to the Vault, and the `CyberArk Password Manager` service will fail to start.

9. Entered the **Vault Administrator username and password**. The installer uses these credentials to:
   - Create the `PasswordManager` user in the Vault
   - Create the `PasswordManager` Safe in the Vault
   - Store the CPM's credential file so it can authenticate automatically on startup

10. The installer then built the CPM environment in the Vault. Clicked through the remaining screens and let the installation complete
11. Clicked **Finish**
12. **Restarted the server**

---

### 5. Verifying the CPM Service is Running

After rebooting, the first thing to check is whether the CPM Windows services started correctly.

1. Open **Services** (search "Services" in Start Menu, or run `services.msc`)
2. Look for these two services — both should show **Status: Running**:

| Service Name | What It Does |
|---|---|
| **CyberArk Password Manager** | The core CPM engine that manages and rotates passwords |
| **CyberArk Central Policy Manager Scanner** | Scans for accounts that need attention (verification, reconciliation) |

If either service is stopped, right-click → **Start**. If it immediately stops again, the Vault connection details entered during installation were likely incorrect.

---

### 6. Verifying CPM in PVWA

After confirming the services are running locally, I logged into PVWA to verify the CPM was showing as connected from the management side.

1. Opened Chrome and navigated to `https://pvwa.pitythefool.com/PasswordVault`
2. Logged in with the Vault Administrator credentials
3. Went to **Administration** → **Configuration Options** → **CPM Settings**
4. The CPM (listed as `PasswordManager`) should appear with a **connected** status

> 💡 **Common issue at this stage:** If PVWA shows the CPM as disconnected, check that the CPM server can reach the PVWA server on **port 443** (HTTPS). The CPM communicates back to PVWA via an API, and a firewall blocking that port will prevent the status from appearing correctly.

---

### 7. Running the CPM Hardening Script

Just like PVWA, the CPM installation must be followed by running the hardening script. This is not optional — it's a required security step.

1. Opened **PowerShell as Administrator** on the CPM server
2. Navigated to the `InstallationAutomation` folder inside the CPM installation package
3. Ran the hardening script:

```powershell
.\CPM_Hardening.ps1
```

**What the hardening script does:**
- Creates three dedicated **local Windows service accounts** to run the CPM processes with least-privilege permissions:
  - `PasswordManagerUser` — runs the core CPM service
  - `ScannerUser` — runs the CPM Scanner service
  - `PluginManagerUser` — runs all CPM plugins (introduced in version 12.2)
- Applies **Group Policy Object (GPO) settings** that lock down what these accounts can and cannot do
- Disables **TLS 1.0 and 1.1** on the CPM server by default — only TLS 1.2 is permitted
- Restricts unnecessary services and tightens file system permissions

**Important domain-specific step:**

If the CPM server is domain-joined (which it should be in most environments), after hardening run:

```powershell
gpupdate /force
```

This forces the new CPM Group Policy settings to apply immediately rather than waiting for the next scheduled refresh. Without this, the CPM service accounts may not have the correct "Logon as a service" rights, and the services will fail to start after the next reboot.

---

### 8. Post-Installation: Creating a Trusted Network Area

This is a security step that locks the CPM's Vault user down so it can **only** log into the Vault from the CPM server — nowhere else.

1. On the **Vault server**, open **PrivateArk Client** and log in as Administrator
2. Go to **Tools** → **Administrative Tools** → **Users and Groups**
3. Find the `PasswordManager` user (created automatically during CPM installation)
4. Go to the **Trusted Network Areas** tab
5. Add a new Network Area containing **only the CPM server's IP address** (e.g., `192.168.100.12`)
6. Save and close

This means even if someone obtained the CPM's credentials, they could not use them to log into the Vault from any machine other than the legitimate CPM server. It's a small configuration that makes a big security difference.

---

### 9. Saving the Installation Log

During installation, CyberArk creates a log file called `CPMInstall.log` in the Windows Temp folder. This file is automatically deleted on the next reboot.

Before rebooting, copy it somewhere safe:

```powershell
Copy-Item "$env:TEMP\CPMInstall.log" -Destination "C:\CyberArk_Logs\CPMInstall.log"
```

This log is invaluable for troubleshooting if anything goes wrong with the CPM later, and it's good practice to keep it for your records.

---

## Key Concepts I Focused On

- **Separation of Components:** Each CyberArk component runs on its own dedicated server. This isn't just best practice — it's required for the hardening scripts to work correctly without conflicting with each other.
- **Service Account Least Privilege:** The CPM hardening script creates dedicated local accounts with the minimum permissions needed. No component should run as a full administrator if it doesn't need to be.
- **Trusted Network Areas:** Restricting the CPM's Vault user to only authenticate from the CPM server's IP is a simple but powerful security control.
- **TLS 1.2 Only:** Version 12.6 disables TLS 1.0 and 1.1 by default during hardening. All communication in the environment must support TLS 1.2 or later.
- **Log Preservation:** Installation logs are temporary and get deleted on reboot. Saving them proactively is a habit that saves significant troubleshooting time later.

---

## What I Learned

- How the CPM fits into the CyberArk architecture and why it needs to be network-adjacent to the systems it manages
- That CyberArk installations follow a consistent three-phase pattern across all components: **prerequisites → installation → hardening** — and skipping or rushing any phase causes problems
- Why the Trusted Network Area configuration matters: without it, the CPM's Vault credentials could theoretically be used from any machine on the network
- **Most importantly:** I learned that the CPM is where CyberArk's value is actually delivered. It's the difference between a password manager that stores credentials and a PAM solution that actively enforces password policy, automates rotation, and removes the human element from credential management.

---

## Conclusion: Why This Lab Matters

Installing the CPM completed the core of the CyberArk PAM architecture for my lab environment. With the Vault storing credentials, PVWA providing the management interface, and CPM automating password lifecycle management, the environment now functions as a real Privileged Access Management solution — not just a credential store.

Through this project, I gained confidence in:

1. **Component Architecture:** Understanding how the Vault, PVWA, and CPM communicate with each other and depend on each other to deliver a complete PAM solution.
2. **Automated Password Management:** Understanding how CPM policies, platforms, and safes work together to determine *which* accounts get rotated, *when*, and *how*.
3. **Security Hardening at Scale:** Applying the principle of least privilege not just to user accounts, but to the service accounts and processes that run the security infrastructure itself.
4. **Troubleshooting Methodology:** Reading service statuses, checking PVWA connection indicators, reviewing log files, and using PowerShell to validate network connectivity — the same diagnostic process used in real enterprise environments.

This lab, combined with the PVWA installation, has given me a solid foundation for working with CyberArk PAM in a professional environment and contributing meaningfully to PAM implementation and operations teams.

---

## About

A hands-on cybersecurity lab project documenting the end-to-end installation of CyberArk PAM Self-Hosted 12.6 CPM (Central Policy Manager) on a dedicated Windows Server 2019, including prerequisites, Vault integration, hardening, and post-installation verification through PVWA.
