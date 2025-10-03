📌 Scenario

A mid-sized financial services company, FinSecure Corp, was facing growing risks from weak passwords, unmanaged privileged accounts, and suspicious sign-in attempts from risky locations.
As an Identity and Access Management Intern, I was tasked to design and implement security-first IAM practices using Microsoft Entra ID (formerly Azure AD).
🎯 Objectives

Eliminate the use of weak or common passwords across all employees.

Ensure privileged accounts are just-in-time (JIT) and properly managed.

Protect user accounts from suspicious sign-ins and identity-based attacks using adaptive policies.

🔧 Implementation Steps
1. Microsoft Entra Password Protection

Configured a custom banned password list (e.g., “Welcome123”, company name, season+year).

Enforced password complexity rules across hybrid environment (on-premises AD + Entra ID).

Tested by attempting to reset passwords to banned values (blocked successfully).

✅ Outcome: Users could no longer use predictable passwords; reduced risk of password spray attacks.

2. Privileged Identity Management (PIM)

Enabled PIM in Microsoft Entra ID to manage roles like Global Administrator and Privileged Role Administrator.

Configured Just-in-Time (JIT) access so admins could only elevate permissions when needed.

Added approval workflow (manager approval required before elevation).

Logged and reviewed audit reports for elevated role usage.

✅ Outcome: Reduced standing privileges, minimizing insider and external threats.

3. Identity Protection Policies

Enabled User Risk Policy to require MFA or password reset if suspicious activity detected.

Configured Sign-in Risk Policy to block sign-ins from anonymous IPs, TOR browsers, or impossible travel scenarios.

Monitored risky users in Entra ID Identity Protection dashboard.

✅ Outcome: Risky logins were automatically mitigated; compromised accounts could not continue operating undetected.

📊 Tools & Technologies

Microsoft Entra ID (P1/P2 trial)

Microsoft Entra Password Protection (cloud + on-prem sync)

Privileged Identity Management (PIM)

Identity Protection Policies

Azure Monitor & Sign-in Logs
