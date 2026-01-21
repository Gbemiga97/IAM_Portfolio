# Project Outcome & Lessons Learned  
**Entra ID Lifecycle Workflows – Joiner/Mover/Leaver Lab (Completed 22 November 2025)**


### Risks in the JML Lifecycle

This Project highlights several key risks associated with poor management of the Joiner-Mover-Leaver (JML) process in Identity and Access Management (IAM):

- **Orphaned Accounts**: These occur primarily in the Leaver phase when access isn't revoked promptly after an employee departs. This can lead to data theft by former employees, compliance audit failures, and unnecessary costs associated with unused licenses. Automation in JML aims to deprovision 98% of secondary applications immediately, closing gaps that manual processes often miss.
- **Privilege Creep**: Common in the Mover phase during role changes like promotions, where users accumulate unnecessary permissions from prior positions. This heightens security vulnerabilities. JML mitigates this through "delta provisioning," which only adds new access while removing obsolete access, often requiring manager approval to evaluate necessity.
- **General Risks**: Over 70% of unauthorized access stems from human errors in manual processes. In the Joiner phase, risks include identity theft, countered by mandatory multifactor authentication (MFA) from day one. Delayed actions across phases can exacerbate broader threats like data breaches.

### Governance and Compliance in JML

Governance in JML ensures structured, compliant access management, aligning with Zero Trust principles like least privilege:

- **Compliance Standards**: JML supports regulations such as GDPR (for data protection), SOX (for financial reporting integrity), and ISO 27001 (for information security management). This involves auditing access logs in Joiner, documenting changes in Mover, and ensuring swift revocation in Leaver to meet legal requirements.
- **Role-Based Access Control (RBAC)**: A core governance tool, it uses a "birthright access matrix" to assign default permissions based on job roles in Joiner, preventing over-provisioning while maintaining consistency.
- **Stakeholder Roles**: HR ensures accurate employee data, IT/security oversees the IAM platform, and managers approve/recertify access, fostering accountability.


### ✅ Final Outcome – 100% Working
- Pre-hire Joiners are created disabled with employeeHireDate populated  
- On hire date the built-in “Onboard pre-hire employee” workflow runs automatically  
- Account is enabled  
- Temporary Access Pass (TAP) is generated and emailed to the user’s manager  
- Welcome email is sent to the new user  
- Licenses and groups are assigned successfully  
- All tasks complete with green checkmarks

### 🧠 Key Lessons Learned
1. Joiners must be created with AccountEnabled = $false when employeeHireDate exists  
2. The manager attribute cannot be set via normal Graph cmdlets (Set-MgUserManagerByRef) on disabled accounts – only the portal or direct Invoke-MgGraphRequest works  
3. The manager must have an Exchange Online mailbox (or at least a valid mail attribute) to receive the TAP email  
4. The new user must have the mail attribute (or proxyAddresses) populated for the welcome email to send  
5. UsageLocation must be a valid two-letter ISO code in PowerShell – NG works perfectly for Nigeria (not “Nigeria” or “NGA”)  
6. Tasks later in the workflow are automatically cancelled if an earlier task fails (e.g. TAP fails → everything after is cancelled)  
7. Splatting (@params) is far more reliable than positional parameters with New-MgUser  
8. Manual assignment of managers in the portal is the fastest workaround for disabled accounts in a lab environment  

