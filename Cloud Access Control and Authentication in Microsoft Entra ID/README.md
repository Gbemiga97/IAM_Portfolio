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

📸 **Screenshot of the MFA enforcement policy and the user MFA registration prompt**
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

**📸 Screenshot of Conditional Access policy summary.**
<div>
   <img width="300" height="400" alt="Screenshot 2025-10-27 125137" src="https://github.com/user-attachments/assets/4470e13a-ddce-4c89-9411-48dbe470aa98" />
   <img width="300" height="508" alt="Screenshot 2025-10-27 125835" src="https://github.com/user-attachments/assets/f1318682-1291-4d78-a185-5d525a9c8bc4" />
<img width="300" height="553" alt="Screenshot 2025-10-27 125850" src="https://github.com/user-attachments/assets/b10ace23-f027-443a-a659-64f904adaaed" />
</div>



## 🧰 Phase 2: Configure Role-Based Authorization
### Step 4️⃣ – Assign Built-in Roles

**1.** Go to Entra ID → Roles & administrators.

**2.** Assign:

- Alice → User Administrator

- Bob →Cloud Application Administrator

- Carol → Billing Administrator

**📸 Screenshot of role assignments.**
<div>
   <img width="300" height="753" alt="Screenshot 2025-10-27 132838" src="https://github.com/user-attachments/assets/0ff2e2f1-625a-49cd-a19a-24e05e8810e0" />
  <img width="300" height="759" alt="Screenshot 2025-10-27 133313" src="https://github.com/user-attachments/assets/63cf774e-517d-4403-957b-fb702a579c21" />
<img width="300" height="761" alt="Screenshot 2025-10-27 133415" src="https://github.com/user-attachments/assets/ff4d1d4c-2d39-4692-9b77-3f75dea8c76d" />
</div>

### Step 5️⃣ – Create a Custom Role

**1.** Go to Roles & administrators → + New custom role.

- Name: `Cousera HR Manager`

- Permissions:

  - `microsoft.directory/users/standard/read`

  - `microsoft.directory/groups/standard/read`

**2.** Save and assign it to Alice.

**📸 Screenshot of the custom role definition and assignment**
<div>
<img width="600" height="501" alt="Screenshot 2025-10-27 141735" src="https://github.com/user-attachments/assets/dfccdd19-481e-457f-880d-33bd5378d746" />
<img width="300" height="756" alt="Screenshot 2025-10-27 141933" src="https://github.com/user-attachments/assets/26cbca00-9393-402a-9327-61c5f3687f8a" />
</div>

### Step 6️⃣ – Use Administrative Units (AUs)

**1.** Go to Administrative Units → + Add → name it `HR Department`.

**2.** Add user Alice as an Admin Unit Administrator.

**3.** Add Bob and Carol as Members only.

**📸 Screenshot of AU and assigned users.**
<div>
   <img width="300" height="406" alt="Screenshot 2025-10-27 142850" src="https://github.com/user-attachments/assets/d49bc749-c120-4a0c-b790-6abc66cf5cd7" />
<img width="300" height="797" alt="Screenshot 2025-10-27 143325" src="https://github.com/user-attachments/assets/a5927d59-1e1f-41f3-8429-b5d7931cdb44" />
<img width="300" height="747" alt="Screenshot 2025-10-27 143259" src="https://github.com/user-attachments/assets/0c780957-bead-4787-b76a-eabcc89c6199" />
 <img width="900" height="352" alt="Screenshot 2025-10-27 143429" src="https://github.com/user-attachments/assets/4119542c-ac8f-40b6-9b1b-ec874c1d6428" />
   <img width="900" height="460" alt="Screenshot 2025-10-27 143519" src="https://github.com/user-attachments/assets/1cdec8c4-6336-4812-b1a1-01af58feea53" />
</div>

## 🌐 Phase 3: App Registration & Access Control
### Step 7️⃣ – Register a Custom Web App (Simulated HR App)

**1.** Go to Entra ID → App registrations → New registration.

**2.** Name: `CouseraHRApp`

**3.** Redirect URI: `https://jwt.ms` (for testing).

**4.** Click Register.

**📸 Screenshot of the App registration overview.**
<div>
   <img width="300" height="600" alt="Screenshot 2025-10-28 122850" src="https://github.com/user-attachments/assets/4578021e-7cdf-400a-a782-d12940c97462" />
   <img width="600" height="300" alt="Screenshot 2025-10-28 122933" src="https://github.com/user-attachments/assets/4278c571-a39f-4548-9f48-71df8e4b0d0a" />
</div>

### Step 8️⃣ – Define App Roles

In the App → Manifest, add roles under "appRoles":
```bash
"appRoles": [
    {
        "allowedMemberTypes": ["User"],
        "description": "Can read employee data",
        "displayName": "HR User",
        "id": "d1a1cdd1-2345-6789-9876-1234567890aa",
        "isEnabled": true,
        "value": "HR.User"
    },
    {
        "allowedMemberTypes": ["User"],
        "description": "Can manage employee data",
        "displayName": "HR Admin",
        "id": "d1a1cdd1-2345-6789-9876-1234567890bb",
        "isEnabled": true,
        "value": "HR.Admin"
    }
]
```
**2.** Save the manifest.

**📸 Screenshot of app roles in manifest.**
<div>
   <img width="600" height="400" alt="Screenshot 2025-10-28 123855" src="https://github.com/user-attachments/assets/efbc4718-7eae-4281-b75d-e2c6fb1d236a" />
</div>

### Step 9️⃣ – Assign App Roles

**1.** Go to the app → Enterprise Applications → Users and groups → Add user.

**2.** Assign:

- Alice → HR.Admin

- Bob → HR.User

**📸 Screenshot of role assignments.**
<div>
  <img width="1844" height="476" alt="Screenshot 2025-10-28 124648" src="https://github.com/user-attachments/assets/c7aa7a0b-be8f-4df0-81aa-d46fba6b3c9c" />
</div>


### Step 🔟 – Test OAuth 2.0 Authentication

**1.** Go to App → Overview and copy Application (client) ID and Directory (tenant) ID.

**2.** Construct the Authorization URL:
- Build this URL in your browser 
``` 
https://login.microsoftonline.com/{tenant-id}/oauth2/v2.0/authorize?
client_id={your-client-id}
&response_type=id_token
&redirect_uri=https://jwt.ms
&response_mode=fragment
&scope=openid
&nonce=anyRandomStringHere123
&state=12345
```
- Replace `tenant-id` and `client_id` with your actual values.
  
**3.** Sign in with Alice, it will authenticate via Entra ID and return an ID token with app role claims.

📸 Screenshot of jwt.ms output showing role claim (e.g., "roles": ["HR.Admin"]).

<div>
   <img width="300" height="400" alt="Screenshot 2025-10-28 134845" src="https://github.com/user-attachments/assets/95907e27-bfc0-4a45-830d-de7e220ca255" />
   <img width="600" height="400" alt="Screenshot 2025-10-28 135531" src="https://github.com/user-attachments/assets/b0311293-56e3-4c1c-840e-97324353de1d" />
</div>
