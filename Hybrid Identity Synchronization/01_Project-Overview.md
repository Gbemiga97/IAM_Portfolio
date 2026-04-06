# My Hands-On Microsoft Entra Connect Lab: Hybrid Identity Synchronization with VMware Workstation

**Project Overview**  
I built a complete on-premises lab environment using VMware Workstation to simulate a real-world hybrid identity setup for a small tech company. The goal was to configure Microsoft Entra Connect (formerly Azure AD Connect) to securely synchronize user accounts, groups, and attributes from an on-premises Active Directory domain to Microsoft Entra ID. This enables seamless single sign-on (SSO) and password hash synchronization for Microsoft 365 services without fully migrating to the cloud.

**Why I did this:**  
As an IT professional in Lagos, I wanted hands-on experience with hybrid identity management—the exact scenario many organizations face today. I used VMware Workstation Pro on my local machine to keep everything contained, cost-free, and fully under my control (no cloud VM costs). The domain I created is `cloud.training` (a non-routable domain perfect for labs). I installed Entra Connect directly on the domain controller for simplicity in this test environment, enabled Password Hash Synchronization + Seamless SSO, scoped synchronization to specific OUs, and then dove into advanced management with PowerShell.

**Tools & Environment I Used**  
- VMware Workstation Pro (latest version)  
- Windows Server 2022 Standard (evaluation ISO)  
- Microsoft Entra Connect (version 2.3.8.0)  
- A free Microsoft Entra ID tenant (P2 trial for full features)  
- PowerShell 5.1 + Active Directory module  
- Remote Desktop for management  
- Microsoft Entra admin center for verification  

**Lab Topology**  
- **DC01** – Windows Server 2022 VM (4 vCPU, 8 GB RAM, 60 GB disk) – Domain Controller + Entra Connect server  
- Domain: `cloud.training`  
- Test OU structure with sample users and groups  
- All networking handled via VMware NAT (internet access for sync to Entra ID)  
