
### Step 1: Set Up Active Directory on Azure VM
Active Directory (AD) is Microsoft's directory service for managing users, computers, and permissions in a network. Here, I'll create a Domain Controller (DC) on an Azure VM to host my AD forest. This acts as the "identity provider" for CyberArk.

#### Substep 1.1: Create Azure Resources
- Log into the Azure Portal (portal.azure.com).
- Create a **Resource Group**: Search for "Resource groups" > Create > Name it (e.g., "CyberArkLab-RG") > Choose a region (e.g., East US) > Review + create.
- Create a **Virtual Network (VNet)**: Search for "Virtual networks" > Create > Basics: Use your resource group, name it (e.g., "CyberArkLab-VNet"), region same as above. Address space: 10.0.0.0/16. Subnet: Name "default", address range 10.0.0.0/24 > Review + create.
- Create the DC VM:
  - Search for "Virtual machines" > Create > Azure virtual machine.
  - Basics: Resource group (your RG), VM name (e.g., "DC-1"), Region (same), Availability options: Availability set or zone for redundancy (use zone 1 for simplicity).
  - Image: Windows Server 2022 Datacenter - Gen2 (or 2019 if preferred).
  - Size: Standard_D2s_v3 (2 vCPUs, 8 GiB RAM—affordable for lab).
  - Administrator account: Set a username (e.g., "localadmin") and a strong password.
  - Inbound ports: Allow RDP (3389) for now (secure later with NSG).
  - Disks: OS disk default; add a data disk (e.g., 128 GiB Standard SSD) for AD databases (NTDS/SYSVOL)—best practice to separate from OS.
  - Networking: Use your VNet and subnet. Assign a static private IP (e.g., 10.0.0.4) under NIC network interface > IP configurations.
  - Management: Enable boot diagnostics.
  - Review + create > Create. Wait 5–10 minutes for deployment.

#### Substep 1.2: Configure the VM and Promote to Domain Controller
- RDP into the VM: In Azure Portal > Your VM > Connect > RDP > Download RDP file > Connect using localadmin credentials.
- Set a static IP inside the VM (matches Azure setting):
  - Open PowerShell as admin: `Set-NetIPAddress -InterfaceAlias "Ethernet" -IPAddress 10.0.0.4 -PrefixLength 24 -DefaultGateway 10.0.0.1`
  - Set DNS: `Set-DnsClientServerAddress -InterfaceAlias "Ethernet" -ServerAddresses 127.0.0.1` (points to itself after promotion).
- Install AD DS Role:
  - Open Server Manager (starts automatically).
  - Dashboard > Quick Start > Add roles and features.
  - Select "Role-based or feature-based installation" > Next.
  - Server: Your server > Next.
  - Server Roles: Check "Active Directory Domain Services" > Add features when prompted > Next all the way > Install.
- Promote to DC:
  - After install, Server Manager notification > "Promote this server to a domain controller."
  - Deployment: "Add a new forest" > Root domain name (e.g., "mydomain.com") > Next.
  - Domain Controller Options: Forest/Domain functional level (default), set DSRM password (strong, remember it) > Next.
  - DNS Options: Ignore warnings > Next.
  - Paths: Use your data disk (e.g., change to E:\ for NTDS, Logs, SYSVOL if attached as E:) > Next.
  - Review > Next > Install. Reboot takes 5–10 minutes.
- Post-Promotion:
  - Log in as mydomain.com\localadmin (domain credentials now).
  - Open Active Directory Users and Computers (search in Start): Create a new user (e.g., right-click Users > New > User > Name: "brad" > Set password, uncheck "User must change password").
  - Add brad to "Domain Admins" group (double-click Domain Admins > Members > Add).

#### Substep 1.3: Set Up a Connector Server VM (for Redundancy and Best Practice)
The video installs the Identity Connector on two Windows servers for redundancy. These should be domain-joined members (not the DC itself, to avoid single point of failure). Create one or two additional VMs.

