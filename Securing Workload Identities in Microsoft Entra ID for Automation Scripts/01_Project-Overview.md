### Scenario-Based Project: Securing Workload Identities in Microsoft Entra ID for Automation Scripts

#### Project Overview 
The project assumes basic familiarity with Microsoft Entra ID (formerly Azure AD) and PowerShell. You'll need admin access to your Microsoft 365 tenant and a Microsoft Entra Workload ID Premium license (or start a 90-day trial—I'll guide you on that).

#### Project Scenario: Your Company Task
As a Systems Administrator at TechSolutions, a mid-sized IT consulting firm with 200 employees. My company uses Microsoft 365 for email, Teams, and SharePoint, and I've been running automated PowerShell scripts to generate daily reports (e.g., extracting user activity data from Microsoft Graph and saving it to a CSV for management review). These scripts use service principals (app registrations) for authentication, but recently, my CTO flagged a security audit finding: These principals could be accessed from anywhere, posing risks like unauthorized data exfiltration if credentials are compromised—especially in this era, where cyber threats like phishing are on the rise.

**My Task Assignment:** During a Monday morning team meeting (it's February 22, 2026, around 5 PM WAT when I'm wrapping up), my manager emails me, "Gbemiga, we need to lock down our automation scripts. Implement Conditional Access policies to restrict service principal access to only our trusted office server in the Organization (IP: [my actual public IP, e.g., from whatismyip.com]). Start with our high-risk reporting app, then scale it using tags for others. Test thoroughly to avoid breaking reports, and document it for the team. Deadline: End of week."


