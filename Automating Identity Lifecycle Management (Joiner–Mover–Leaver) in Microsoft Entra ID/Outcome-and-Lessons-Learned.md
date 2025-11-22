# Project Outcome & Lessons Learned  
**Entra ID Lifecycle Workflows – Joiner/Mover/Leaver Lab (Completed 22 November 2025)**

### ✅ Final Outcome – 100% Working
- Pre-hire Joiners are created disabled with employeeHireDate populated  
- On hire date the built-in “Onboard pre-hire employee” workflow runs automatically  
- Account is enabled  
- Temporary Access Pass (TAP) is generated and emailed to the user’s manager  
- Welcome email is sent to the new user  
- Licenses and groups are assigned successfully  
- All tasks complete with green checkmarks

### 🧠 Key Lessons Learned
1. Joiners must be created with AccountEnabled = $false when employeeHireDate exists  
2. The manager attribute cannot be set via normal Graph cmdlets (Set-MgUserManagerByRef) on disabled accounts – only the portal or direct Invoke-MgGraphRequest works  
3. The manager must have an Exchange Online mailbox (or at least a valid mail attribute) to receive the TAP email  
4. The new user must have the mail attribute (or proxyAddresses) populated for the welcome email to send  
5. UsageLocation must be a valid two-letter ISO code in PowerShell – NG works perfectly for Nigeria (not “Nigeria” or “NGA”)  
6. Tasks later in the workflow are automatically cancelled if an earlier task fails (e.g. TAP fails → everything after is cancelled)  
7. Splatting (@params) is far more reliable than positional parameters with New-MgUser  
8. Manual assignment of managers in the portal is the fastest workaround for disabled accounts in a lab environment  

