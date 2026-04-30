
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
   
   <div >
    <img width="480" alt="Screenshot 2026-02-24 151936" src="https://github.com/user-attachments/assets/2a5838e6-3c98-429c-b3c1-283703107fc1" />
   </div>  

4. **Create or Identify a Service Principal (App Registration)**  
   - If you don't have one: Go to **Entra ID** > **App registrations** > **+ New registration**.  
   - Name: "Daily Report Automation".  
   - Supported account types: "Accounts in this organizational directory only."  
   - Register. Note the Application (client) ID and Tenant ID.  
   - Add a client secret: **Certificates & secrets** > **+ New client secret** (expires in 1 year—set a reminder).  
   - Grant permissions: **API permissions** > **+ Add a permission** > Microsoft Graph > Application permissions (e.g., Reports.Read.All for reading data). Admin consent required.  
   - Why include this? It's foundational; skipping could mean testing with a non-functional app, derailing the project.

    📸 Screenshots

   <div>
      <img width="350"  alt="Screenshot 2026-02-24 153504" src="https://github.com/user-attachments/assets/d3967274-6a18-4b3c-82e6-add9086c582d" />
      <img width="350"  alt="Screenshot 2026-02-24 153811" src="https://github.com/user-attachments/assets/76c39a1b-0859-4479-a029-e8f23d5433fa" />
      <img width="350"  alt="Screenshot 2026-02-24 154157" src="https://github.com/user-attachments/assets/58451397-b411-473e-bdc8-fef8519d7eb1" />
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

   📸 Screenshot

     <div>
      <img width="450"  alt="Screenshot 2026-02-24 172336" src="https://github.com/user-attachments/assets/61977876-08d1-41d0-992f-e194f18fb6ad" />
      <img width="450" alt="Screenshot 2026-02-24 172537" src="https://github.com/user-attachments/assets/f3d1c6ed-3d22-4a23-a8e0-df31015a9133" />
      <img width="450"  alt="Screenshot 2026-02-24 173136" src="https://github.com/user-attachments/assets/5d099fdf-0e4b-49bf-903a-fcf37303d38c" />
     </div>  


#### Phase 2: Enhance with Custom Security Attributes (Scalability Extension)
As discussed, tags make this enterprise-ready for TechSolutions growing automations.

1. **Define Custom Attributes**  
   - Entra ID > **Custom security attributes** > **Attribute sets** > **+ Add attribute set**. Name: "AutomationSecurityTags".  
   - Add attributes:  
     - Name: "RiskLevel", Type: String, Predefined values: High, Medium, Low.  
   - Assign roles if needed (e.g., grant yourself Attribute Assignment Admin).

2. **Tag Your Service Principals**  
   - Entra ID > **Enterprise applications** > Find your app > **Properties** > **Custom security attributes** > **+ Add assignment**.  
   - Set RiskLevel = High, RestrictLocation = Yes.  
   - For bulk (relevant for multiple scripts): Use PowerShell—install the Microsoft.Graph module, then:  
     ```pwsh
     Connect-MgGraph -Scopes "Application.ReadWrite.All", "CustomSecAttributeAssignment.ReadWrite.All"
                                                                         #(name of your app)
      $servicePrincipal = (Get-MgServicePrincipal -Filter "displayName eq 'oauth-partner-app'").Id
      
      $customSecurityAttributes = @{
          AutomationSecurityTags = @{
              "@odata.type" = "#Microsoft.DirectoryServices.CustomSecurityAttributeValue"
              RiskLevel           = "High"         
              RestrictLocation = "Yes"           
          }
      }
      
      Update-MgServicePrincipal `
          -ServicePrincipalId $servicePrincipal `
          -CustomSecurityAttributes $customSecurityAttributes
     ```

     📸 Screenshots

     <div>
      <img width="450"  alt="Screenshot 2026-02-26 121753" src="https://github.com/user-attachments/assets/5a9c201a-68de-4b45-bc62-952f8995ade6" />
      <img width="450"  alt="Screenshot 2026-02-26 124420" src="https://github.com/user-attachments/assets/89e0042f-80b5-4282-914d-c8f41213b491" />
      <img width="450" alt="Screenshot 2026-03-12 172133" src="https://github.com/user-attachments/assets/e3359938-0652-4ec8-bc6a-40025c506363" />
      <img width="450" alt="Screenshot 2026-03-12 173712" src="https://github.com/user-attachments/assets/4207e37b-2070-40c4-9eef-37fe7fc3d96e" />
     <img width="450" alt="Screenshot 2026-02-26 125703" src="https://github.com/user-attachments/assets/3d9f8717-2968-44a8-a873-9fefd80ee21c" />
     </div> 
      
3. **Update CA Policy with Filters**  
   - Edit your policy: Under Workload identities, select all service principals that the filter will apply to and add a filter.  
   - Filter: AttributeSet = AutomationSecurityTags, Attribute = RiskLevel, Equals "High".  
   - This dynamically applies the IP block to tagged apps—add more without editing the policy.

   📸 Screenshots

   <div>
   <img width="480"  alt="Screenshot 2026-03-12 175446" src="https://github.com/user-attachments/assets/21c73425-ca88-4449-8054-1d6c239e7839" />
   <img width="480"  alt="Screenshot 2026-03-12 175735" src="https://github.com/user-attachments/assets/7ebec007-89fd-4710-8b94-d352f53525c6" />
   </div>
   
#### Phase 3: Testing and Validation (Critical for Success)

1. **Simulate Access**  
   - From trusted IP: Run your script (e.g., PowerShell with Connect-MgGraph -ClientId <ID> -TenantId <ID> -ClientSecret <Secret>). It should succeed.  
   - From untrusted IP (e.g., home tethering): Attempt access—expect failure (check script errors).

2. **Review Logs**  
   - Entra ID > **Monitoring** > **Sign-in logs** > Filter by Workload identities, your app. Look for "Conditional Access" status (Blocked or Success).  
   - Export to CSV for auditing—useful for your CTO's review.

3. **Enforce and Monitor**  
   - Switch policy to **On**. Re-test. Set up alerts: Entra ID > **Identity Protection** > **Risky sign-ins** (integrate with email/Slack for Lagos team notifications).
