**CyberArk PAM LDAP Integration Lab**  
*A beginner-friendly hands-on guide to integrating Active Directory (LDAP) with CyberArk Privileged Access Manager (PAM) Self-Hosted for centralized user authentication and management.*

### Overview

This lab demonstrates how to configure **LDAP Integration** in CyberArk PAM, allowing users from an external directory (such as Active Directory) to authenticate to the PVWA and Vault. This enables seamless single sign-on experiences, group-based permissions, and automatic user provisioning while maintaining security best practices.

**Goal**: Successfully connect CyberArk to an LDAP domain, map administrative and user groups, enable LDAP authentication in PVWA, and test login with domain accounts.

### Tools & Environment Used

- **CyberArk PAM Self-Hosted 12.6** — Vault + PVWA
- **Windows Server (Domain Controller)** — Active Directory Domain Services (AD DS) with sample users and groups
- **PVWA Web Interface** — For LDAP configuration and testing
- **Remote Desktop (RDP)** — Server management
- **PowerShell** — For AD setup and user/group management

**Assumptions**:
- Vault and PVWA are already installed and operational.
- A functional Active Directory domain exists (e.g., `lab.local`).
- Network connectivity between CyberArk servers and the Domain Controller (ports 389/636 for LDAP/LDAPS).
- You have Domain Admin rights on the DC and Vault Administrator access.

### 1. Prepare the LDAP Environment (Active Directory)

Run the following PowerShell script on your **Domain Controller** as a **Domain Administrator** to create the required OUs, security groups, bind account, and test users.

```powershell
# =============================================
# CyberArk PAM Lab - Active Directory Setup Script
# Run as Domain Admin on the Domain Controller
# =============================================

Import-Module ActiveDirectory -ErrorAction Stop

# Define domain and base settings
$domainDN = "DC=lab,DC=local"
$password = ConvertTo-SecureString "Cyberark1!" -AsPlainText -Force

# 1. Create Organizational Units
$ous = @(
    "CyberArk_Users",
    "CyberArk_Admins",
    "CyberArk_ServiceAccounts"
)

foreach ($ou in $ous) {
    if (-not (Get-ADOrganizationalUnit -Filter "Name -eq '$ou'" -SearchBase $domainDN -ErrorAction SilentlyContinue)) {
        New-ADOrganizationalUnit -Name $ou -Path $domainDN -ProtectedFromAccidentalDeletion $false
        Write-Host "Created OU: $ou" -ForegroundColor Green
    } else {
        Write-Host "OU already exists: $ou" -ForegroundColor Yellow
    }
}

# 2. Create Security Groups
$groups = @(
    @{Name="CyberArk_Vault_Admins"; Path="OU=CyberArk_Admins,$domainDN"},
    @{Name="CyberArk_Users"; Path="OU=CyberArk_Users,$domainDN"}
)

foreach ($group in $groups) {
    if (-not (Get-ADGroup -Filter "Name -eq '$($group.Name)'" -ErrorAction SilentlyContinue)) {
        New-ADGroup -Name $group.Name `
                    -GroupScope Global `
                    -GroupCategory Security `
                    -Path $group.Path `
                    -Description "CyberArk PAM Group"
        Write-Host "Created Group: $($group.Name)" -ForegroundColor Green
    }
}

# 3. Create LDAP Bind Account (Read-only service account)
$bindUser = "cyberarkbind"
if (-not (Get-ADUser -Filter "SamAccountName -eq '$bindUser'" -ErrorAction SilentlyContinue)) {
    New-ADUser -Name "CyberArk Bind Account" `
               -SamAccountName $bindUser `
               -UserPrincipalName "$bindUser@lab.local" `
               -Path "OU=CyberArk_ServiceAccounts,$domainDN" `
               -AccountPassword $password `
               -Enabled $true `
               -PasswordNeverExpires $true `
               -Description "CyberArk LDAP Bind Account (Read-Only)"
    Write-Host "Created Bind Account: $bindUser" -ForegroundColor Green
}

# 4. Create Test Users
$testUsers = @(
    @{Name="ca_admin01"; GivenName="CyberArk"; Surname="Admin01"; Group="CyberArk_Vault_Admins"},
    @{Name="ca_user01"; GivenName="CyberArk"; Surname="User01"; Group="CyberArk_Users"},
    @{Name="ca_user02"; GivenName="CyberArk"; Surname="User02"; Group="CyberArk_Users"}
)

foreach ($user in $testUsers) {
    if (-not (Get-ADUser -Filter "SamAccountName -eq '$($user.Name)'" -ErrorAction SilentlyContinue)) {
        New-ADUser -Name "$($user.GivenName) $($user.Surname)" `
                   -SamAccountName $user.Name `
                   -UserPrincipalName "$($user.Name)@lab.local" `
                   -GivenName $user.GivenName `
                   -Surname $user.Surname `
                   -Path "OU=CyberArk_Users,$domainDN" `
                   -AccountPassword $password `
                   -Enabled $true `
                   -PasswordNeverExpires $true `
                   -Description "CyberArk Test User"
        
        Add-ADGroupMember -Identity $user.Group -Members $user.Name
        Write-Host "Created User: $($user.Name) and added to $($user.Group)" -ForegroundColor Green
    }
}

Write-Host "`n=== Active Directory Setup Completed Successfully! ===" -ForegroundColor Cyan
Write-Host "Bind User: cyberarkbind@lab.local | Password: Cyberark1!" -ForegroundColor Yellow
```

**How to Run**:
1. Copy the script into a new file (e.g., `Setup-CyberArkAD.ps1`).
2. Right-click PowerShell → **Run as Administrator**.
3. Execute the script.

*Screenshot: PowerShell output showing created OUs, groups, and users.*

### 2. Configured LDAP Integration in PVWA

1. Log into the **PVWA** as the built-in Vault Administrator.
2. Navigate to **User Provisioning > LDAP Integration**.
3. Click **New Domain**.
4. Fill in the **Define Domain** section:
   - Domain Name: `lab.local`
   - Use Secure Connection (LDAPS recommended).
   - Bind User: `cyberarkbind@lab.local`
   - Bind Password: `Cyberark1!`
   - Base Context: `dc=lab,dc=local`

*Screenshot: New Domain wizard - Define Domain screen.*

### 3. Connect Domain Controllers and Map Directories

- Select available Domain Controllers and click **Connect**.
- Create Directory Mappings:
  - Map `CyberArk_Vault_Admins` → **Vault Admins** role.
  - Map `CyberArk_Users` → Standard user permissions.
- Complete the wizard.

*Screenshot: Domain Controllers selection and group mapping interface.*

### 4. Enable LDAP Authentication

- Go to **Administration > Options** → **Authentication Methods**.
- Enable **ldap** and set it as needed.
- Apply changes.

### 5. Verification

- Log out and log in using domain accounts (`ca_admin01@lab.local` or `ca_user01@lab.local`).
- Confirm correct permissions based on group membership.
- Check logs for any connection issues.

### Key Takeaways

- Use a dedicated read-only bind account for security.
- Group-based mapping enables scalable RBAC.
- Always prefer LDAPS in production.
- The provided PowerShell script makes lab recreation fast and repeatable.

**Next Steps**:
- Configure auto-provisioning rules.
- Add MFA (RADIUS).
- Test with CPM for password management.

*Happy learning and secure your environment!*
