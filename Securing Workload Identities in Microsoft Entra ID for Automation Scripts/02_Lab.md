
#### Project Objectives
- Secure at least one service principal with IP-based restrictions via Entra ID Conditional Access (CA).
- Use custom security attributes for scalable tagging and dynamic policy application.
- Validate and monitor to ensure no production impact.
- Document for knowledge sharing (e.g., for my team).


1. **Verify Licensing**  
   - Log in to the Microsoft Entra admin center (entra.microsoft.com).  
   - Go to **Billing** > **Licenses** > **All products**. Search for "Microsoft Entra Workload ID Premium" (part of Entra ID P2 or standalone).  
   - If not available: Start a trial via **Purchase services** or contact Microsoft support. Why relevant? Without this, I can't target workload identities in CA policies—skipping this could waste time troubleshooting.

2. **Set Up a Trusted Named Location**  
   - In Entra ID: **Protection** > **Conditional Access** > **Named locations**.  
   - Click **+ IP ranges location**. Name it " TechSolutions Office Server" (or "Sensitive App Server").  
   - Add your trusted IP (e.g., your office's public IPv4 address—use a tool like ipinfo.io to confirm). For ranges, enter CIDR notation (e.g., 192.168.1.0/24).  
   - Save. This defines "trusted" access points, preventing blocks from variable home IPs.
  
      📸 Screenshot
   
      <div>
         <img width="480" height="602" alt="Screenshot 2026-02-24 151936" src="https://github.com/user-attachments/assets/2a5838e6-3c98-429c-b3c1-283703107fc1" />
      </div>

4. **Create or Identify a Service Principal (App Registration)**  
   - If you don't have one: Go to **Entra ID** > **App registrations** > **+ New registration**.  
   - Name: "Daily Report Automation".  
   - Supported account types: "Accounts in this organizational directory only."  
   - Register. Note the Application (client) ID and Tenant ID.  
   - Add a client secret: **Certificates & secrets** > **+ New client secret** (expires in 1 year—set a reminder).  
   - Grant permissions: **API permissions** > **+ Add a permission** > Microsoft Graph > Application permissions (e.g., Reports.Read.All for reading data). Admin consent required.  
   - Why include this? It's foundational; skipping could mean testing with a non-functional app, derailing the project.

    📸 Screenshot

   <div>
      <img width="320" height="426" alt="Screenshot 2026-02-24 153504" src="https://github.com/user-attachments/assets/d3967274-6a18-4b3c-82e6-add9086c582d" />
      <img width="320" height="545" alt="Screenshot 2026-02-24 153811" src="https://github.com/user-attachments/assets/76c39a1b-0859-4479-a029-e8f23d5433fa" />
      <img width="320" height="612" alt="Screenshot 2026-02-24 154157" src="https://github.com/user-attachments/assets/58451397-b411-473e-bdc8-fef8519d7eb1" />

   </div>

#### Phase 1: Implement Basic CA Policy
1. **Navigate to Conditional Access**  
   - Entra ID > **Protection** > **Conditional Access** > **Policies** > **+ Create new policy**.  
   - Name: "Restrict Automation Scripts to TechSolutions Office".

2. **Configure Assignments**  
   - **Users or workload identities**: Select **Workload identities** > Include specific ("Daily Report Automation" app).  
   - **Target resources**: All cloud apps.  
   - **Conditions** > **Locations**: Include all locations, then **Exclude** your "TechSolutions Office Server" named location. (This blocks everywhere except trusted IPs.)

3. **Set Access Controls**  
   - **Grant**: Block access.  

4. **Enable in Report-Only Mode**  
   - Set to **Report-only** initially. Save.  
   - Why? Allows monitoring without breaking your daily reports— testing here for success.

#### Phase 2: Enhance with Custom Security Attributes (Scalability Extension)
As discussed, tags make this enterprise-ready for TechSolutions growing automations.

1. **Define Custom Attributes**  
   - Entra ID > **Custom security attributes** > **Attribute sets** > **+ Add attribute set**. Name: "AutomationSecurityTags".  
   - Add attributes:  
     - Name: "RiskLevel", Type: String, Predefined values: High, Medium, Low.  
     - Name: "LocationRestriction", Type: Boolean (Yes/No).  
   - Assign roles if needed (e.g., grant yourself Attribute Assignment Admin).

2. **Tag Your Service Principals**  
   - Entra ID > **Enterprise applications** > Find your app > **Properties** > **Custom security attributes** > **+ Add assignment**.  
   - Set RiskLevel = High, LocationRestriction = Yes.  
   - For bulk (relevant for multiple scripts): Use PowerShell—install the Microsoft.Graph module, then:  
     ```
     Connect-MgGraph -Scopes "CustomSecAttributeAssignment.ReadWrite.All"
     $params = @{ AttributeSet = "AutomationSecurityTags"; Attribute = "RiskLevel"; Values = "High" }
     New-MgBetaServicePrincipalCustomSecurityAttributeAssignment -ServicePrincipalId <YourAppObjectId> -BodyParameter $params
     ```
 

3. **Update CA Policy with Filters**  
   - Edit your policy: Under Workload identities, switch to **All** and add a filter.  
   - Filter: AttributeSet = AutomationSecurityTags, Attribute = RiskLevel, Equals "High" AND LocationRestriction = Yes.  
   - This dynamically applies the IP block to tagged apps—add more without editing the policy.

#### Phase 3: Testing and Validation (Critical for Success)

1. **Simulate Access**  
   - From trusted IP: Run your script (e.g., PowerShell with Connect-MgGraph -ClientId <ID> -TenantId <ID> -ClientSecret <Secret>). It should succeed.  
   - From untrusted IP (e.g., home tethering): Attempt access—expect failure (check script errors).

2. **Review Logs**  
   - Entra ID > **Monitoring** > **Sign-in logs** > Filter by Workload identities, your app. Look for "Conditional Access" status (Blocked or Success).  
   - Export to CSV for auditing—useful for your CTO's review.

3. **Enforce and Monitor**  
   - Switch policy to **On**. Re-test. Set up alerts: Entra ID > **Identity Protection** > **Risky sign-ins** (integrate with email/Slack for Lagos team notifications).