- Repeat VM creation (similar to DC, but name e.g., "Connector-1", Windows Server 2022, same VNet/subnet, static IP e.g., 10.0.0.5).
- RDP in, join to domain:
  - Settings > System > About > Rename this PC (advanced) > Change > Domain: mydomain.com > OK > Credentials: mydomain.com\brad > Reboot.
- For a second connector ("Connector-2", IP 10.0.0.6), repeat.

Now your AD is ready: You have a DC and connector server(s) in the domain.

#### Security Updates
- Create a Network Security Group (NSG): Azure Portal > Network security groups > Create > Associate to your subnet or VMs. Allow RDP only from your IP.
- Enable Azure Firewall or Just-In-Time access for RDP.
- Ensure VMs have outbound internet (default in Azure) for connector to reach Privilege Cloud.

### Step 2: Configure CyberArk Privilege Cloud (Following Video with Updates)
Now follow the video, but with added context and fills for gaps. Watch the video alongside for visuals.

#### Substep 2.1: Initial Login (Video: 1:21)
- Use your initial Privilege Cloud credentials (e.g., firstname_lastname@yourcloud.cloud).
- Recover password via SMS/email if needed. Concept: This is your bootstrap admin account.

#### Substep 2.2: Authentication Profile and Secured Zones (Video: 2:28–3:20)
- In Privilege Cloud portal: Identity Administration > Authentication > Create profile.
- Select methods: Password, Mobile Authenticator, OTP, FIDO2 (avoid SMS/email for security).
- Secured Zones: Network > Secured Zones > Add your Azure VNet IPs (e.g., 10.0.0.0/24) to restrict access.

#### Substep 2.3: Policies (Video: 3:20)
- Policies > New policy set for admins.
- Include roles: System Administrator, Privilege Cloud roles.
- Enable: Workforce password mgmt, number matching for pushes, OTP for apps like Google Authenticator, FIDO2.
- Disable: Security questions, SMS/email (do this early to enforce security).

#### Substep 2.4: User Portal and Test Authentication (Video: 7:22–8:08)
- Access User Portal to set up MFA offline (OTP via QR, FIDO2 key).
- Test login with initial account.

#### Substep 2.5: Install Identity Connector (Video: 8:46) – Updated with Your Azure Setup
- Download connector from portal: Connectors > Add Connector > Download.
- Install on your Connector-1 VM (RDP in as domain admin).
  - Reset installer user password in portal (Users > Service Users > Installer User – resets every 24h, no special chars).
  - Run installer: Extract, setup.exe, enter installer creds.
  - Enable AD Deleted Objects access: In AD Users and Computers on DC > View > Advanced Features > CN=Deleted Objects > Properties > Security > Add Connector-1 computer account > Read permissions.
  - Network test: Ensure outbound HTTPS to Privilege Cloud (ports 443, etc.—Azure allows by default).
- Register in portal under Network. Repeat for Connector-2 if using.
- Gap Fill: The video doesn't detail user sync. For auto-sync, configure in portal: Identity Administration > Directories > Add Directory > Active Directory > Use your connector > Map attributes (default) > Sync groups if needed.

#### Substep 2.6: Add AD User to Roles and Test (Video: 12:17–14:23)
- Add your AD user (e.g., brad@mydomain.com) to Privilege Cloud Administrators and System Administrator roles.
- Test login in incognito: Use AD creds + MFA.
- Set up additional MFA in User Portal.
- Remove SMS/email from auth profile.
- Final test: Only secure MFA works.

### Step 3: Testing and Verification
- Log in as AD user to Privilege Cloud.
- Simulate failure: Stop one connector VM—login should still work via redundancy.
- Check logs: In Privilege Cloud > Monitoring > Audit logs.
- Concept Check: Understand how the connector bridges AD to cloud (LDAP queries, auth forwarding).

### Step 4: Cleanup and Extensions
- Shut down/delete Azure resources to avoid costs (Portal > Resource Group > Delete).
