
# CyberArk PAM Self-Hosted 12.6: LDAP Integration Lab

## What is this project?

This lab documents my hands-on experience configuring **LDAP Integration** between CyberArk PAM Self-Hosted 12.6 and Active Directory. With all four core components installed (Vault, PVWA, CPM, PSM), the next logical step is connecting CyberArk to the organisation's directory so that domain users can log into PVWA using their existing Active Directory credentials — without needing a separate CyberArk-specific account.

This project walks through creating the required Active Directory objects, configuring the LDAP connection in PVWA, mapping AD groups to CyberArk roles, enabling LDAP authentication, and verifying that a domain user can log in successfully.

---

## What is LDAP Integration and Why Does It Matter?

By default, CyberArk uses **internal users** — accounts that exist only inside the Vault and have no relationship to Active Directory. This works for initial setup but does not scale in an enterprise environment where:

- Hundreds of users need access to PVWA
- Those users already have AD accounts managed by IT
- Onboarding and offboarding must be centralised
- Authentication must go through the organisation's existing identity infrastructure

**LDAP Integration** solves all of this. It connects CyberArk to Active Directory so that:

- Domain users log into PVWA with their existing AD username and password — no second set of credentials needed
- When a user is disabled in AD, they immediately lose access to CyberArk too — no manual deprovisioning in PVWA
- **Directory Mapping** automatically assigns the correct CyberArk permissions to users based on which AD group they belong to
- CyberArk dynamically creates a Vault user the first time an AD user logs in — and deactivates it if they are removed from the relevant AD group

This is called **Transparent User Management** — CyberArk automatically manages user lifecycle based on the AD directory, with minimal manual administration.

---

## The Tools and Technologies I Used

- **CyberArk PAM Self-Hosted 12.6 PVWA** — Where all LDAP configuration is done
- **Active Directory (AD)** — The LDAP-compliant directory CyberArk is integrating with
- **Active Directory Users and Computers (ADUC)** — Used to create the required AD objects
- **Domain Controller** — `WIN-6B5GOGITF83.pitythefool.com` running AD DS for the `pitythefool.com` domain
- **LDAP Bind Account** — A dedicated AD service account CyberArk uses to query the directory
- **AD Security Groups** — Four groups created in AD that map to CyberArk's role levels

---

## Understanding the Two Key Concepts Before Starting

### Concept 1 — The Bind Account

CyberArk cannot query Active Directory anonymously. It needs a dedicated AD service account — called the **Bind Account** — to authenticate to AD and run directory lookups. This account:

- Is a standard AD user account with no special privileges
- Does **not** need to be a Domain Admin
- Needs **read-only access** to the Users and Groups containers in AD
- Should have its password set to never expire — if this account's password expires, all LDAP authentication in CyberArk breaks until it is updated

Think of the Bind Account as CyberArk's "eyes" into Active Directory. Without it, PVWA cannot see any AD users or groups.

### Concept 2 — Directory Mapping

Directory Mapping is how CyberArk decides what permissions to give a user when they log in via LDAP. It works by linking an **AD security group** to a **CyberArk role level**. When a user logs in:

1. CyberArk uses the Bind Account to query AD
2. It checks which AD groups the user belongs to
3. It matches those groups against the Directory Mapping rules
4. It automatically provisions the user in the Vault with the corresponding permissions

This means instead of manually setting permissions for every user in CyberArk, you manage access entirely through AD group membership.

---
