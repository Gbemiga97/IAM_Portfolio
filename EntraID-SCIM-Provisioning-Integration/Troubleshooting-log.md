# Troubleshooting Log: Entra ID SCIM Provisioning Integration with Slack

This log documents the errors encountered during setup, testing, and integration, along with resolutions. Chronological order based on project phases.

## Phase 1: Initial SCIM Connection
- **Error**: "Invalid credentials" during Entra ID provisioning setup (SystemForCrossDomainIdentityManagementCredentialValidationUnavailable). Forbidden response on /scim/v1/Groups endpoint.
- **Cause**: Slack account lacked Workspace Admin permissions; possible plan restriction (free tier limits SCIM).
- **Fix**: Promoted account to Admin in Slack (Settings > Manage members > Change account type). Retried authorization—success. Noted, Business+ plan needed for full support.

## Phase 2: SAML SSO Configuration
- **Error**: AADSTS700016 - Application with identifier not found in directory.
- **Cause**: Mismatch between Slack's workspace-specific identifier and Entra ID's generic gallery app config.
- **Fix**: Changed Slack's Service Provider Issuer URL to `https://slack.com`. Updated Entra ID, Entity ID and Reply URL accordingly. Tested configuration—passed.

- **Error**: "?sso_incorrectly_formatted=1" on Slack login page.
- **Cause**: SAML response format issues, likely from endpoint mismatches or missing user provisioning.
- **Fix**: Updated Entra ID Reply URL to workspace-specific (`https://cousera669workspace.slack.com/sso/saml`). Set AuthnContextClassRef to "Don't send". Assigned Entra ID P1 license to test user in Microsoft 365 admin center to enable provisioning, creating the account in Slack for SSO binding.

## Phase 3: PowerShell Scripting for Testing
- **Error**: BadRequest (400) - "The assigned app role was not found on the application" with New-MgUserAppRoleAssignment.
- **Cause**: Slack gallery app lacks custom app roles; default ID is invalid without enabling assignments.
- **Fix**: Switched to manual assignment in Entra ID portal (Users and groups > Add user). Noted scripted assignments unreliable for such apps—used PowerShell only for user creation/disabling and logs.

- **Error**: NotFound (404) - Resource not found for ResourceId.
- **Cause**: Incorrect/hardcoded service principal Object ID.
- **Fix**: Fetched ID dynamically with Get-MgServicePrincipal -Filter "displayName eq 'Slack'". But ultimately pivoted to manual for reliability.

## Phase 4: Provisioning and Login Tests
- **Error**: Provisioning didn't trigger; test user couldn't log in via SSO.
- **Cause**: Missing premium license for the user.
- **Fix**: Assigned Entra ID P1 or Microsoft 365 Basics/Entra ID Governance license to the test user in Microsoft 365 admin center. Retested provisioning—user synced, and SSO login succeeded.

## General Tips from Troubleshooting
- Always verify logs: Entra ID provisioning logs and sign-in activity; Slack access logs.
- Use incognito mode for tests to avoid caching.


These challenges highlighted the importance of thorough config checks and licensing awareness in IAM projects.
