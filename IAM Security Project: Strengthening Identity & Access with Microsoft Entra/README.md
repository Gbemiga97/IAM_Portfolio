📌 Scenario

A mid-sized financial services company, Cousera, was facing growing risks from weak passwords, unmanaged privileged accounts, and suspicious sign-in attempts from risky locations.
As an Identity and Access Management Intern, I was tasked to design and implement security-first IAM practices using Microsoft Entra ID (formerly Azure AD).
🎯 Objectives

Eliminate the use of weak or common passwords across all employees.

Ensure privileged accounts are just-in-time (JIT) and properly managed.

Protect user accounts from suspicious sign-ins and identity-based attacks using adaptive policies.

🔧 Implementation Steps
1. Microsoft Entra Password Protection

Configured a custom banned password list (e.g.,widget, Cousera, ).
<img width="1081" height="520" alt="Screenshot 2025-10-03 152804" src="https://github.com/user-attachments/assets/0bbbfa6f-0ca7-47e4-ad2d-888e5be89297" />


Enforced password complexity rules across hybrid environment (on-premises AD + Entra ID).

Tested on a user "TestCouseraUser1@Cousera894.onmicrosoft.com" by attempting to reset passwords to banned values (blocked successfully).
    -Allowed all user to be able to reset their passwords
    <img width="1622" height="354" alt="Screenshot 2025-10-09 122642" src="https://github.com/user-attachments/assets/2cff2a00-7269-4bb8-a184-50a375ac1bac" />
    -Revoked the user session to log the user out of all session
    <img width="1007" height="379" alt="Screenshot 2025-10-09 123150" src="https://github.com/user-attachments/assets/82f6f5d9-2254-4657-ae8d-f8f58590d677" />
    -Tried to Reset the test user's password with the word  "Cousera, Widget"
    <img width="1239" height="583" alt="Screenshot 2025-10-09 125057" src="https://github.com/user-attachments/assets/b1e4a92a-8721-43d6-afb0-4a15ed59386d" /> <img width="597" height="239" alt="Screenshot 2025-10-09 124235" src="https://github.com/user-attachments/assets/1d6b8619-46d7-41b2-a506-fd4645fda042" />


    
    


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
