### **Project Note: Fixing AADSTS90014 – "nonce is missing" Error in Entra ID Implicit Flow**

**Date:** October 30, 2025  
**Author:** Holuwagbemiga  
**Context:** Testing Entra ID app role claims using `https://jwt.ms` with implicit OIDC flow.

---

#### **Problem**
When attempting to sign in using the Microsoft Entra ID v2.0 authorization endpoint to retrieve an **ID token** containing **app role claims**, the following error was returned:

```
AADSTS90014: The required field 'nonce' is missing from the credential.
```
**📸 Screenshot of the error message**
<div>
  <img width="1000" height="291" alt="Screenshot 2025-10-28 134921" src="https://github.com/user-attachments/assets/29ab9614-eacc-4306-80ec-281cb3ad5772" />
</div>

Redirect URL:  
`https://login.microsoftonline.com/error?code=90014`

This blocked authentication and prevented the ID token from being issued.

---

#### **Root Cause**
- The **Microsoft Identity Platform v2.0 endpoint** (`/oauth2/v2.0/authorize`) **enforces the `nonce` parameter** when `response_type=id_token` is used.
- The `nonce` parameter is a **required security measure** to prevent **token replay attacks**.
- Even though `nonce` is *optional* in the OpenID Connect spec, **Microsoft mandates it** for v2.0 implicit flows issuing ID tokens.
- Our initial authorization URL **omitted `nonce`**, triggering the `AADSTS90014` error.

> Note: The v1.0 endpoint (`/oauth2/authorize`) does **not** require `nonce`, but v2.0 is recommended for modern apps.

---

#### **Solution Applied**
Added the **`nonce` parameter** to the authorization URL with any non-empty string value.

**Before (Broken):**
```http
https://login.microsoftonline.com/{tenant}/oauth2/v2.0/authorize?
client_id={client-id}
&response_type=id_token
&redirect_uri=https://jwt.ms
&response_mode=fragment
&scope=openid
&state=12345
```

**After (Fixed):**
```
https://login.microsoftonline.com/{tenant}/oauth2/v2.0/authorize?
client_id={client-id}
&response_type=id_token
&redirect_uri=https://jwt.ms
&response_mode=fragment
&scope=openid
&nonce=test12345
&state=12345
```

> `nonce=test12345` (or any unique string per request) satisfies the requirement.

---

#### **Verification Steps**
1. Opened the **updated URL** in an **incognito browser** window.
2. Signed in with a user assigned to the app roles.
3. Successfully redirected to:
   ```
   https://jwt.ms#id_token=eyJ0eXAiOiJKV1Qi...
   ```
4. **jwt.ms** decoded the ID token and displayed:
   - `aud`: Matches app client ID
   - `roles`: Array of assigned app roles (e.g., `["Admin", "Editor"]`)
   - `nonce`: Echoed back as `test12345`

**Success Confirmed**: App role claims are now correctly included in the ID token.  
 **📸 Screenshot of the  app role claims**
<div>
  <img width="600" height="400" alt="Screenshot 2025-10-28 135531" src="https://github.com/user-attachments/assets/13a02348-01c3-4486-bc15-0b9b9dd65d20" />

</div>
---

#### **Final Working Template (for future use)**
```
https://login.microsoftonline.com/{tenant-id}/oauth2/v2.0/authorize?
client_id={your-client-id}
&response_type=id_token
&redirect_uri=https://jwt.ms
&response_mode=fragment
&scope=openid
&nonce={random-string}
&state=12345
```

| Parameter | Value Example | Required? | Notes |
|---------|----------------|-----------|-------|
| `tenant-id` | `contoso.onmicrosoft.com` or GUID | Yes | Your Entra ID tenant |
| `client_id` | `a1b2c3d4-...` | Yes | From App Registration |
| `nonce` | `test123`, `abc`, `2025test` | **Yes (v2.0)** | Prevents replay |
| `state` | `12345` | Recommended | CSRF protection |

---

#### **Best Practices Going Forward**
- Always include `nonce` when using `response_type=id_token` on **v2.0 endpoint**.
- Use **random/guid-like values** in production (e.g., `crypto.randomUUID()`).
- Prefer **Authorization Code Flow + PKCE** in real apps (not implicit).
- For quick testing: `https://jwt.ms` + implicit flow is acceptable **only in dev**.

---

#### **References**
- Microsoft Docs: [v2.0 Protocols - OpenID Connect](https://learn.microsoft.com/en-us/entra/identity-platform/v2-protocols-oidc)
- Error Code: [AADSTS90014](https://learn.microsoft.com/en-us/entra/identity-platform/reference-error-codes)
- jwt.ms: https://jwt.ms

---

**Issue Resolved**: Entra ID now returns ID tokens with `roles` claim as expected.  
**Ready for integration testing and role-based access control (RBAC) validation.**

---
