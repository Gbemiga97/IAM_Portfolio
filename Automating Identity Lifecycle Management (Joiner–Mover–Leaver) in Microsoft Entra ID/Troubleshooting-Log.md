# Troubleshooting Log – Entra ID Lifecycle Workflows Lab  
**Project:** Successful automation of Joiner/Mover/Leaver using Lifecycle Workflows  
**Completed:** 22 November 2025  
**Tenant:** Cousera669.onmicrosoft.com 

---

### Issue 1 – New-MgUser fails with positional parameter errors
**Symptom:**  
`A positional parameter cannot be found that accepts argument 'True/False'`

**Root Cause:**  
Outdated positional syntax in New-MgUser + old Microsoft.Graph module

**Solution Applied:**  
Switched entirely to splatting (@params) – all parameters explicitly named  
Updated module: `Update-Module Microsoft.Graph -Scope CurrentUser`

**Verification:**  
All users created successfully with consistent output colors (Green = enabled, Red = disabled)
 
---

### Issue 2 – Joiners remain disabled forever – workflow never triggers
**Root Cause:**  
employeeHireDate was missing or in wrong format / trigger condition not met

**Solution Applied:**  
Ensured employeeHireDate populated in YYYY-MM-DD format and ≤ current date  
Used built-in “Onboard pre-hire employee” template with time-based trigger on employeeHireDate

**Verification:**  
Workflow runs automatically or on-demand and successfully enables the account

---

### Issue 3 – “manager attribute is missing or invalid” → Generate TAP task fails
**Root Cause:**  
Manager cannot be assigned via Set-MgUserManagerByRef on disabled accounts (Entra ID restriction)

**Solutions Tested & Final Fix:**  
- Set-MgUserManagerByRef → fails on disabled accounts  
- Invoke-MgGraphRequest direct PUT → inconsistent success  
- **Final working method:** Manual assignment via Entra ID portal (works 100% on disabled accounts)

**Verification:**  
Manager field populated on disabled Joiner accounts → TAP task completes

---

### Issue 4 – TAP email never arrives at manager
**Root Cause:**  
Manager account had no Exchange Online mailbox / mail attribute empty

**Solution Applied:**  
Assigned Exchange Online Plan 1/2 license to HR Manager → mailbox provisioned  
(or at minimum populated mail attribute with valid address)

**Verification:**  
TAP email received in manager’s inbox within seconds

---

### Issue 5 – Welcome email fails: “the mail attribute was missing for all of the provided email recipients”
**Root Cause:**  
New user had no mail or proxyAddresses attribute set

**Solution Applied:**  
Ensured mail attribute = UPN during creation (or added proxyAddresses: SMTP:UPN)

**Verification:**  
Welcome email successfully delivered to new hire

---

### Issue 6 – UsageLocation error
**Root Cause:**  
UsageLocation set to “Nigeria” instead of valid ISO 3166-1 alpha-2 code

**Solution Applied:**  
Changed UsageLocation = "NG" in all scripts

**Verification:**  
UsageLocation = "NG"

---

### Issue 7 – Subsequent tasks cancelled (Add to groups, Assign licenses, etc.)
**Root Cause:**  
Cascade cancellation when any earlier task fails (especially Generate TAP)

**Solution Applied:**  
Fixed root cause (manager + mail attributes) → no more early failures

**Verification:**  
Entire workflow chain completes with green checkmarks:
- Enable User Account → Completed  
- Generate TAP and Send Email → Completed  
- Send Welcome email → Completed  
- Add user to groups → Completed  
- Assign licenses to user → Completed

---

### Final Working Configuration Summary
| Component                  | Value / Setting                          | Notes                                   |
|----------------------------|------------------------------------------|-----------------------------------------|
| UsageLocation              | NG                                       | ISO code for Nigeria                    |
| Joiner detection           | employeeHireDate exists → AccountEnabled = $false | Correct                                  |
| Manager assignment (lab)   | Manual via Entra portal                  | Only reliable method for disabled users |
| Manager mailbox            | Exchange Online license assigned         | Required for TAP delivery               |
| User mail attribute        | Set to UPN                               | Required for welcome email              |
| Workflow template used     | Onboard pre-hire employee , Employee job profile change, Offboard an employee               | Built-in, reliable                      |

**Final Result:** Full end-to-end green workflow for pre-hire Joiners,   
**Status:** 100% functional and demonstrable
