
### Step 1 – Set Up Active Directory on VMware Workstation

#### Substep 1.1: Prepare VMware Workstation
- Install VMware Workstation Pro/Player.
- Download Windows Server ISO: Go to Microsoft Evaluation Center (evaluation.microsoft.com) → Windows Server 2022 or 2025 (90-day eval is fine for lab; renew by re-installing if needed).
- Optional: Download a Windows 10/11 ISO for client testing later.

#### Substep 1.2: Create the Domain Controller VM
1. Open VMware Workstation → File → New Virtual Machine.
2. Choose **Typical (recommended)** → Next.
3. Installer disc image file (iso) → Browse to your Windows Server ISO → Next.
4. Guest operating system: Microsoft Windows → Version: Windows Server 2022 (or 2025 if using that) → Next.
5. Name the VM (e.g., "DC-01") and choose location (e.g., dedicated folder) → Next.
6. Disk: Create a new virtual disk → Maximum disk size: 60–100 GB (split into multiple files for easy move) → Next.
7. Customize Hardware (important!):
   - Memory: 4 GB (minimum; 6–8 GB better).
   - Processors: 2 cores.
   - Network Adapter: **Bridged** (connects to your physical network; VM gets IP from your router like any PC).
     - If you want isolation: Use **Host-only** (VMnet1 or custom) and configure NAT/shared internet later.
   - CD/DVD: Ensure connected to ISO.
   - USB Controller, Sound, etc.: Optional; disable if not needed to save resources.
8. Finish → Power on the VM.
9. Install Windows Server:
   - Follow prompts: Choose Standard Desktop Experience (GUI), set strong admin password.
   - After install: Update Windows fully (important for roles/features).

#### Substep 1.3: Configure Networking Inside the VM
- After install, log in.
- Set static IP (recommended for DC):
  - Right-click Start → Network Connections → Ethernet → Properties → IPv4 → Use static IP.
    - Example (adjust to your network):
      - IP: 192.168.1.50 (or whatever fits your router's range).
      - Subnet: 255.255.255.0
      - Gateway: Your router IP (e.g., 192.168.1.1)
      - DNS: 127.0.0.1 (point to itself; add 8.8.8.8 as secondary for internet during setup).
- Rename computer: Settings → System → About → Rename this PC → e.g., "DC-01" → Restart.

#### Substep 1.4: Promote to Domain Controller (Same as Before)
- Open Server Manager → Add roles and features → Role-based → Select server → Server Roles: Check **Active Directory Domain Services** → Add features → Install.
- After install: Notification flag → Promote this server to a domain controller.
- Deployment: Add a new forest → Root domain name: e.g., "mylab.local" (avoid .com/.net to prevent real-world conflicts).
- Set DSRM password.
- DNS options: Proceed despite warnings.
- Paths: Default or custom.
- Install → Reboot.
- Post-setup:
  - Log in as mylab.local\Administrator.
  - Open Active Directory Users and Computers → Create test user "brad" (strong password) → Add to Domain Admins.

#### Substep 1.5: Create Connector Server VM(s)
- Repeat VM creation process (name e.g., "Connector-01").
- Specs: 4 GB RAM, 2 cores, Bridged network.
- Install Windows Server (same ISO).
- Join to domain:
  - After install → System → About → Rename this PC (advanced) → Change → Domain: mylab.local → Use domain admin creds → Reboot.
- Create a second one ("Connector-02") for redundancy (highly recommended; CyberArk docs suggest at least two).

**Networking Tip**: All VMs on Bridged get IPs from your home router (e.g., 192.168.1.x). Ensure they can reach the internet (test ping google.com). The Identity Connector needs outbound internet only—no ports open inbound.

**Isolation Option**: If you prefer a fully isolated lab:
- Edit → Virtual Network Editor (run as admin) → Add Network → VMnet2 → Host-only → No DHCP (or enable).
- Set all VMs to Custom: VMnet2.
- For internet on connector VMs: Add a second NIC (Bridged) to connector VMs only, or share host internet via ICS (Internet Connection Sharing) on host.

### Step 2: CyberArk Privilege Cloud Configuration (No Major Changes)
- Follow the original project steps/video exactly.
- When installing Identity Connector:
  - Download from Privilege Cloud portal → Install on Connector-01 and Connector-02 VMs (run as domain admin).
  - Installer needs internet (HTTPS outbound).
  - Enable AD Deleted Objects access on DC (as before).
  - Register connectors in portal.
- User sync, policies, MFA, adding AD user (brad@mylab.local) to roles—all identical.
- Test login from your host browser (or a Windows client VM joined to domain).



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
