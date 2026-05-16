# CyberArk PAM Self-Hosted 12.6: PSM Installation Lab

## What is this project?

This lab documents my hands-on experience installing the **Privileged Session Manager (PSM)** component of CyberArk PAM Self-Hosted 12.6. PSM is the most architecturally unique component in the CyberArk stack — it requires a fundamentally different server configuration compared to PVWA and CPM, and understanding *why* makes the installation make a lot more sense.

This project walks through setting up a dedicated PSM server from scratch, including the Remote Desktop Services configuration that PSM depends on, the installation wizard, hardening, and verifying the PSM is active through PVWA's System Health dashboard.

---

## What is PSM and Why Does It Matter?

The **PSM (Privileged Session Manager)** is CyberArk's session isolation and recording engine. It acts as a **jump server** — a secure intermediary that sits between the user and the target system they want to connect to.

Here is how a PSM-brokered session works:

1. A user logs into **PVWA** and requests access to a privileged account (e.g., a Windows server's local admin)
2. PVWA instructs **PSM** to initiate the connection on the user's behalf
3. PSM retrieves the credential from the **Vault** — the user never sees the password
4. PSM connects to the target system using that credential
5. The user's session is **isolated, monitored, and recorded** in real time
6. The session recording is stored securely back in the **Vault**

This architecture means:
- Users never have direct access to privileged credentials
- Every privileged session is recorded and auditable
- Malware on the user's machine cannot jump to the target system — PSM acts as the boundary
- Compliance requirements for session monitoring are met automatically

Without PSM, CyberArk can store and rotate passwords, but it cannot broker or record the sessions where those passwords are actually used.

---

## The Tools and Technologies I Used

- **CyberArk PAM Self-Hosted 12.6** — The PAM platform
- **Privileged Session Manager (PSM)** — The session isolation and recording component being installed
- **Windows Server 2019** — Dedicated server for the PSM installation
- **Remote Desktop Services (RDS) Session Host** — The Windows role that PSM is built on top of. PSM uses RDS to broker sessions between users and target systems
- **PowerShell** — Used to run the prerequisites script
- **CyberArk Vault** — Stores session recordings and PSM credentials
- **PVWA** — Used after installation to activate and verify the PSM

---

## Architecture Decision: Why PSM is Different from PVWA and CPM

PSM is architecturally unique for one key reason — it is built **on top of Windows Remote Desktop Services (RDS)**. Every privileged session a user launches goes through PSM as an RDS session. This means the PSM server must be configured as an **RDS Session Host** before the CyberArk installer even runs.

This also means PSM's hardening is the most aggressive of all CyberArk components. After hardening, the PSM server is locked down so tightly that even administrators cannot freely browse its file system. This is by design — PSM handles live privileged sessions and their recordings, so it must be treated as a high-security appliance.

The server I used for this installation:

| Server | Role |
|---|---|
| WIN-VAULT | CyberArk Digital Vault |
| WIN-PVWA | Password Vault Web Access |
| WIN-CPM | Central Policy Manager |
| **WIN-PSM** | **Privileged Session Manager ← this lab** |
