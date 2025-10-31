
# “Automated Identity Lifecycle Management (Joiner–Mover–Leaver Process) for Cousera Ltd.”



## 🏢 Scenario Overview

**Company:** Cousera Ltd.  
**Industry:** Technology Consulting  
**Environment:** Microsoft 365 + Entra ID  
**Challenge:** HR manually creates and removes accounts — prone to errors, delays, and license waste.  
**Goal:** Automate provisioning, updates, and deprovisioning from a mock HR database into Entra ID.  

## Project Overview
This scenario-based project guides you through implementing automated Joiner-Mover-Leaver (JML) processes using Microsoft Entra ID's Lifecycle Workflows. The goal is to reduce manual administrative tasks, ensure compliance, and streamline user access management. This Lab simulates a real-world deployment for a fictional mid-sized tech company, "Cousera Ltd," which has 500 employees, uses Microsoft 365 for productivity, and integrates with an HR system like Workday for employee data.
## 🎯 Objective

**Design and implement a cloud-based identity lifecycle management (ILM) solution that:**

- Automatically provisions new users in Entra ID (Joiners).

- Assigns access based on department and job role (RBAC).

- Updates permissions when users move departments (Movers).

- Revokes access and licenses automatically when users leave the company (Leavers).
  
- Integrate with HR-driven attributes for triggers.

- Test the workflows for reliability.

  
## Scenario Description
InnoTech is expanding its engineering team and facing challenges with manual user management. New hires often wait days for access to tools like GitHub or internal apps. Department changes lead to outdated permissions, risking security gaps. Departures sometimes leave active accounts, posing compliance risks. To address this,  Lifecycle Workflows will be deployed to automate these processes, triggered by HR data synced to Entra ID attributes.

**For example:**

**Joiner:** A new software engineer, Annie, joins the DevOps team.  
**Mover:**  Brian transfers from Marketing to Sales.  
**Leaver:** Charlie resigns, requiring immediate access revocation.  

Three workflows will be created: one for each JML phase, using predefined tasks like email notifications, group assignments, and license management.




