# CyberArk PAM Self-Hosted 12.6 Vault Installation Lab

**A hands-on guide to deploying the core Enterprise Password Vault for Privileged Access Management (PAM) in a self-hosted environment.**

This lab walks through installing a standalone CyberArk Digital Vault (the heart of PAM) on a dedicated Windows server. It covers everything from environment preparation to post-install verification, making it ideal for beginners learning PAM fundamentals.

## Tools and Prerequisites

- **Windows Server**: Clean installation of Windows Server 2016, 2019, or 2022 (64-bit). The Vault must run in a Workgroup (not joined to a domain).
- **Hardware**: Dedicated physical or virtual server with:
  - Minimum 16 GB RAM (32 GB+ recommended for production).
  - Multiple CPUs.
  - Sufficient disk space (at least 100 GB free; plan for terabytes if using PSM recordings later).
  - Static IP address.
- **Installation Package** (provided by CyberArk Support):
  - Vault Server software (`Server` folder with `Setup.exe`).
  - Operator folder/CD (contains Server Key and Recovery Public Key).
  - Master folder/CD (for emergencies; contains Recovery Private Key).
  - License file (`.xml`).
- **Software Prerequisites**:
  - Microsoft .NET Framework Runtime.
  - Microsoft Visual C++ Redistributable 2022 (x64 and x86).
- **Network**:
  - Static IP configured.
  - No DNS servers configured on the NIC.
  - Firewall will be hardened automatically during install.
- **Other**:
  - Administrator access to the server.
  - Backup of any existing data (this is a clean install).
  - Optional: Hardware Security Module (HSM) client if using external key storage.
