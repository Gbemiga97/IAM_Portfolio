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
