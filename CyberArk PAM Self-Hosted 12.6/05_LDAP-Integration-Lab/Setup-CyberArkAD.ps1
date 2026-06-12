# =============================================
# CyberArk PAM Lab - Active Directory Setup Script
# Run as Domain Admin on the Domain Controller
# =============================================

Import-Module ActiveDirectory -ErrorAction Stop

# Define domain and base settings
$domainDN = "DC=lab,DC=local"
$domainName = "lab.local"
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
               -UserPrincipalName "$bindUser@$domainName" `
               -Path "OU=CyberArk_ServiceAccounts,$domainDN" `
               -AccountPassword $password `
               -Enabled $true `
               -PasswordNeverExpires $true `
               -Description "CyberArk LDAP Bind Account (Read-Only)"
    Write-Host "Created Bind Account: $bindUser" -ForegroundColor Green
}

# 4. Create Dedicated Reconcile Service Account
$reconcileUser = "cyberark-reconcile"

if (-not (Get-ADUser -Filter "SamAccountName -eq '$reconcileUser'" -ErrorAction SilentlyContinue)) {
    New-ADUser -Name "CyberArk Reconcile Account" `
               -SamAccountName $reconcileUser `
               -UserPrincipalName "$reconcileUser@$domainName" `
               -Path "OU=CyberArk_ServiceAccounts,$domainDN" `
               -AccountPassword $password `
               -Enabled $true `
               -PasswordNeverExpires $true `
               -Description "CyberArk CPM Reconcile Account - Password Reset"
    Write-Host "✅ Created Reconcile Account: $reconcileUser@$domainName" -ForegroundColor Green
} else {
    Write-Host "Account already exists: $reconcileUser" -ForegroundColor Yellow
}

# Grant minimal reconciliation permissions on CyberArk_Users OU
$targetOU = "OU=CyberArk_Users,$domainDN"
$reconcileDN = "$reconcileUser@$domainName"

dsacls.exe "$targetOU" /G "$reconcileDN`:CA;Reset Password;user" /I:S
dsacls.exe "$targetOU" /G "$reconcileDN`:WD" /I:S
dsacls.exe "$targetOU" /G "$reconcileDN`:WPRP;pwdLastSet;user" /I:S
dsacls.exe "$targetOU" /G "$reconcileDN`:WPRP;lockoutTime;user" /I:S



# 5. Create Scan Account
$scanUser = "cyberark-scan"

if (-not (Get-ADUser -Filter "SamAccountName -eq '$scanUser'" -ErrorAction SilentlyContinue)) {
    New-ADUser -Name "CyberArk Scan Account" `
               -SamAccountName $scanUser `
               -UserPrincipalName "$scanUser@$domainName" `
               -Path "OU=CyberArk_ServiceAccounts,$domainDN" `
               -AccountPassword $password `
               -Enabled $true `
               -PasswordNeverExpires $true `
               -Description "CyberArk Accounts Discovery Scan Account"
    Write-Host "✅ Created Scan Account: $scanUser@$domainName" -ForegroundColor Green
}

# 6. Create Test Users
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
