## 🛡️ How Microsoft Entra ID Authentication & Authorization Enhanced Cousera’s Security

Microsoft Entra ID significantly strengthened Cousera’s overall cloud security posture by implementing **centralized, identity-based access control** across all users, applications, and administrators. The improvements came through both **authentication** (verifying who a user is) and **authorization** (controlling what they can access).

---

### 🔐 1. Stronger User Identity Verification (Authentication)

**Before:**
Cousera relied on basic username–password authentication, which exposed users to credential theft and phishing attacks.

**After using Entra ID:**

* **Multi-Factor Authentication (MFA):**
  Every employee must verify their identity using a second factor (e.g., Microsoft Authenticator or Email OTP), drastically reducing the risk of unauthorized logins even if passwords are compromised.
* **Conditional Access Policies:**
  Login attempts from untrusted networks or unknown locations are automatically blocked, ensuring that access only occurs under secure, compliant conditions.
* **Modern Authentication (OAuth 2.0 / OpenID Connect):**
  Applications no longer store or verify passwords directly. Instead, they delegate authentication to Entra ID, which issues secure tokens — eliminating risks from password reuse or exposure.

✅ **Impact:**
Reduced account compromise risks, enforced secure sign-ins, and ensured adaptive protection based on context and risk level.

---

### 🧾 2. Granular Access Control (Authorization)

**Before:**
Employees had broad, manual access to multiple systems, leading to potential privilege misuse or data exposure.

**After using Entra ID:**

* **Role-Based Access Control (RBAC):**
  Users were granted only the permissions required for their job roles (e.g., HR Admin, Billing Admin, Application Admin). This minimized privilege exposure.
* **Custom Roles & Administrative Units:**
  HR admins like Alice were given specific access scopes limited to HR data and users, preventing cross-departmental access.
* **App Roles for Custom Applications:**
  The HR web application (CouseraHRApp) used Entra app roles (`HR.Admin`, `HR.User`) to control feature access at the application level, aligning authorization policies with organizational roles.
* **Privileged Identity Management (PIM):**
  High-level admin roles (e.g., Global Reader) required just-in-time activation with MFA and justification, preventing permanent elevated access.

✅ **Impact:**
Least-privilege access model enforced, reduced insider threats, and increased accountability through time-bound and auditable role activations.

---

### 🌐 3. Unified Identity Governance & Monitoring

* **Centralized Audit Logs:**
  All sign-ins and role activations were logged and can be reviewed for anomalies.
* **Risk-Based Policies:**
  Identity Protection automatically detected risky sign-ins and could require MFA or block them.
* **Compliance and Reporting:**
  With built-in Entra reports, Cousera could demonstrate identity compliance for internal audits and security certifications.

✅ **Impact:**
Improved visibility, faster threat response, and measurable compliance with identity security standards (e.g., Zero Trust principles).

---

### 🧠 4. Overall Security Outcome

| Security Area            | Before Entra ID                | After Entra ID                      |
| ------------------------ | ------------------------------ | ----------------------------------- |
| **User Verification**    | Password-only                  | MFA + Conditional Access            |
| **Access Control**       | Manual & broad                 | RBAC + Custom Roles + App Roles     |
| **Privilege Management** | Static, permanent admin rights | Just-in-Time access via PIM         |
| **Audit & Visibility**   | Limited logs                   | Centralized sign-in & risk analysis |
| **App Security**         | Direct credentials             | Token-based OAuth2 / OpenID Connect |

✅ **Result:**
Cousera transitioned to a **Zero Trust identity model**, where *no user or device is trusted by default* — access is continuously verified, least-privilege enforced, and suspicious behavior automatically mitigated.

---

### 🏁 Summary Statement

> *“By leveraging Microsoft Entra ID’s authentication and authorization capabilities, Cousera Cloud Services achieved a secure, policy-driven identity environment that protects user accounts, limits access to sensitive data, and maintains compliance with modern cybersecurity frameworks.”*
