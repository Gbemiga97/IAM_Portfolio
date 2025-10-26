# “Designing and Implementing Secure Authentication and Authorization for Cousera Cloud Services Using Microsoft Entra ID”

## 🏢 Scenario Overview:

Cousera Cloud Services, a technology consulting startup with 150 employees, has recently migrated all internal tools and SaaS platforms to the Microsoft cloud ecosystem.

They rely on Microsoft Entra ID to manage user access to:

- Microsoft 365 (for productivity apps),

- GitHub Enterprise,

- Salesforce, and

- A custom-built HR Web App (hosted on Azure App Service).

However, Cousera’s leadership is concerned about unauthorized access and inconsistent user permissions.
You’ve been brought in as a Microsoft Entra ID Administrator to strengthen authentication and authorization controls — ensuring secure, seamless access for employees, contractors, and admins.

## 🧠 Project Objectives:
**1. Implement Secure Authentication in Microsoft Entra ID**
- Enforce Multi-Factor Authentication (MFA) for all users.
- Configure Conditional Access Policies for location-based sign-in.
- Enable Sign-in risk detection and User risk policies using Entra ID Identity Protection.

**2. Set Up Role-Based Authorization**

- Create custom Entra roles (e.g., App Manager, HR Admin, Developer).

- Assign least privilege access using built-in and custom roles.

- Use Administrative Units (AUs) to delegate permissions by department.

**3. Configure and Test Access to Enterprise Applications**

- Register a custom HR web application in Microsoft Entra ID.

- Assign app roles (e.g., HR.User, HR.Admin) to users and groups.

- Test OAuth 2.0 / OpenID Connect authentication flow (using Postman or app registration portal).

- Integrate another app (e.g., Salesforce or GitHub Enterprise Cloud) via SAML or OIDC SSO.

**3. Set Up Privileged Identity Management (PIM)**

- Enable PIM for directory roles.

- Configure “Just-in-Time” (JIT) activation for Global Administrator and Application Administrator roles.

- Require MFA for PIM activation and add justification notes.

**4. Audit and Monitor Authentication Events**

- Review sign-in logs and audit logs in Microsoft Entra ID.

- Generate a security report showing successful MFA challenges, blocked sign-ins, and risk detections.

- Export the report and visualize it in Excel or Power BI.
   

## 🧱 Phase 1: Implement Secure Authentication (MFA & Conditional Access)
### Step 1️⃣ – Create Test Users and Groups

**1.** Go to Microsoft Entra Admin Center → Users → New User → Create new users

  - alice@cousera894.onmicrosoft.com (HR Manager)

  - bob@cousera894.onmicrosoft.com (Developer)

  - carol@cousera894.onmicrosoft.com (Finance)

**2.** Assign each a temporary password.  
**3.** Create a dynamic group called "Cousera All Employees" and add all Internal and B2B users.

📸 **Screenshots:** 

<div>
<img width="300" height="400" alt="Screenshot 2025-10-23 131538" src="https://github.com/user-attachments/assets/b78c491c-08ca-4cb7-8a9d-44bbebcf0085" />
<img width="300" height="400" alt="Screenshot 2025-10-23 132156" src="https://github.com/user-attachments/assets/d5905b48-aa9d-4eab-aac1-2fe4bd4a188c" />
<img width="300" height="400" alt="Screenshot 2025-10-23 131813" src="https://github.com/user-attachments/assets/a0233b88-789b-4afd-9618-1c5db1be0ab8" />  

   
</div>  
<div style="display: flex; justify-content: top;">
<img width="300" height="400" alt="Screenshot 2025-10-24 171204" src="https://github.com/user-attachments/assets/ac1068f5-953e-4d24-94ee-5d8eeb95822f" />
<img width="600" height="700" alt="Screenshot 2025-10-24 171132" src="https://github.com/user-attachments/assets/b76dd041-270e-4944-b595-66665e13a05b" />
</div>


### Step 2️⃣ – Enforce Multi-Factor Authentication (MFA)

1. Navigate to Microsoft Entra ID → Protection → Authentication methods → Policies.

