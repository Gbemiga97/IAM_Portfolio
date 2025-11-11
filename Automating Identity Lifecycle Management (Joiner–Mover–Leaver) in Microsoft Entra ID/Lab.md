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

### 1.1 Create 10 Test Users & Groups
Save these files in `C:\JML-Practice\`

#### `bulk-create-users.csv`
```csv
userPrincipalName,displayName,givenName,surname,mailNickname,password,department,employeeHireDate,employeeLeaveDateTime
alice.joiner@Cousera669.onmicrosoft.com,Alice Joiner,Alice,Joiner,alice.joiner,TempPass123!,DevOps,2025-11-05,
bob.mover@Cousera669.onmicrosoft.com,Bob Mover,Bob,Mover,bob.mover,TempPass123!,Marketing,,
charlie.leaver@Cousera669.onmicrosoft.com,Charlie Leaver,Charlie,Leaver,charlie.leaver,TempPass123!,Finance,,2025-11-04T17:00:00Z
diana.joiner@Cousera669.onmicrosoft.com,Diana Joiner,Diana,Joiner,diana.joiner,TempPass123!,Engineering,2025-11-06,
eve.mover@Cousera669.onmicrosoft.com,Eve Mover,Eve,Mover,eve.mover,TempPass123!,HR,,,
frank.leaver@Cousera669.onmicrosoft.com,Frank Leaver,Frank,Leaver,frank.leaver,TempPass123!,Sales,,2025-11-05T12:00:00Z
grace.joiner@Cousera669.onmicrosoft.com,Grace Joiner,Grace,Joiner,grace.joiner,TempPass123!,Support,2025-11-07,
hank.mover@Cousera669.onmicrosoft.com,Hank Mover,Hank,Mover,hank.mover,TempPass123!,IT,,,
ivy.leaver@Cousera669.onmicrosoft.com,Ivy Leaver,Ivy,Leaver,ivy.leaver,TempPass123!,Legal,,2025-11-06T09:00:00Z
jack.joiner@Cousera669.onmicrosoft.com,Jack Joiner,Jack,Joiner,jack.joiner,TempPass123!,Product,2025-11-08,
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
$groups = "DevOps-Team","Sales-Team","HR-Team","Finance-Team","Engineering-Team","Support-Team","IT-Team","Legal-Team","Product-Team"
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
        Write-Host "Skipping: $($u.userPrincipalName)" -ForegroundColor Cyan
        continue
    }

    $pass = @{ password = $u.password; forceChangePasswordNextSignIn = $true}

   try {
        New-MgUser `
            -UserPrincipalName $u.userPrincipalName `
            -DisplayName       $u.displayName `
            -GivenName         $u.givenName `
            -Surname           $u.surname `
            -MailNickname      $u.mailNickname `
            -UsageLocation     "NG" `
            -PasswordProfile   $pass -AccountEnabled `
            -ErrorAction Stop 

        Write-Host "Created: $($u.userPrincipalName)" -ForegroundColor Green
    }
    catch {
        Write-Warning "Failed: $($u.userPrincipalName) - $($_.Exception.Message)"
    }
}

