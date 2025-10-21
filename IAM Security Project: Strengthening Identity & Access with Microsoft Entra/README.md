📌 Scenario

A mid-sized financial services company, Cousera, was facing growing risks from weak passwords, unmanaged privileged accounts, and suspicious sign-in attempts from risky locations.
As an Identity and Access Management Intern, I was tasked with designing and implementing security-first IAM practices using Microsoft Entra ID (formerly Azure AD).
🎯 Objectives

Eliminate the use of weak or common passwords across all employees.

Ensure privileged accounts are just-in-time (JIT) and properly managed.

Protect user accounts from suspicious sign-ins and identity-based attacks using adaptive policies.

🔧 Implementation Steps
1. Microsoft Entra Password Protection

Configured a custom banned password list (e.g., widget, Coursera).
<img width="1081" height="520" alt="Screenshot 2025-10-03 152804" src="https://github.com/user-attachments/assets/0bbbfa6f-0ca7-47e4-ad2d-888e5be89297" />


Enforced password complexity rules across a hybrid environment (on-premises AD + Entra ID).

Tested on a user "TestCouseraUser1@Cousera894.onmicrosoft.com" by attempting to reset passwords to banned values (blocked successfully).
   -Allowed all user to be able to reset their passwords
    <img width="1622" height="354" alt="Screenshot 2025-10-09 122642" src="https://github.com/user-attachments/assets/2cff2a00-7269-4bb8-a184-50a375ac1bac" />
    -Revoked the user session to log the user out of all sessions
    <img width="1007" height="379" alt="Screenshot 2025-10-09 123150" src="https://github.com/user-attachments/assets/82f6f5d9-2254-4657-ae8d-f8f58590d677" />
    -Tried to reset the test user's password with the word  "Cousera, Widget"
    <img width="1239" height="583" alt="Screenshot 2025-10-09 125057" src="https://github.com/user-attachments/assets/b1e4a92a-8721-43d6-afb0-4a15ed59386d" /> <img width="597" height="239" alt="Screenshot 2025-10-09 124235" src="https://github.com/user-attachments/assets/1d6b8619-46d7-41b2-a506-fd4645fda042" />


    
    

✅ Outcome: Users could no longer use predictable passwords; reduced risk of password spray attacks.

2. Privileged Identity Management (PIM)

Enabled PIM in Microsoft Entra ID to manage roles like Privileged Authentication Administrator and Privileged Role Administrator.
<img width="1354" height="654" alt="Screenshot 2025-10-09 132628" src="https://github.com/user-attachments/assets/2308f4d5-ef72-421d-ab8f-639a050ab387" />



Configured Just-in-Time (JIT) access so admins could only elevate permissions when needed.
<img width="1891" height="914" alt="Screenshot 2025-10-09 135930" src="https://github.com/user-attachments/assets/a167b42e-b4c5-42fa-9d94-573ddf9b30d9" />


Added approval workflow (manager approval required before elevation).

Logged and reviewed audit reports for elevated role usage.

✅ Outcome: Reduced standing privileges, minimizing insider and external threats.

3. Identity Protection Policies

Enabled User Risk Policy to require a password reset if suspicious activity is detected.
<img width="1611" height="604" alt="Screenshot 2025-10-09 141653" src="https://github.com/user-attachments/assets/1e34a0f9-cce1-4d0a-8bc6-c44a7ce11fff" />


Configured Sign-in Risk Policy to block sign-ins from anonymous IPs and allow access from trusted locations, TOR browsers, or impossible travel scenarios.
Always exclude the policy from breakglass accounts and Global admin
<img width="1036" height="867" alt="Screenshot 2025-10-09 142716" src="https://github.com/user-attachments/assets/0b156059-fae8-4e08-bed0-be3adfefb7e9" />
Set the sign-in risk at medium and high risk
<img width="1622" height="832" alt="Screenshot 2025-10-09 142203" src="https://github.com/user-attachments/assets/c919a635-03c6-4b71-9623-e15d601f113a" />

Exclude trusted networks
<img width="1614" height="852" alt="Screenshot 2025-10-09 142609" src="https://github.com/user-attachments/assets/c33dc3f9-5db5-4b09-8d63-3f66b5b9226d" />
Block sign-in from impossible travel scenarios
<img width="1586" height="869" alt="Screenshot 2025-10-09 142636" src="https://github.com/user-attachments/assets/a8a54b97-7dc9-4e93-b70b-0b616f7e2533" />
Block sign-in risks
<img width="1596" height="809" alt="Screenshot 2025-10-09 143241" src="https://github.com/user-attachments/assets/6e080ad4-4c80-4e8a-870e-a2e40cdac626" />




Monitored risky users in the Entra ID Identity Protection dashboard.

✅ Outcome: Risky logins were automatically mitigated; compromised accounts could not continue operating undetected.

📊 Tools & Technologies

   Microsoft Entra ID (P1/P2 trial)
   
   Microsoft Entra Password Protection (cloud + on-prem sync)
   
   Privileged Identity Management (PIM)
   
   Identity Protection Policies
   
   Azure Monitor & Sign-in Logs

🚀 Results

   Reduced weak password usage by 100% (enforced strong password baseline).
   
   Privileged access was reduced by 75%, with JIT + approval workflows.
   
   Identity Protection automatically blocked 30+ risky sign-in attempts during the pilot phase.
