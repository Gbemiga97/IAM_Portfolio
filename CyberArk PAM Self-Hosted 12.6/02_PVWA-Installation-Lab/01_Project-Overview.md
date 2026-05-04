# CyberArk PAM Self-Hosted 12.6: PVWA Installation Lab

## What is this project?

I built this lab to get hands-on experience with CyberArk's Privileged Access Management (PAM) solution — specifically installing and configuring the **Password Vault Web Access (PVWA)** component in a self-hosted environment.

Instead of just reading about it, I wanted to actually set it up from scratch, go through the real installation process, and understand what each piece does and *why* it matters in a real enterprise environment.

This project documents how I deployed PVWA version 12.6 on a Windows Server, connected it to the CyberArk Vault, and verified it was working end-to-end.

---

## The Tools and Technologies I Used

- **CyberArk PAM Self-Hosted 12.6** — The Privileged Access Management platform I'm deploying.
- **Password Vault Web Access (PVWA)** — The web interface that lets users and admins access and manage privileged accounts through a browser.
- **Windows Server 2019** — The operating system where PVWA is installed.
- **IIS (Internet Information Services)** — The web server that hosts the PVWA web application.
- **.NET Framework 4.8** — Required background software that PVWA depends on.
- **PowerShell** — Used to run CyberArk's automation and prerequisite scripts.
- **CyberArk Vault** — The secure "digital safe" that PVWA connects to in order to store and retrieve privileged credentials.

---
