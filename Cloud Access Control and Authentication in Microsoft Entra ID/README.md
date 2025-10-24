
# “Designing and Implementing Secure Authentication and Authorization for Cousera Cloud Services Using Microsoft Entra ID”

## 🏢 Scenario Overview:

Cousera Cloud Services, a technology consulting startup with 150 employees, has recently migrated all internal tools and SaaS platforms to the Microsoft cloud ecosystem.

They rely on Microsoft Entra ID to manage user access to:

Microsoft 365 (for productivity apps),

GitHub Enterprise,

Salesforce, and

A custom-built HR Web App (hosted on Azure App Service).

However, Cousera’s leadership is concerned about unauthorized access and inconsistent user permissions.
You’ve been brought in as a Microsoft Entra ID Administrator to strengthen authentication and authorization controls — ensuring secure, seamless access for employees, contractors, and admins.

## 🧠 Project Objectives:

Implement Secure Authentication in Microsoft Entra ID

Enforce Multi-Factor Authentication (MFA) for all users.

Configure Conditional Access Policies for location-based sign-in.

Enable Sign-in risk detection and User risk policies using Entra ID Identity Protection.

Set Up Role-Based Authorization

Create custom Entra roles (e.g., App Manager, HR Admin, Developer).

Assign least privilege access using built-in and custom roles.

Use Administrative Units (AUs) to delegate permissions by department.

Configure and Test Access to Enterprise Applications

Register a custom HR web application in Microsoft Entra ID.

Assign app roles (e.g., HR.User, HR.Admin) to users and groups.

Test OAuth 2.0 / OpenID Connect authentication flow (using Postman or app registration portal).

Integrate another app (e.g., Salesforce or GitHub Enterprise Cloud) via SAML or OIDC SSO.

Set Up Privileged Identity Management (PIM)

Enable PIM for directory roles.

Configure “Just-in-Time” (JIT) activation for Global Administrator and Application Administrator roles.

Require MFA for PIM activation and add justification notes.

Audit and Monitor Authentication Events

Review sign-in logs and audit logs in Microsoft Entra ID.

Generate a security report showing successful MFA challenges, blocked sign-ins, and risk detections.

Export the report and visualize it in Excel or Power BI.
   

## 🧱 Phase 1: Implement Secure Authentication (MFA & Conditional Access)
### Step 1️⃣ – Create Test Users and Groups

1. Go to Microsoft Entra Admin Center → Users → New User → Create new users

  - alice@cousera894.onmicrosoft.com (HR Manager)

  - bob@cousera894.onmicrosoft.com (Developer)

  - carol@cousera894.onmicrosoft.com (Finance)

Assign each a temporary password.

📸 **Screenshots:** 


<img width="300" height="400" alt="Screenshot 2025-10-23 131538" src="https://github.com/user-attachments/assets/b78c491c-08ca-4cb7-8a9d-44bbebcf0085" />
<img width="300" height="400" alt="Screenshot 2025-10-23 132156" src="https://github.com/user-attachments/assets/d5905b48-aa9d-4eab-aac1-2fe4bd4a188c" />
<img width="300" height="400" alt="Screenshot 2025-10-23 131813" src="https://github.com/user-attachments/assets/a0233b88-789b-4afd-9618-1c5db1be0ab8" />


2. Create a dynamic group called "Cousera All Employees" and add all **Internal** and **B2B** users.
   
📸 **Screenshots:**

<img width="300" height="400" alt="Screenshot 2025-10-24 171204" src="https://github.com/user-attachments/assets/ac1068f5-953e-4d24-94ee-5d8eeb95822f" />
<img width="600" height="700" alt="Screenshot 2025-10-24 171132" src="https://github.com/user-attachments/assets/b76dd041-270e-4944-b595-66665e13a05b" />

