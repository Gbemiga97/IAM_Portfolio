**Part 2: Moving Microsoft Entra Connect to a Dedicated Server – Best Practices & Staging Server Migration in My cloud.training Hybrid Lab**

**Why I’m Moving Entra Connect (Best Practices Reason)**  
In Part 1, I installed Entra Connect directly on **DC01** for simplicity in the initial VMware lab build. While this worked fine for testing, it’s **not a recommended production practice**.  

Microsoft strongly advises installing Microsoft Entra Connect on a **dedicated domain-joined member server** (not a domain controller). Reasons include:  
- Security: DCs should run only the AD DS role with minimal additional software to reduce attack surface.  
- Stability & Maintenance: Patching/upgrading the DC or restarting services can temporarily disrupt synchronization.  
- Performance & Support: A dedicated server allows better resource allocation, easier troubleshooting, and full use of the Virtual Service Account (VSA) for the sync service.  
- Operational Best Practices: Treating the Entra Connect server as a Tier 0 asset while keeping DCs focused solely on directory services.

This move also allows me to implement a proper **staging server** setup for zero-downtime configuration testing and future failovers.

**Should It Be a Domain Controller or Member Server?**  
It **must be a domain-joined server**.  
**Best practice = Member server** (not a DC). In my lab, I created a new VM called **SYNC01** as a domain-joined member server (Windows Server 2022/2025 with full GUI – Server Core is not supported).

**Lab Topology Update**  
- **DC01** – Existing Domain Controller (`cloud.training`) – will become staging or decommissioned later.  
- **SYNC01** – New dedicated Entra Connect server (4 vCPU, 8 GB RAM, 60 GB disk recommended) – domain-joined member server.  
- All in VMware Workstation with NAT networking and internet access.
