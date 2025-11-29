# Cloud Auth Demo

### Project Overview
The adapted "Cloud Auth Demo" project focuses on configuring Microsoft Entra ID (formerly Azure AD) for SAML, OAuth, and OIDC using only the admin center. This Project focuses on SAML for enterprise SSO (e.g., with a gallery app like Salesforce), OIDC for modern logins (e.g., with a gallery app like Smartsheet), and OAuth for delegated API access (e.g., via Microsoft Graph). The Cloud Auth Demo project provides a straightforward way to illustrate my understanding of authentication and authorization protocols like SAML, OAuth, and OIDC. What's the Difference?" By leveraging Microsoft Entra ID's user-friendly admin center, the project emphasizes enterprise-grade configurations through gallery apps and app registrations, SAML for trusted federated SSO with XML assertions and rich attributes, OAuth for scoped, revocable delegation without inherent identity, and OIDC as an OAuth extension adding standardized JWT ID tokens for hybrid authentication in modern ecosystems. This setup mirrors real-world scenarios where organizations centralize identity management to avoid password sharing, enhancing security and user experience.  

### High-Level Steps
1. Set up Entra ID tenant and users.
2. Configure protocol-specific apps.
3. Test and document for portfolio.

#### Detailed Prerequisites
- **Azure Subscription**: Use the free tier at [azure.microsoft.com](https://azure.microsoft.com) to create an Entra ID tenant. Sign in as a Global Administrator or Application Administrator.
- **Gallery App Accounts**: Sign up for free trials of gallery apps like Salesforce (for SAML) at [salesforce.com](https://www.salesforce.com) or Smartsheet (for OIDC) at [smartsheet.com](https://www.smartsheet.com). These are pre-integrated in Entra ID's gallery.
- **Testing Tools**: Browser (e.g., Chrome) for sign-in flows; Postman (download at [postman.com](https://www.postman.com)) for OAuth token requests.


#### Step 1: Setting Up Entra ID Basics
1. Log in to the [Microsoft Entra admin center](https://entra.microsoft.com).
2. Create test users: Navigate to Entra ID > Users > New user. Add users like `employee1@techcorp.com` with passwords.
3. Optionally, enable MFA or conditional access in Entra ID > Security for realism, but keep it simple for demo.



#### Step 2: Configuring Protocol-Specific Apps
Use the UI to add and customize apps, focusing on gallery integrations where possible.

##### SAML Configuration (Enterprise SSO with Gallery App)
1. Go to Entra ID > Enterprise applications > New application.
2. Search the gallery for "Salesforce" (a common SAML-supported app); select and add it.
3. In the app's properties, select Single sign-on > SAML.
4. Edit Basic SAML Configuration: Enter Identifier (e.g., `https://techcorp.my.salesforce.com`), Reply URL (from Salesforce SSO settings, e.g., `https://techcorp.my.salesforce.com/acs`).
5. Download the SAML Signing Certificate (Base64) and upload it to Salesforce's SSO setup.
6. Set User Attributes & Claims: Map NameID to user.email; add attributes like department=Engineering.
7. Assign users: Under Users and groups, add `employee1`.
8. In Salesforce admin (no code), enable SAML and paste Entra endpoints (e.g., Login URL: `https://login.microsoftonline.com/{tenant-id}/saml2`).

This aligns with the article's SAML use for federated enterprise auth with rich attributes.

##### OIDC Configuration (Modern Login with Gallery App)
1. In Enterprise applications > New application, search for "Smartsheet" (OIDC-supported gallery app); add it.
2. Select Single sign-on > OpenID Connect (if prompted; some gallery apps auto-configure OIDC).
3. Complete consent: Sign in with Entra credentials, accept permissions.
4. Configure details: Add Redirect URIs (e.g., `https://app.smartsheet.com/auth/redirect` from Smartsheet docs).
5. Add API permissions: Go to App registrations (linked from enterprise app), add delegated scopes like openid, profile, email.
6. Grant admin consent.
7. In Smartsheet settings, enable OIDC and input Entra details (Client ID, Tenant ID from app Overview).

For custom OIDC if needed: Use App registrations > New registration, set as single-tenant, add Web redirect URI.

This reflects the article's OIDC as OAuth-enhanced for identity and API access.

##### OAuth Configuration (Delegated Access with App Registration)
1. Go to Entra ID > App registrations > New registration.
2. Name: `oauth-partner-app`; set as single-tenant; add Redirect URI (Web: `http://localhost` for demo).
3. Note Client ID and Tenant ID.
4. Add API permissions: Microsoft Graph > Delegated > User.Read.
5. Generate client secret: Certificates & secrets > New client secret.
6. For PKCE (secure no-secret flow): Enable in Authentication.

This setup matches the article's OAuth for revocable, scoped delegations.

#### Step 3: Testing the Flows Without Code
- **SAML**: In browser, go to Salesforce login; select "Use Company Login" to redirect to Entra sign-in. Verify attributes in Salesforce user profile.
- **OIDC**: Access Smartsheet; sign in with Microsoft—observe redirect and ID token (use browser dev tools to inspect JWT at jwt.ms if redirected).
- **OAuth**: In browser, construct authorize URL: `https://login.microsoftonline.com/{tenant}/oauth2/v2.0/authorize?client_id={client_id}&response_type=code&redirect_uri=http://localhost&scope=User.Read&state=1234`. Sign in; copy code from redirect.
  - In Postman: POST to `https://login.microsoftonline.com/{tenant}/oauth2/v2.0/token` with body: client_id, code, redirect_uri, grant_type=authorization_code, client_secret. Get access token.
- SSO Demo: Sign in once via Entra; access all apps seamlessly.


| Protocol | Use Case in Scenario | Key Config in Entra UI | Gallery Example | Testing Method | 
|----------|----------------------|------------------------|-----------------|---------------|
| SAML     | HR app SSO          | Enterprise app, XML cert | Salesforce     | Browser redirect |
| OIDC     | Dashboard login     | App registration, ID tokens | Smartsheet     | Browser JWT inspect | 
| OAuth    | Partner API access  | App registration, scopes | N/A (Custom)   | Postman token request | 

#### Advanced Configurations
- Custom Attributes: In SAML/OIDC, map extension attributes in Claims.
- Security: Enable short token lifespans in Token configuration.
- Troubleshooting: Check audit logs in Entra ID > Sign-ins for errors like mismatched URIs.
.

### Key Citations
- [Configure OIDC SSO for gallery and custom applications - Microsoft Entra ID](https://learn.microsoft.com/en-us/entra/identity/enterprise-apps/add-application-portal-setup-oidc-sso)
- [SAML-based single sign-on: Configuration and Limitations - Microsoft Entra ID](https://learn.microsoft.com/en-us/entra/identity/enterprise-apps/migrate-adfs-saml-based-sso)
- [Microsoft identity platform and OAuth 2.0 authorization code flow - Microsoft identity platform](https://learn.microsoft.com/en-us/entra/identity-platform/v2-oauth2-auth-code-flow)
- [Integrating Microsoft Entra ID with applications getting started guide](https://learn.microsoft.com/en-us/entra/identity/enterprise-apps/plan-an-application-integration)
- [SAML-based single sign-on: Configuration and Limitations](https://learn.microsoft.com/en-us/entra/identity/enterprise-apps/migrate-adfs-saml-based-sso)
- [Configure OIDC SSO for gallery and custom applications](https://learn.microsoft.com/en-us/entra/identity/enterprise-apps/add-application-portal-setup-oidc-sso)
- [Microsoft identity platform and OAuth 2.0 authorization code flow](https://learn.microsoft.com/en-us/entra/identity-platform/v2-oauth2-auth-code-flow)
