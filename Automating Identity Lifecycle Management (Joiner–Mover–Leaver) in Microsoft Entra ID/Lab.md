# Project: Automating Identity Lifecycle Management (Joiner–Mover–Leaver) in Microsoft Entra ID (Cloud-Only)

---

## Project Overview
Automate **Joiner**, **Mover**, and **Leaver** processes using **Microsoft Entra ID Lifecycle Workflows** and **PowerShell** to simulate HR events.

| Goal | Method |
|------|--------|
| **Joiner** | Trigger on `employeeHireDate` → add to group and add a license |
| **Mover** | Trigger on `department` change → update group |
| **Leaver** | Trigger on `employeeLeaveDateTime` → disable account |

**No HR system required** (Workday or SuccessFactors) — all attributes set via **PowerShell**.

---

## Prerequisites (Free / Trial)
| Item | How to Get |
|------|-----------|
| **Entra ID P1/P2** | Visit [P1/P2 pricing](https://www.microsoft.com/en-us/security/business/microsoft-entra-pricing) (free 30-days) |
| **Entra ID Governance** | Visit [ID Governance Pricing](https://www.microsoft.com/en-us/security/business/microsoft-entra-pricing#x9679557068c545e7828fd44ad150736e) (free 30-days) |
| **Microsoft.Graph module** | `Install-Module Microsoft.Graph` |

---

## Step  1️⃣: Set Up Test Environment

### 1.1 Create 11 Test Users & Groups
Save these files in `C:\JML-Practice\`

#### `bulk-create-users.csv`
```csv
userPrincipalName,displayName,givenName,surname,mailNickname,password,department,employeeHireDate,employeeLeaveDateTime
hr.manager@Cousera669.onmicrosoft.com,HR Manager,Harry,Manager,hr.manager,TempPass123!,HR,,,
alice.joiner@Cousera669.onmicrosoft.com,Alice Joiner,Alice,Joiner,alice.joiner,TempPass123!,DevOps,2025-11-20,
bob.mover@Cousera669.onmicrosoft.com,Bob Mover,Bob,Mover,bob.mover,TempPass123!,Marketing,,
charlie.leaver@Cousera669.onmicrosoft.com,Charlie Leaver,Charlie,Leaver,charlie.leaver,TempPass123!,Finance,,2026-11-04T17:00:00Z
diana.joiner@Cousera669.onmicrosoft.com,Diana Joiner,Diana,Joiner,diana.joiner,TempPass123!,Engineering,2025-11-26,
eve.mover@Cousera669.onmicrosoft.com,Eve Mover,Eve,Mover,eve.mover,TempPass123!,HR,,,
frank.leaver@Cousera669.onmicrosoft.com,Frank Leaver,Frank,Leaver,frank.leaver,TempPass123!,Sales,,2026-11-05T12:00:00Z
grace.joiner@Cousera669.onmicrosoft.com,Grace Joiner,Grace,Joiner,grace.joiner,TempPass123!,Support,2025-11-29,
hank.mover@Cousera669.onmicrosoft.com,Hank Mover,Hank,Mover,hank.mover,TempPass123!,IT,,,
ivy.leaver@Cousera669.onmicrosoft.com,Ivy Leaver,Ivy,Leaver,ivy.leaver,TempPass123!,Legal,,2026-11-06T09:00:00Z
jack.joiner@Cousera669.onmicrosoft.com,Jack Joiner,Jack,Joiner,jack.joiner,TempPass123!,Product,2025-11-21,
```

> Replace `Cousera669.onmicrosoft.com` with your actual tenant.

---

### 1.2 Run Setup Script

#### `JML-Setup.ps1`
```powershell
# Install module
Install-Module Microsoft.Graph -Scope CurrentUser -Force

# Connect with correct scopes
Connect-MgGraph -Scopes "User.ReadWrite.All","User-LifeCycleInfo.ReadWrite.All","Group.ReadWrite.All"

# Create groups
$groups = "DevOps-Team","Sales-Team","HR-Team","Finance-Team","Engineering-Team","Support-Team","IT-Team","Legal-Team","Product-Team","Marketing-Team"
foreach ($g in $groups) {
    if (-not (Get-MgGroup -Filter "displayName eq '$g'" -ErrorAction SilentlyContinue)) {
        New-MgGroup -DisplayName $g -MailEnabled:$false -SecurityEnabled:$true -MailNickname ($g -replace ' ','')
        Write-Host "Group created: $g" -ForegroundColor Green
    }
}

# Create users
$csvPath = "C:\JML-Practice\bulk-create-users.csv"
$users   = Import-Csv $csvPath
foreach ($u in $users) {
    if (Get-MgUser -UserId $u.userPrincipalName -ErrorAction SilentlyContinue) {
        Write-Host "Skip: $($u.userPrincipalName)" -ForegroundColor Cyan
        continue
    }

    $pass = @{
        password = $u.password
        forceChangePasswordNextSignIn = $true
    }

    # JOINER = has employeeHireDate → DISABLED(Joiners account will be disabled)
    $accountEnabled = [string]::IsNullOrWhiteSpace($u.employeeHireDate)

    $newUserParams = @{
        UserPrincipalName = $u.userPrincipalName
        DisplayName       = $u.displayName
        GivenName         = $u.givenName
        Surname           = $u.surname
        MailNickname      = $u.mailNickname
        UsageLocation     = "NG"
        PasswordProfile   = $pass
        AccountEnabled    = $accountEnabled
    }

    try {
        New-MgUser @newUserParams -ErrorAction Stop
        $status = if ($accountEnabled) { "ENABLED" } else { "DISABLED" }
        Write-Host "Created [$status]: $($u.userPrincipalName)" -ForegroundColor $(if ($accountEnabled) { "Green" } else { "Red" })
    }
    catch {
        Write-Warning "Failed: $($u.userPrincipalName) - $($_.Exception.Message)"
    }
}

# Set JML attributes
foreach ($u in $users) {
    $body = @{}
    if ($u.employeeHireDate)      { $body.employeeHireDate      = $u.employeeHireDate }
    if ($u.department)            { $body.department            = $u.department }
    if ($u.employeeLeaveDateTime) { $body.employeeLeaveDateTime = $u.employeeLeaveDateTime }

    if ($body.Count -gt 0) {
        Update-MgUser -UserId $u.userPrincipalName -BodyParameter $body
        Write-Host "JML set: $($u.userPrincipalName)" -ForegroundColor Magenta
    }
}
Write-Host "`nSetup Complete! Users + Groups + JML Attributes Set." -ForegroundColor Yellow
```

**Run:**
```powershell
cd C:\JML-Practice
.\JML-Setup.ps1
```
### 1.3 Alternatively, Run the Setup Script Step by Step after Installing Microsoft Graph
1. Connect with the correct scopes
     ```pwsh
     # Connect with correct scopes
    Connect-MgGraph -Scopes "User.ReadWrite.All","User-LifeCycleInfo.ReadWrite.All","Group.ReadWrite.All"
     ```
      📸 **Screenshots of Permissions requested and the expected output:**  

   <div>
            <img width="300" height="791" alt="Screenshot 2025-11-11 150023" src="https://github.com/user-attachments/assets/adfa5dc5-17a6-441a-94dd-70ef838cb3d6" />
            <img width="600" height="264" alt="Screenshot 2025-11-11 161243" src="https://github.com/user-attachments/assets/4115f7d1-6343-4a00-8648-6aa4f07f991e" />
     </div>  
  
3. Create multiple groups
      ```pwsh
    # Create groups
    $groups = "DevOps-Team","Sales-Team","HR-Team","Finance-Team","Engineering-Team","Support-Team","IT-Team","Legal-Team","Product-Team","Marketing-Team"
    foreach ($g in $groups) {
        if (-not (Get-MgGroup -Filter "displayName eq '$g'" -ErrorAction SilentlyContinue)) {
            New-MgGroup -DisplayName $g -MailEnabled:$false -SecurityEnabled:$true -MailNickname ($g -replace ' ','')
            Write-Host "Group created: $g" -ForegroundColor Green
        }
    }
     ```
      📸 **Screenshots of groups created in PowerShell and Entra Portal:**
       <div>
           <img width="450" height="579" alt="Screenshot 2025-11-17 183530" src="https://github.com/user-attachments/assets/27b24bb0-a4ed-4e15-8965-c9ce11e33d38" />
            <img width="450" height="748" alt="Screenshot 2025-11-17 183952" src="https://github.com/user-attachments/assets/110c0c2b-5c3d-4eb1-8217-9cd8b796a1b5" />
       </div>
       
4. Create bulk users and disable joiners' accounts, e.g `alice.joiner@Cousera669.onmicrosoft.com`
   ```pwsh
   # JOINER = has employeeHireDate → DISABLED(Joiners account will be disabled)
   foreach ($u in $users) {
      if (Get-MgUser -UserId $u.userPrincipalName -ErrorAction SilentlyContinue) {
        Write-Host "Skip: $($u.userPrincipalName)" -ForegroundColor Cyan
        continue
    }

    $pass = @{
        password = $u.password
        forceChangePasswordNextSignIn = $true
    }

    # JOINER = has employeeHireDate → DISABLED
    $accountEnabled = [string]::IsNullOrWhiteSpace($u.employeeHireDate)

    $newUserParams = @{
        UserPrincipalName = $u.userPrincipalName
        DisplayName       = $u.displayName
        GivenName         = $u.givenName
        Surname           = $u.surname
        MailNickname      = $u.mailNickname
        UsageLocation     = "NG"
        PasswordProfile   = $pass
        AccountEnabled    = $accountEnabled
    }

    try {
        New-MgUser @newUserParams -ErrorAction Stop
        $status = if ($accountEnabled) { "ENABLED" } else { "DISABLED" }
        Write-Host "Created [$status]: $($u.userPrincipalName)" -ForegroundColor $(if ($accountEnabled) { "Green" } else { "Red" })
    }
    catch {
        Write-Warning "Failed: $($u.userPrincipalName) - $($_.Exception.Message)"
       }
   }  
   ```
   📸 **Screenshots of users created in PowerShell and Entra Portal, and account disabled for joiners and enabled for other users:**
    
      <div>
        <img width="450" height="967" alt="Screenshot 2025-11-18 175341" src="https://github.com/user-attachments/assets/b520c576-46dc-474e-bca5-739f892590c8" />
        <img width="450" height="889" alt="Screenshot 2025-11-18 175437" src="https://github.com/user-attachments/assets/7c72daf7-15f7-4d6f-b3a3-c8c3583515b8" />
        <img width="450" height="739" alt="Screenshot 2025-11-18 175631" src="https://github.com/user-attachments/assets/64c293de-4137-4faa-b8fb-d7eea20c0ca4" />
        <img width="450" height="740" alt="Screenshot 2025-11-18 175700" src="https://github.com/user-attachments/assets/1c6e3baf-f945-43a3-9ea9-7e0efaf9b5b3" />
      </div>
       
5. Set JML attributes for the users
     ```pwsh
     # Set JML attributes for the users
    foreach ($u in $users) {
    $body = @{}
    if ($u.employeeHireDate)      { $body.employeeHireDate      = $u.employeeHireDate }
    if ($u.department)            { $body.department            = $u.department }
    if ($u.employeeLeaveDateTime) { $body.employeeLeaveDateTime = $u.employeeLeaveDateTime }

    if ($body.Count -gt 0) {
        Update-MgUser -UserId $u.userPrincipalName -BodyParameter $body
        Write-Host "JML set: $($u.userPrincipalName)" -ForegroundColor Magenta
      }
    }
    ```
    📸 **Screenshot of JML attributes output for the users:**

    <div>
        <img width="450" height="488" alt="Screenshot 2025-11-18 180355" src="https://github.com/user-attachments/assets/60307571-ce02-46fa-8711-6ed8b7c2a0fe" />
        <img width="450" height="878" alt="Screenshot 2025-11-18 100843" src="https://github.com/user-attachments/assets/09d362cc-585f-47dd-892d-0add5df71877" />
        <img width="450" height="859" alt="Screenshot 2025-11-18 100915" src="https://github.com/user-attachments/assets/2f30c74d-c551-4592-a4a5-5a7ca12eebe7" />
        <img width="450" height="161" alt="Screenshot 2025-11-18 101453" src="https://github.com/user-attachments/assets/8a2a2e87-af7a-4822-b67d-59565ee88fb8" />
    </div>
6. Assign joiners a Manager so that the onboard workflow can generate TAP and send the Manager an email, e.g `hr.manager@Cousera669.onmicrosoft.com`
   <div>
       <img width="450" height="848" alt="Screenshot 2025-11-18 180928" src="https://github.com/user-attachments/assets/d2c02f33-ee03-405d-a80f-d0a382263a68" />
       <img width="450" height="807" alt="Screenshot 2025-11-18 181729" src="https://github.com/user-attachments/assets/2d2a10c8-4532-4b3c-8335-379b5bbef1f4" />
   </div>
---

## Step 2: Create Lifecycle Workflows (Entra Portal)

Go to: **https://entra.microsoft.com** → **Identity Governance** → **Lifecycle workflows**

---


### Workflow 1: **Joiner** – Onboard New Hire

| Field | Value |
|------|-------|
| **Template** | `Onboard pre-hire employee` |
| **Name** | `JML - Joiner (Auto-Onboard)` |
| **Trigger** |`Time based attribute`, `Scheduled`, `1 day`, `employeeHireDate` |
| **Condition** | `employeeHireDate is not null` |
| **Configure Scope** | `accountEnabled equal false` |
| **Tasks** |  
| → Enable user account | Enable user account in the directory |
| → Generate TAP | 1 hour and send to user and manager |
| → Send welcome email | To user |
| → Add user to group | `All Employee Group` |
| → Assign licenses to user | `Microsoft Entra ID P1` |



**Test:** Wait for the scheduled time or Run on demand → Select **Alice Joiner**

📸 **Screenshot of the Workflow summary, the users in scope, and processed users:**

  <div>
      <img width="450" height="892" alt="Screenshot 2025-11-20 111907" src="https://github.com/user-attachments/assets/b468360e-a82e-4f78-a6da-7341623fe054" />
      <img width="450" height="578" alt="Screenshot 2025-11-20 113217" src="https://github.com/user-attachments/assets/0a93b4ad-5362-47e9-adc4-8e6b35e5629a" />
      <img width="450" height="596" alt="Screenshot 2025-11-20 154249" src="https://github.com/user-attachments/assets/b5291c03-5d65-4afd-90a9-b254d2c8acb2" />
      <img width="450" height="625" alt="Screenshot 2025-11-20 154217" src="https://github.com/user-attachments/assets/65514c9e-583b-44f3-b919-083bb43c5b3a" />
  </div>

---

### Workflow 2: **Mover** – Department Change

| Field | Value |
|------|-------|
| **Template** | `Employee job profile change` |
| **Name** | `JML - Mover (Dept Change)` |
| **Trigger** | `On attribute change`, `department`, `Scheduled` |
| **Configure Scope** | `department equal Support` |
| **Tasks** |  
| → Remove user from s selected groups | `HR-Team` |
| → Add to selected groups | `Support-Team` |
| Send email to notify manager of user move→  | `HR Manager` |

**Test:**  
```powershell
Update-MgUser -UserId "eve.mover@Cousera669.onmicrosoft.com" -department "Support"
```
→ Wait for the scheduled time or **Run on demand**  

📸 **Screenshot of the Workflow summary, the user in scope, and processed user:**
<div>
   <img width="300" height="884" alt="Screenshot 2025-11-21 170500" src="https://github.com/user-attachments/assets/edd66d2c-eb97-479c-b265-852474b0cda8" />
     <img width="350" height="471" alt="Screenshot 2025-11-21 170251" src="https://github.com/user-attachments/assets/055b188e-27c6-41c3-a705-76a2d0440895" />
    <img width="350" height="562" alt="Screenshot 2025-11-21 172029" src="https://github.com/user-attachments/assets/d3024f26-f108-4e1c-9e00-f97e91ac3b8d" />
</div>

---

### Workflow 3: **Leaver** – Offboard Employee

| Field | Value |
|------|-------|
| **Template** | `Offboard an employee` |
| **Name** | `JML - Leaver (Auto-Offboard)` |
| **Trigger** | `Time based attribute`, `Scheduled`, `0 days`, `employeeLeaveDateTime` |
| **Condition** | `employeeLeaveDateTime is not null` |
| **Tasks** |  
| → Disable account | |
| → Remove from all groups | |
| → Remove all licenses | |
| → Send email | To HR |

**Test:**  
```powershell
Update-MgUser -UserId "charlie.leaver@Cousera669.onmicrosoft.com" -employeeLeaveDateTime "2025-11-04T17:00:00Z"
```
→ Wait for the scheduled time or **Run on demand**  
📸 **Screenshot of the Workflow summary, the user in scope, and processed user:**
<div>
    <img width="450" height="857" alt="Screenshot 2025-11-21 184623" src="https://github.com/user-attachments/assets/0b4a2796-b082-4552-aefc-e4ddbf978bcb" />
    <img width="450" height="270" alt="Screenshot 2025-11-21 192033" src="https://github.com/user-attachments/assets/bccba82f-2815-4be3-9e1d-cd5ae224cc19" />
</div>

---

## Step 3: Verify Everything Works

### 3.1 Check Attributes (PowerShell)
```powershell
Get-MgUser -UserId "charlie.leaver@yourtenant.onmicrosoft.com" -Property EmployeeLeaveDateTime | Select -Expand EmployeeLeaveDateTime
```

### 3.2 Check Workflow History
- **Entra admin center** → **Lifecycle workflows** → **Workflow history**
- Filter by user → See **Completed** status

### 3.3 Final State
| User | Group | Account |
|------|------|--------|
| Alice | `DevOps-Team` | Enabled |
| Bob | `Sales-Team` | Enabled |
| Charlie | No groups | **Disabled** |

---

## Cleanup (Optional)
```powershell
# Delete all test users
Get-MgUser -Filter "mailNickname startsWith 'alice' or mailNickname startsWith 'bob' or mailNickname startsWith 'charlie'" | Remove-MgUser -Confirm:$false
```

---

## Summary: What You’ve Built

| Feature | Tool |
|-------|------|
| Users & Groups | PowerShell |
| JML Attributes | `employeeHireDate`, `department`, `employeeLeaveDateTime` |
| Automation | Lifecycle Workflows |
| HR Simulation | PowerShell updates |
| Verification | Graph + Workflow History |

---