2. Enable Microsoft Authenticator and Email OTP as methods.

3. Then go to Users → Per-user MFA → enable MFA for All Employees.

4. Test: Have one user (e.g., Alice) log in to https://portal.office.com
 — they should be prompted for MFA setup.

📸 **Screenshots:**
<div>
<img width="900" height="422" alt="Screenshot 2025-10-26 152039" src="https://github.com/user-attachments/assets/7b2fe219-3706-4453-bd22-4cffdb6b2c5d" />
<img width="900" height="452" alt="Screenshot 2025-10-26 154921" src="https://github.com/user-attachments/assets/f518405b-3f6f-47b9-9d28-20a1d87859ec" />
<img width="900" height="743" alt="Screenshot 2025-10-26 152224" src="https://github.com/user-attachments/assets/a9432f97-e332-439f-b544-5c1382f32324" />
<img width="600" height="632" alt="Screenshot 2025-10-26 152731" src="https://github.com/user-attachments/assets/aca86d9c-d47a-499d-9d7b-fc968eb215b3" />
<img width="300" height="539" alt="Screenshot 2025-10-26 155136" src="https://github.com/user-attachments/assets/c3121c93-b349-4d1a-85cb-de11272b041d" />
<img width="300" height="430" alt="Screenshot 2025-10-26 155158" src="https://github.com/user-attachments/assets/6fe8970f-ae4d-4c24-b8fe-94b0f5628e40" />
<img width="300" height="481" alt="Screenshot 2025-10-26 155210" src="https://github.com/user-attachments/assets/e6709b35-a493-4442-be49-e63cb29fa5f4" />
<img width="300" height="686" alt="Screenshot 2025-10-26 155240" src="https://github.com/user-attachments/assets/bb548721-befa-4248-b0e5-677479f6d0d1" />
<img width="300" height="653" alt="Screenshot 2025-10-26 155253" src="https://github.com/user-attachments/assets/d36d652f-f453-4f49-af11-1b3f49778f49" />
<img width="300" height="879" alt="Screenshot 2025-10-26 155318" src="https://github.com/user-attachments/assets/47a404e1-c35e-428c-8e21-15a229018047" />
<img width="300" height="677" alt="Screenshot 2025-10-26 160828" src="https://github.com/user-attachments/assets/47ab7492-6d12-4dae-80c0-12490d6e39af" />
<img width="300" height="679" alt="Screenshot 2025-10-26 155416" src="https://github.com/user-attachments/assets/87795dcf-c8b6-4fb2-b738-00929eb95090" />
<img width="300" height="552" alt="Screenshot 2025-10-26 155442" src="https://github.com/user-attachments/assets/88d29ef9-91cb-40b6-9e07-7f708e5633b0" />
<img width="300" height="541" alt="Screenshot 2025-10-26 155906" src="https://github.com/user-attachments/assets/f2432e08-9f60-492b-9dcb-e68b7d0b3756" />
<img width="300" height="617" alt="Screenshot 2025-10-26 155951" src="https://github.com/user-attachments/assets/e6649016-2a1c-4ba6-970a-4d196a9b19fb" />
<img width="300" height="553" alt="Screenshot 2025-10-26 160101" src="https://github.com/user-attachments/assets/675fb1fb-a44c-41e1-aac9-af4d1cc7a98c" />
<img width="300" height="915" alt="Screenshot 2025-10-26 160401" src="https://github.com/user-attachments/assets/a7224132-df76-4594-8a86-7495b99f5972" />
</div>

### Step 3️⃣ – Configure Conditional Access

**1.** Go to Microsoft Entra ID → Protection → Conditional Access → New Policy.

**2.** Name: Block access from non-compliant locations.

**3.** Assign:

- Users: All Employees,

- Cloud apps: All cloud apps,

**3.** Conditions:

- Locations → Exclude trusted locations (e.g., your office IP)

- Grant → Block access

**4.** Enable the policy.

**5.** 🧪 Test: Try logging in from a different network or use a VPN — access should be blocked.

📸 Screenshot of Conditional Access policy summary.
