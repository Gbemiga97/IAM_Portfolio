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
3. Optionally, enable MFA or conditional access in Entra ID.

📸 Screenshot of the user:
<div>
  <img width="400" height="627" alt="Screenshot 2025-12-01 151921" src="https://github.com/user-attachments/assets/9a56baa2-f57d-47a3-a717-b26c37df6e47" />
</div>


#### Step 2: Configuring Protocol-Specific Apps
Use the UI to add and customize apps, focusing on gallery integrations where possible.

##### SAML Configuration (Enterprise SSO with Gallery App)
1. Go to Entra ID > Enterprise applications > New application.
2. Search the gallery for "Salesforce" (a common SAML-supported app); select and add it.
3. In the app's properties, select Single sign-on > SAML.
4. Edit Basic SAML Configuration: Enter Identifier (e.g., `https://cousera894.my.salesforce.com`), Reply URL (from Salesforce SSO settings, e.g., `https://cousera894.my.salesforce.com/acs`).
5. Download the SAML Signing Federation Metadata XML and Certificate (Raw) to upload it to Salesforce's SSO setup.
6. 8. Assign users: Under Users and groups, add `employee1`.
7. Configure Salesforce SSO, and Create Salesforce test user - to have a counterpart of `employee1` in Salesforce that's linked to the Microsoft Entra representation of the user.
8.  In Salesforce admin (no code), enable SAML and paste Entra endpoints (e.g., Login URL: `https://login.microsoftonline.com/{tenant-id}/saml2`).
9.  Test The SSO from signing with `employee1` in  [My Apps](https://myapplications.microsoft.com)
10. Access Smartsheet; sign in with Microsoft—observe redirect and ID token (use browser dev tools to inspect JWT at jwt.ms if redirected).  

📸 Screenshot of the configuration:

<div>
  <img width="320" height="873" alt="Screenshot 2025-12-07 151654" src="https://github.com/user-attachments/assets/2fd8af12-c7e0-4651-a6f3-dda52cf4731f" />
  <img width="320" height="364" alt="Screenshot 2025-12-04 163334" src="https://github.com/user-attachments/assets/2fd2d9d0-1a31-4c67-8229-111bf59b2104" />
<img width="320" height="705" alt="Screenshot 2025-12-06 185558" src="https://github.com/user-attachments/assets/1c927f41-7371-49e2-9060-6013982c25f3" />
<img width="320" height="510" alt="Screenshot 2025-12-07 152510" src="https://github.com/user-attachments/assets/d2840e63-0e7f-46bc-af99-766bb15be580" />
  <img width="320" height="441" alt="Screenshot 2025-12-07 152333" src="https://github.com/user-attachments/assets/1ddd4605-2376-49f2-a1db-2ade86b98419" />
 <img width="320" height="745" alt="Screenshot 2025-12-07 154602" src="https://github.com/user-attachments/assets/056ff0cd-0909-43df-b1fd-474bbc50ab98" />
<img width="320" height="603" alt="Screenshot 2025-12-06 190939" src="https://github.com/user-attachments/assets/cef615f6-0d54-4af3-8ca5-302a07b7c851" />
<img width="320" height="759" alt="Screenshot 2025-12-06 190245" src="https://github.com/user-attachments/assets/fb5480ac-e3c2-49ed-a923-e01bc45253c0" />
<img width="320" height="892" alt="Screenshot 2025-12-07 155353" src="https://github.com/user-attachments/assets/492e8f5a-bd3d-47a6-b15e-65fa58404c34" />
<img width="320" height="866" alt="Screenshot 2025-12-07 155416" src="https://github.com/user-attachments/assets/1ed70fde-df75-4ad9-9099-62214280c84d" />
<img width="640" height="786" alt="Screenshot 2025-12-07 155448" src="https://github.com/user-attachments/assets/a1c61eef-d75a-4107-a1bc-71b1d75d4a9f" />
</div>

##### OIDC Configuration (Modern Login with Gallery App)
1. In Enterprise applications > New application, search for "Smartsheet" (OIDC-supported gallery app); add it.
2. Select Single sign-on > OpenID Connect (if prompted; some gallery apps auto-configure OIDC).
3. Complete consent: Sign in with Entra credentials, accept permissions.

📸 Screenshot of the configuration:

<div>
  <img width="640" height="1174" alt="oidc-sso-configuration" src="https://github.com/user-attachments/assets/0f5553fa-84ba-4ef2-9585-5ee508db27e6" />
<img width="320" height="725" alt="Screenshot 2025-12-07 175933" src="https://github.com/user-attachments/assets/80b65951-9ba8-4ecf-8c92-d0c70a2aba03" />
<img width="320" height="669" alt="Screenshot 2025-12-07 180018" src="https://github.com/user-attachments/assets/a9e62188-a39b-4c47-bbc2-26d503d9a8a8" />
<img width="320" height="417" alt="Screenshot 2025-12-08 171525" src="https://github.com/user-attachments/assets/952c2732-6c96-4b35-bc93-e91fff1c30bc" />
<img width="320" height="859" alt="Screenshot 2025-12-08 173533" src="https://github.com/user-attachments/assets/03bf8ab7-39c0-40aa-985d-84f690b7091c" />
<img width="320" height="647" alt="Screenshot 2025-12-08 173558" src="https://github.com/user-attachments/assets/e83c2b02-be9e-460f-bd1a-6290e0cadfe6" />
<img width="320" height="696" alt="Screenshot 2025-12-08 173721" src="https://github.com/user-attachments/assets/ece50bb0-0f15-444e-9fdf-42627bcafc14" />
<img width="320" height="724" alt="Screenshot 2025-12-11 160732" src="https://github.com/user-attachments/assets/92ae8f84-125f-438e-95fd-33dd181686b3" />
</div>


##### OAuth Configuration (Delegated Access with App Registration)
1. Go to Entra ID > App registrations > New registration.
2. Name: `oauth-partner-app`; set as single-tenant; add Redirect URI (Web: `http://localhost` for demo).
3. Note Client ID and Tenant ID.
4. Add API permissions: Microsoft Graph > Delegated > User.Read.
5. Generate client secret: Certificates & secrets > New client secret.
6. For PKCE (secure no-secret flow): Enable in Authentication.

###### Key Configurations Table In Postman GUI

| Parameter | Description | Example Value |
|-----------|-------------|---------------|
|Grant Type | Flow for delegated access | Authorization Code (with PKCE) | 
| Callback URL    | Where Entra ID redirects after auth   | https://oauth.pstmn.io/v1/callback |
| Auth URL    | Endpoint for user sign-in  | https://login.microsoftonline.com/{tenant_id}/oauth2/v2.0/authorize|
| Access Token URL   | Endpoint to exchange code for token   | https://login.microsoftonline.com/{tenant_id}/oauth2/v2.0/token |
| Client ID   | Unique app identifier  | From Entra ID Overview |
| Client Secret  | Secure authentication key | From Entra ID Certificates & secrets |
| Scope  | Permissions requested  | https://graph.microsoft.com/User.Read   https://graph.microsoft.com/Mail.Read|
| Client Authentication  | How credentials are sent  | Send as Basic Auth header |

- **OAuth**: In browser, construct authorize URL: `https://login.microsoftonline.com/{tenant}/oauth2/v2.0/authorize?client_id={client_id}&response_type=code&redirect_uri=http://localhost&scope=User.Read&state=1234`. Sign in; copy code from redirect.
  - In Postman: POST to `https://login.microsoftonline.com/{tenant}/oauth2/v2.0/token` with body: client_id, code, redirect_uri, grant_type=authorization_code, client_secret. Get an access token.
- SSO Demo: Sign in once via Entra; access all apps seamlessly.  

📸 Screenshot of the configuration:

<div>
    <img width="1633" height="401" alt="Screenshot 2025-12-15 132401" src="https://github.com/user-attachments/assets/f37e481a-c852-4f22-bae7-e64e0253f24a" />
<img width="947" height="639" alt="Screenshot 2025-12-14 165710" src="https://github.com/user-attachments/assets/30d35684-2c06-4807-b0f1-12b7e3ec6597" />
 <img width="1645" height="645" alt="Screenshot 2025-12-14 170734" src="https://github.com/user-attachments/assets/f17b93cb-2eff-4026-9a97-76c409e62e18" />
<img width="800" height="415" alt="Screenshot 2025-12-14 170746" src="https://github.com/user-attachments/assets/c7f7acfb-55ba-4091-b6aa-a7ecda894b9b" />

  <img width="1656" height="687" alt="Screenshot 2025-12-14 170923" src="https://github.com/user-attachments/assets/76238b15-d31b-4311-be8d-6a1524f57439" />
<img width="1372" height="799" alt="Screenshot 2025-12-15 133321" src="https://github.com/user-attachments/assets/2fc694fb-ec4b-4450-8293-b330368fd6f0" />
<img width="754" height="838" alt="Screenshot 2025-12-15 134508" src="https://github.com/user-attachments/assets/9bc925e0-bd0c-4b68-818e-02e72862c08a" />
<img width="1672" height="668" alt="Screenshot 2025-12-15 135443" src="https://github.com/user-attachments/assets/e7a8f381-460c-4132-af6e-dbeeba4fb1b0" />
<img width="1920" height="1080" alt="Screenshot (223)" src="https://github.com/user-attachments/assets/85806507-b2f8-4d52-ba88-3bff37938ca4" />
<img width="1496" height="820" alt="Screenshot 2025-12-15 143215" src="https://github.com/user-attachments/assets/c30856f7-c4d0-44e6-b546-50c22bd5eaa8" />
<img width="816" height="554" alt="Screenshot 2025-12-15 152333" src="https://github.com/user-attachments/assets/13f06129-7175-43c0-92d2-a96c4af90817" />
<img width="1509" height="728" alt="Screenshot 2025-12-15 153034" src="https://github.com/user-attachments/assets/010f482a-f733-41a7-b0cf-39d6ee9f0b77" />
<img width="1654" height="764" alt="Screenshot 2025-12-15 153049" src="https://github.com/user-attachments/assets/b5f8ebb6-02b7-49d8-8284-03fd04462634" />
</div>


| Protocol | Use Case in Scenario | Key Config in Entra UI | Gallery Example | Testing Method | 
|----------|----------------------|------------------------|-----------------|---------------|
| SAML     | HR app SSO          | Enterprise app, XML cert | Salesforce     | Browser redirect |
| OIDC     | Dashboard login     | App registration, ID tokens | Smartsheet     | Browser JWT inspect | 
| OAuth    | Partner API access  | App registration, scopes | N/A (Custom)   | Postman token request | 

#### Advanced Configurations
- Custom Attributes: In SAML/OIDC, map extension attributes in Claims.
- Security: Enable short token lifespans in Token configuration.
- Troubleshooting: Check audit logs in Entra ID > Sign-ins for errors like mismatched URIs.

### Key Citations
- [Configure OIDC SSO for gallery and custom applications - Microsoft Entra ID](https://learn.microsoft.com/en-us/entra/identity/enterprise-apps/add-application-portal-setup-oidc-sso)
- [SAML-based single sign-on: Configuration and Limitations - Microsoft Entra ID](https://learn.microsoft.com/en-us/entra/identity/enterprise-apps/migrate-adfs-saml-based-sso)
- [Microsoft identity platform and OAuth 2.0 authorization code flow - Microsoft identity platform](https://learn.microsoft.com/en-us/entra/identity-platform/v2-oauth2-auth-code-flow)
- [Integrating Microsoft Entra ID with applications getting started guide](https://learn.microsoft.com/en-us/entra/identity/enterprise-apps/plan-an-application-integration)
- [SAML-based single sign-on: Configuration and Limitations](https://learn.microsoft.com/en-us/entra/identity/enterprise-apps/migrate-adfs-saml-based-sso)
- [Configure OIDC SSO for gallery and custom applications](https://learn.microsoft.com/en-us/entra/identity/enterprise-apps/add-application-portal-setup-oidc-sso)
- [Microsoft identity platform and OAuth 2.0 authorization code flow](https://learn.microsoft.com/en-us/entra/identity-platform/v2-oauth2-auth-code-flow)