# Set JML attributes
foreach ($u in $users) {
    $body = @{}
    if ($u.employeeHireDate) { $body.employeeHireDate = $u.employeeHireDate }
    if ($u.department) { $body.department = $u.department }
    if ($u.employeeLeaveDateTime) { $body.employeeLeaveDateTime = $u.employeeLeaveDateTime }
    if ($body.Count -gt 0) { Update-MgUser -UserId $u.userPrincipalName -BodyParameter $body }
}
Write-Host "`nSetup Complete! Users + Groups + JML Attributes Set." -ForegroundColor Yellow
```

**Run:**
```powershell
cd C:\JML-Practice
.\JML-Setup.ps1
```
### 1.3 Alternatively, Run the Setup Script Step by Step after Installing Microsoft Graph
1.   ```pwsh
              # Connect with correct scopes
            Connect-MgGraph -Scopes "User.ReadWrite.All","User-LifeCycleInfo.ReadWrite.All","Group.ReadWrite.All"
     ```
      📸 **Screenshots of Permissions requested and the expected output:**  

       <div>
            <img width="300" height="791" alt="Screenshot 2025-11-11 150023" src="https://github.com/user-attachments/assets/adfa5dc5-17a6-441a-94dd-70ef838cb3d6" />
           <img width="600" height="264" alt="Screenshot 2025-11-11 161243" src="https://github.com/user-attachments/assets/4115f7d1-6343-4a00-8648-6aa4f07f991e" />
       </div>  
  
2.   ```pwsh
         # Create groups
            $groups = "DevOps-Team","Sales-Team","HR-Team","Finance-Team","Engineering-Team","Support-Team","IT-Team","Legal-Team","Product-Team"
            foreach ($g in $groups) {
                if (-not (Get-MgGroup -Filter "displayName eq '$g'" -ErrorAction SilentlyContinue)) {
                    New-MgGroup -DisplayName $g -MailEnabled:$false -SecurityEnabled:$true -MailNickname ($g -replace ' ','')
                    Write-Host "Group created: $g" -ForegroundColor Green
                }
            }
     ```
      📸 **Screenshots of groups created in PowerShell and Entra Portal:**
       <div>
            <img width="450" height="658" alt="Screenshot 2025-11-11 161742" src="https://github.com/user-attachments/assets/2146ec78-6635-4130-8f2c-917373e17902" />
            <img width="450" height="803" alt="Screenshot 2025-11-11 161807" src="https://github.com/user-attachments/assets/2e1ab024-95a8-4b29-8a42-9e24cadf659b" />
       </div>
3.   ```pwsh
             # Create users
                $csvPath = "C:\JML-Practice\bulk-create-users.csv"
                $users   = Import-Csv $csvPath
                foreach ($u in $users) {
                    if (Get-MgUser -UserId $u.userPrincipalName -ErrorAction SilentlyContinue) {
                        Write-Host "Skipping: $($u.userPrincipalName)" -ForegroundColor Cyan
                        continue
                    }
                
                    $pass = @{ password = $u.password; forceChangePasswordNextSignIn = $true}
                
                   try {
                        New-MgUser `
                            -UserPrincipalName $u.userPrincipalName `
                            -DisplayName       $u.displayName `
                            -GivenName         $u.givenName `
                            -Surname           $u.surname `
                            -MailNickname      $u.mailNickname `
                            -UsageLocation     "NG" `
                            -PasswordProfile   $pass -AccountEnabled `
                            -ErrorAction Stop 
                
                        Write-Host "Created: $($u.userPrincipalName)" -ForegroundColor Green
                    }
                    catch {
                        Write-Warning "Failed: $($u.userPrincipalName) - $($_.Exception.Message)"
                    }
                }
     ```
   📸 **Screenshots of users created in PowerShell and Entra Portal:**

   <div>
       <img width="450" height="934" alt="Screenshot 2025-11-11 162510" src="https://github.com/user-attachments/assets/89eed462-58e7-4870-accd-bc24169da603" />
       <img width="450" height="806" alt="Screenshot 2025-11-11 162627" src="https://github.com/user-attachments/assets/0f779f43-1f81-45ce-b7b3-c353b13d6945" />
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
| **Trigger** | `Scheduled`, `-1 day`, `employeeHireDate` |
| **Condition** | `employeeHireDate is not null` |
| **Tasks** |  
| → Add user to group | `DevOps-Team` (or dynamic via custom task) |
| → Send welcome email | To user |
| → Generate TAP | 1 hour |

**Test:** Run on demand → Select **Alice Joiner**

---

### Workflow 2: **Mover** – Department Change

| Field | Value |
|------|-------|
| **Template** | `Custom workflow` |
| **Name** | `JML - Mover (Dept Change)` |
| **Trigger** | `On attribute change`, `department`, `Last 1 day` |
| **Tasks** |  
| → Remove from group | `Marketing-Team` |
| → Add to group | `Sales-Team` |

**Test:**  
```powershell
Update-MgUser -UserId "bob.mover@yourtenant.onmicrosoft.com" -department "Sales"
```
→ Wait 5 mins or **Run on demand**

---

### Workflow 3: **Leaver** – Offboard Employee

| Field | Value |
|------|-------|
| **Template** | `Offboard leaver employee` |
| **Name** | `JML - Leaver (Auto-Offboard)` |
| **Trigger** | `Scheduled`, `0 days`, `employeeLeaveDateTime` |
| **Condition** | `employeeLeaveDateTime is not null` |
| **Tasks** |  
| → Disable account | |
| → Remove from all groups | |
| → Remove all licenses | |
| → Send email | To HR |

**Test:**  
```powershell
Update-MgUser -UserId "charlie.leaver@yourtenant.onmicrosoft.com" -employeeLeaveDateTime "2025-11-04T17:00:00Z"
```
→ **Run on demand**

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
