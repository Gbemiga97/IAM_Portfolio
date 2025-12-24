### Entra ID SCIM Provisioning Integration Project

This project is designed to showcase my skills in enterprise app management and automated user provisioning using Microsoft Entra ID. It focuses on integrating a SaaS application with SCIM (System for Cross-domain Identity Management) to handle user lifecycle automation, which aligns with real-world IAM tasks like onboarding, updates, and offboarding. I'll be using Slack as the target app since it has a free tier, supports SCIM natively, and integrates seamlessly with Entra ID—making it accessible for testing without complex setups.

#### Prerequisites
- Microsoft Entra ID admin access (P1 or higher license for provisioning features).
- A Slack workspace where you're an admin (Business+ plan works).
- Microsoft Graph PowerShell SDK installed (`Install-Module Microsoft.Graph`).

#### Step-by-Step Implementation

1. **Integrate the App with SCIM Provisioning**
   - In the Entra ID portal (entra.microsoft.com), navigate to "Enterprise applications" > "New application" > Search for "Slack" in the gallery > Create, and enable SSO.
   - In the Slack admin dashboard (admin.slack.com), go to "Settings & administration" > "Workspace settings" > "Authentication" > "Configure" for SSO.
   - Configure automatic user account provisioning to Slack in Azure
   - In the app's properties, go to "Provisioning" > Set mode to "Automatic" > Test connection (it should succeed).

📸 Screenshot of configurations on Enterprise apps, Slack SSO, and Provisioning:

<div>
   <img width="310" height="310" alt="Screenshot 2025-12-24 153239" src="https://github.com/user-attachments/assets/83d99e56-9fdc-4a58-a383-6668cee8335c" />
   <img width="310" height="748" alt="Screenshot 2025-12-24 154122" src="https://github.com/user-attachments/assets/3318a765-0ab3-4cb6-b71e-b6a40952c5e2" />
   <img width="310" height="793" alt="Screenshot 2025-12-24 135159" src="https://github.com/user-attachments/assets/36ba6dc4-af29-47b1-b7d3-817403fdfaab" />
   <img width="310" height="939" alt="Screenshot 2025-12-24 162918" src="https://github.com/user-attachments/assets/652ab12d-9650-4cfd-b1dc-80bfef405c7c" />
   <img width="310" height="816" alt="Screenshot 2025-12-24 160934" src="https://github.com/user-attachments/assets/8e4b3754-e00d-4e30-8ac9-bf32d633538d" />
   <img width="310" height="747" alt="Screenshot 2025-12-24 160723" src="https://github.com/user-attachments/assets/d33be907-e962-4df0-97a0-08247e66047a" />
</div>

2. **Map User Attributes**
   - Still in the Provisioning section, expand "Mappings" > Edit "Provision Microsoft Entra ID Users."
   - Map key attributes to ensure user data syncs correctly:
     - `userName` (Entra ID) → `userName` (Slack) – Use `userPrincipalName` or `mail`.
     - `displayName` (Entra ID) → `displayName` (Slack) – Use `displayName`.
     - `givenName` (Entra ID) → `name.givenName` (Slack) – Use `givenName`.
     - `surname` (Entra ID) → `name.familyName` (Slack) – Use `surname`.
     - Add custom mappings if needed, e.g., `jobTitle` or `department`.
   - Enable "Create," "Update," and "Delete" actions under Settings.
   - Save and restart provisioning to apply changes.

📸 Screenshot of configurations on Provisioning and Mapping User Attributes:

<div>
   <img width="465" height="850" alt="Screenshot 2025-12-24 164036" src="https://github.com/user-attachments/assets/ebe94833-32e4-416f-8f5c-8d55292d2f40" />
   <img width="465" height="873" alt="Screenshot 2025-12-24 165442" src="https://github.com/user-attachments/assets/28e6a8cc-b19a-450f-b15e-536d55210441" />
</div>

3. **Test Automatic Provisioning and Deprovisioning**
   - Assign users or groups to the app in Entra ID (under "Users and groups").
   - **Provisioning Test**:
     - Create a test user in Entra ID (manually or via PowerShell script below).
     - Wait for the provisioning cycle (default 40 minutes) or force a sync via "Provision on demand."
     - Verify in Slack: The user should appear with correct attributes; check the "Members" list.
   - **Deprovisioning Test**:
     - Disable or delete the test user in Entra ID.
     - Trigger sync and confirm the user is deactivated or removed in Slack (e.g., profile archived).
   - Use PowerShell for bulk testing (save as `Test-Provisioning.ps1` in your repo):
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

     # Assign to app (replace with your app's object ID)
     $appId = "your-app-object-id"
     New-MgUserAppRoleAssignment -UserId (Get-MgUser -Filter "userPrincipalName eq 'testuser@yourdomain.com'").Id -AppRoleId "00000000-0000-0000-0000-000000000000" -PrincipalId (Get-MgUser -Filter "userPrincipalName eq 'testuser@yourdomain.com'").Id -ResourceId $appId

     # Later, disable the user for deprovisioning test
     Update-MgUser -UserId (Get-MgUser -Filter "userPrincipalName eq 'testuser@yourdomain.com'").Id -AccountEnabled $false
     ```
     Run this script to simulate real workflows, then check Slack for changes.

5. **Monitor Provisioning Logs**
   - In Entra ID, go to the app's "Provisioning" > "Provisioning logs."
   - Filter by date, status (success/error), or user.
   - Export logs as CSV for analysis (include samples in your repo).
   - For advanced monitoring, add a PowerShell script (`Monitor-Logs.ps1`):
     ```powershell
     Connect-MgGraph -Scopes "AuditLog.Read.All"

     # Query provisioning audit logs (last 7 days)
     Get-MgAuditLogDirectoryAudit -Filter "activityDisplayName eq 'Provisioning'" -All | Select-Object ActivityDateTime, ActivityDisplayName, TargetResources | Export-Csv -Path "provisioning-logs.csv" -NoTypeInformation
     ```
     This pulls logs via Graph API—review for errors like attribute mismatches and document fixes in your README.

#### Documentation in README.md
- **Introduction**: "This project demonstrates SCIM-based integration of Slack with Microsoft Entra ID for automated user provisioning, mapping, testing, and monitoring—key skills for IAM roles."
- **Challenges & Learnings**: Discuss common issues like token expiration or attribute conflicts, and how you resolved them.
- **Screenshots**: Embed images of successful connection tests, attribute mappings, log views, and before/after user states in Slack.
- **Extensions**: Suggest adding group provisioning or integrating with your previous onboarding scripts for full JML (Joiner-Mover-Leaver) automation.
