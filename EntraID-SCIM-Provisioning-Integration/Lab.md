### Entra ID SCIM Provisioning Integration Project

This project is designed to showcase my skills in enterprise app management and automated user provisioning using Microsoft Entra ID. It focuses on integrating a SaaS application with SCIM (System for Cross-domain Identity Management) to handle user lifecycle automation, which aligns with real-world IAM tasks like onboarding, updates, and offboarding. I'll be using Slack as the target app since it supports SCIM natively and integrates seamlessly with Entra ID—making it accessible for testing without complex setups.

#### Prerequisites
- Microsoft Entra ID admin access (P1 or higher license for provisioning features).
- A Slack workspace where you're an admin (Business+ plan works).
- Microsoft Graph PowerShell SDK installed (`Install-Module Microsoft.Graph`).

#### Step-by-Step Implementation

##### 1. **Integrate the App with SCIM Provisioning**
   - In the Entra ID portal (entra.microsoft.com), navigate to "Enterprise applications" > "New application" > Search for "Slack" in the gallery > Create, and enable SSO.
   - In the Slack admin dashboard (admin.slack.com), go to "Settings & administration" > "Workspace settings" > "Authentication" > "Configure" for SSO.
   - Configure automatic user account provisioning to Slack in Azure
   - In the app's properties, go to "Provisioning" > Set mode to "Automatic" > Test connection (it should succeed).

📸 Screenshots of configurations on Enterprise apps, Slack SSO, and Provisioning:

<div>
   <img width="310" height="310" alt="Screenshot 2025-12-24 153239" src="https://github.com/user-attachments/assets/83d99e56-9fdc-4a58-a383-6668cee8335c" />
   <img width="310" height="748" alt="Screenshot 2025-12-24 154122" src="https://github.com/user-attachments/assets/3318a765-0ab3-4cb6-b71e-b6a40952c5e2" />
   <img width="310" height="793" alt="Screenshot 2025-12-24 135159" src="https://github.com/user-attachments/assets/36ba6dc4-af29-47b1-b7d3-817403fdfaab" />
   <img width="310" height="939" alt="Screenshot 2025-12-24 162918" src="https://github.com/user-attachments/assets/652ab12d-9650-4cfd-b1dc-80bfef405c7c" />
   <img width="310" height="816" alt="Screenshot 2025-12-24 160934" src="https://github.com/user-attachments/assets/8e4b3754-e00d-4e30-8ac9-bf32d633538d" />
   <img width="310" height="747" alt="Screenshot 2025-12-24 160723" src="https://github.com/user-attachments/assets/d33be907-e962-4df0-97a0-08247e66047a" />
</div>

##### 2. **Map User Attributes**
   - Still in the Provisioning section, expand "Mappings" > Edit "Provision Microsoft Entra ID Users."
   - Map key attributes to ensure user data syncs correctly:
     - `userName` (Entra ID) → `userName` (Slack) – Use `userPrincipalName` or `mail`.
     - `displayName` (Entra ID) → `displayName` (Slack) – Use `displayName`.
     - `givenName` (Entra ID) → `name.givenName` (Slack) – Use `givenName`.
     - `surname` (Entra ID) → `name.familyName` (Slack) – Use `surname`.
     - Add custom mappings if needed, e.g., `jobTitle` or `department`.
   - Enable "Create," "Update," and "Delete" actions under Settings.
   - Save and restart provisioning to apply changes.

📸 Screenshots of configurations on Provisioning and Mapping User Attributes:

<div>
   <img width="465" height="850" alt="Screenshot 2025-12-24 164036" src="https://github.com/user-attachments/assets/ebe94833-32e4-416f-8f5c-8d55292d2f40" />
   <img width="465" height="873" alt="Screenshot 2025-12-24 165442" src="https://github.com/user-attachments/assets/28e6a8cc-b19a-450f-b15e-536d55210441" />
</div>

##### 3. **Test Automatic Provisioning and Deprovisioning**
   - **Provisioning Test**:
     - Create a test user in Entra ID (manually or via PowerShell script below).
     - And assign a license to the user in Microsoft 365 for the SCIM to work properly.
     - Assign the test user to Slack in Entra ID
     - Wait for the provisioning cycle (default 40 minutes) or force a sync via "Provision on demand."
     - Verify in Slack: The user should appear with correct attributes; check the "Members" list.
   - **Deprovisioning Test**:
     - Disable or delete the test user in Entra ID.
     - Trigger sync and confirm the user is deactivated or removed in Slack.
   - Use PowerShell for testing (save as `Test-Provisioning.ps1` in your repo):
     ```powershell
     # Connect to Microsoft Graph
     Connect-MgGraph -Scopes "User.ReadWrite.All", "Directory.ReadWrite.All"

     # Create a test user
     $userParams = @{
         AccountEnabled = $true
         DisplayName = "Test User"
         MailNickname = "testuser"
         UserPrincipalName = "testuser@yourdomain.com"
         PasswordProfile = @{ Password = "TempPass123!" ; ForceChangePasswordNextSignIn = $true }
     }
     New-MgUser -BodyParameter $userParams
     ```
     Run this script to simulate real workflows, then check Slack for changes.

📸 Screenshot of configurations on user creation, user assignment to Slack, user licensing, and user deletion:

<div>
   <img width="310" height="310" alt="Screenshot 2025-12-24 172522" src="https://github.com/user-attachments/assets/d73e3762-c688-4845-acbc-a24d52a8de7e" />
   <img width="310" height="864" alt="Screenshot 2025-12-25 174107" src="https://github.com/user-attachments/assets/ed340b5a-dd65-4ca1-854c-a51073fe7215" />
   <img width="310" height="343" alt="Screenshot 2025-12-25 174616" src="https://github.com/user-attachments/assets/366411d8-87c0-4c4e-a851-807de1d55ba2" />
   <img width="310" height="817" alt="Screenshot 2025-12-25 174945" src="https://github.com/user-attachments/assets/dc964864-6bc9-4211-951d-33867574b6ed" />
   <img width="620" height="784" alt="Screenshot 2025-12-25 172805" src="https://github.com/user-attachments/assets/38a0bf07-101a-4761-a786-6b0dd09c22ee" />
   <img width="620" height="830" alt="Screenshot 2025-12-25 181552" src="https://github.com/user-attachments/assets/c07240fc-f8e7-4f16-b728-0afa6e2e69cf" />
   <img width="310" height="473" alt="Screenshot 2025-12-25 181706" src="https://github.com/user-attachments/assets/1bf53707-2001-4e68-8846-a655ccf50e99" />
</div>
     

##### 4. **Monitor Provisioning Logs**
   - In Entra ID, go to the app's "Provisioning" > "Provisioning logs."
   - Filter by date, status (success/error), or user.
   - Export logs as CSV for analysis

📸 Screenshot of the provisioning logs

<div>
   <img width="620" height="482" alt="Screenshot 2025-12-26 163628" src="https://github.com/user-attachments/assets/2a92e6b1-de55-4880-83d2-aad3803cc5fb" />
   <img width="310" height="729" alt="Screenshot 2025-12-26 164253" src="https://github.com/user-attachments/assets/98efa37d-12c7-4c47-956e-c2d1a0cd6303" />
</div>

