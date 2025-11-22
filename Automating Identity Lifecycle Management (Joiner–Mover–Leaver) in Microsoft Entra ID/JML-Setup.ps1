# Install module
Install-Module Microsoft.Graph -Scope CurrentUser -Force

# Connect with correct scopes
Connect-MgGraph -Scopes "User.ReadWrite.All","User-LifeCycleInfo.ReadWrite.All","Group.ReadWrite.All"
disconnect-MgGraph


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





