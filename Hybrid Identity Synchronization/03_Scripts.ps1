
<#
.SYNOPSIS
    Bulk creates test users, security groups, and OU structure for my cloud.training hybrid identity lab.
    Personalized for my VMware Workstation environment (DC01).
    Run this AFTER the domain is promoted and AD DS role is installed.
    
.NOTES
    Author: Gbemiga
    Date: April 2026
    Domain: cloud.training
    Purpose: Quickly populate the lab with realistic users/groups for Entra Connect sync testing.
    Total: 12 users + 3 security groups
#>

Import-Module ActiveDirectory

# ====================== CONFIGURATION ======================
$DomainDN = "DC=cloud,DC=training"
$Password = ConvertTo-SecureString "P@ssw0rd2026!" -AsPlainText -Force

# Organizational Units (create if they don't exist)
$OUs = @(
    "OU=Admins,$DomainDN",
    "OU=Employees,$DomainDN",
    "OU=TopLevelUsers,$DomainDN"
)

foreach ($ou in $OUs) {
    if (-not (Get-ADOrganizationalUnit -Filter "distinguishedName -eq '$ou'" -ErrorAction SilentlyContinue)) {
        New-ADOrganizationalUnit -Name $ou.Split(',')[0].Replace("OU=","") -Path $DomainDN -ProtectedFromAccidentalDeletion $false
        Write-Host "Created OU: $ou" -ForegroundColor Green
    }
}

# ====================== SECURITY GROUPS ======================
$Groups = @(
    @{Name="Finance-Team"; Path="OU=TopLevelUsers,$DomainDN"; Category="Security"; Scope="Global"},
    @{Name="IT-Admins";    Path="OU=Admins,$DomainDN"; Category="Security"; Scope="Global"},
    @{Name="HR-Team";      Path="OU=TopLevelUsers,$DomainDN"; Category="Security"; Scope="Global"}
)

foreach ($group in $Groups) {
    if (-not (Get-ADGroup -Filter "Name -eq '$($group.Name)'" -ErrorAction SilentlyContinue)) {
        New-ADGroup -Name $group.Name `
                    -GroupCategory $group.Category `
                    -GroupScope $group.Scope `
                    -Path $group.Path `
                    -Description "Lab group for Entra Connect testing"
        Write-Host "Created group: $($group.Name)" -ForegroundColor Cyan
    }
}

# ====================== BULK USERS ======================
$Users = @(
    # Admins OU
    @{GivenName="Gbemiga";       Surname="Ola";       SamAccountName="gbemiga.ola";      UserPrincipalName="gbemiga.ola@cloud.training";     Path="OU=Admins,$DomainDN";     Title="Lab Administrator";       Department="IT";     EmployeeID="1001"},
    @{GivenName="Admin";         Surname="Test";      SamAccountName="admin.test";       UserPrincipalName="admin.test@cloud.training";      Path="OU=Admins,$DomainDN";     Title="Domain Admin";            Department="IT";     EmployeeID="1002"},
    
    # Employees OU
    @{GivenName="Aisha";         Surname="Ade";       SamAccountName="aisha.ade";        UserPrincipalName="aisha.ade@cloud.training";       Path="OU=Employees,$DomainDN";  Title="Finance Analyst";         Department="Finance";EmployeeID="2001"},
    @{GivenName="Chinedu";       Surname="Okoro";     SamAccountName="chinedu.okoro";    UserPrincipalName="chinedu.okoro@cloud.training";   Path="OU=Employees,$DomainDN";  Title="Software Engineer";       Department="IT";     EmployeeID="2002"},
    @{GivenName="Fatima";        Surname="Bello";     SamAccountName="fatima.bello";     UserPrincipalName="fatima.bello@cloud.training";    Path="OU=Employees,$DomainDN";  Title="HR Manager";              Department="HR";     EmployeeID="2003"},
    @{GivenName="Ibrahim";       Surname="Yusuf";     SamAccountName="ibrahim.yusuf";    UserPrincipalName="ibrahim.yusuf@cloud.training";   Path="OU=Employees,$DomainDN";  Title="Marketing Specialist";    Department="Marketing";EmployeeID="2004"},
    
    # Users OU (main testing pool)
    @{GivenName="John";          Surname="Doe";       SamAccountName="john.doe";         UserPrincipalName="john.doe@cloud.training";        Path="OU=TopLevelUsers,$DomainDN";      Title="Accountant";              Department="Finance";EmployeeID="3001"},
    @{GivenName="Jane";          Surname="Smith";     SamAccountName="jane.smith";       UserPrincipalName="jane.smith@cloud.training";      Path="OU=TopLevelUsers,$DomainDN";      Title="Developer";               Department="IT";     EmployeeID="3002"},
    @{GivenName="Michael";       Surname="Chen";      SamAccountName="michael.chen";      UserPrincipalName="michael.chen@cloud.training";     Path="OU=TopLevelUsers,$DomainDN";      Title="Sales Rep";               Department="Sales";  EmployeeID="3003"},
    @{GivenName="Priya";         Surname="Patel";     SamAccountName="priya.patel";      UserPrincipalName="priya.patel@cloud.training";     Path="OU=TopLevelUsers,$DomainDN";      Title="Recruiter";               Department="HR";     EmployeeID="3004"},
    @{GivenName="Feliciano";     Surname="Da Rosa";   SamAccountName="feliciano.darosa"; UserPrincipalName="feliciano.darosa@cloud.training";Path="OU=TopLevelUsers,$DomainDN";      Title="Support Engineer";        Department="IT";     EmployeeID="3005"}, 
    @{GivenName="Sarah";         Surname="Johnson";   SamAccountName="sarah.johnson";    UserPrincipalName="sarah.johnson@cloud.training";   Path="OU=TopLevelUsers,$DomainDN";      Title="Analyst";                 Department="Finance";EmployeeID="3006"}
)

foreach ($user in $Users) {
    if (-not (Get-ADUser -Filter "SamAccountName -eq '$($user.SamAccountName)'" -ErrorAction SilentlyContinue)) {
        New-ADUser -GivenName $user.GivenName `
                   -Surname $user.Surname `
                   -Name "$($user.GivenName) $($user.Surname)" `
                   -SamAccountName $user.SamAccountName `
                   -UserPrincipalName $user.UserPrincipalName `
                   -Path $user.Path `
                   -AccountPassword $Password `
                   -Enabled $true `
                   -ChangePasswordAtLogon $false `
                   -Title $user.Title `
                   -Department $user.Department `
                   -EmployeeID $user.EmployeeID `
                   -Description "Entra Connect lab test user - created April 2026"
        
        Write-Host "Created user: $($user.SamAccountName)" -ForegroundColor Yellow
    }
}

# ====================== ADD USERS TO GROUPS ======================
# Finance-Team
Add-ADGroupMember -Identity "Finance-Team" -Members "aisha.ade","john.doe","sarah.johnson"

# IT-Admins
Add-ADGroupMember -Identity "IT-Admins" -Members "gbemiga.ola","chinedu.okoro","feliciano.darosa"

# HR-Team
Add-ADGroupMember -Identity "HR-Team" -Members "fatima.bello","priya.patel"

Write-Host "`n=== Bulk creation completed! ===" -ForegroundColor Green
Write-Host "12 users created across 3 OUs"
Write-Host "3 security groups created and populated"
Write-Host "Ready for Entra Connect synchronization scoping to OU=TopLevelUsers,$DomainDN"
