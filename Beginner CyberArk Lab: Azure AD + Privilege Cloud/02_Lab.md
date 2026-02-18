
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
   
   📸 Screenshots of configurations
   
   <div>
      <img width="200" height="425" alt="Screenshot 2026-02-17 184614" src="https://github.com/user-attachments/assets/54b8b3e6-3333-43dc-95cb-4fd8f288c175" />
      <img width="200" height="428" alt="Screenshot 2026-02-17 185348" src="https://github.com/user-attachments/assets/f318f2d4-568f-439c-83b8-8f2f6400815b" />
      <img width="200" height="429" alt="Screenshot 2026-02-17 185517" src="https://github.com/user-attachments/assets/97910112-7430-40b5-8edf-1ed8bd0a146a" />
      <img width="200" height="426" alt="Screenshot 2026-02-17 185615" src="https://github.com/user-attachments/assets/9c720c71-3999-4009-aa39-296cc0ae48b1" />
      <img width="200" height="603" alt="Screenshot 2026-02-17 185551" src="https://github.com/user-attachments/assets/f3619a79-f8cb-4ba4-82f5-ebbd95df68a2" />
       <img width="200" height="434" alt="Screenshot 2026-02-17 185637" src="https://github.com/user-attachments/assets/dc0ba4b6-7d6b-4256-88a3-ad28938f5d85" />
      <img width="200" height="462" alt="Screenshot 2026-02-17 185744" src="https://github.com/user-attachments/assets/68e90108-2947-4159-9191-f34f9a14c091" />
      <img width="200" height="519" alt="Screenshot 2026-02-17 191948" src="https://github.com/user-attachments/assets/40f16aea-586d-430f-b726-7b38f9a9f237" />
   </div>

#### Substep 1.3: Configure Networking Inside the VM
- After install, log in.
- Set static IP (recommended for DC):
  - Right-click Start → Network Connections → Ethernet → Properties → IPv4 → Use static IP.
    - Example (adjust to your Virtual Network Editor):
      - IP: 192.168.1.50 (or whatever fits your editor's range).
      - Subnet: 255.255.255.0
      - Gateway: Your router IP (e.g., 192.168.1.1)
      - DNS: 192.168.1.50 (point to itself).
- Rename computer: Settings → System → About → Rename this PC → e.g., "DC-01" → Restart.

📸 Screenshots of configurations

<div>
   <img width="260" height="487" alt="Screenshot 2026-02-18 110044" src="https://github.com/user-attachments/assets/2b2cd1bb-5aff-4c0c-ab57-8ea5f878de1f" />
   <img width="260" height="557" alt="Screenshot 2026-02-18 110131" src="https://github.com/user-attachments/assets/697db96e-9126-40d2-902a-9d28931f45f7" />
   <img width="260" height="584" alt="Screenshot 2026-02-18 110504" src="https://github.com/user-attachments/assets/ab01a8ff-1424-4943-9ba5-30fb41a2174b" />
   <img width="260" height="627" alt="Screenshot 2026-02-18 111831" src="https://github.com/user-attachments/assets/9346e8ae-ac21-426d-8882-6e3496d8a086" />
   <img width="260" height="703" alt="Screenshot 2026-02-18 111028" src="https://github.com/user-attachments/assets/f5b8c9e6-d891-4564-9bf8-74dce97468cc" />
</div>

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

📸 Screenshots of configurations

<div>
   <img width="320" height="562" alt="Screenshot 2026-02-18 113304" src="https://github.com/user-attachments/assets/bd4f841f-f856-43f6-84df-5945db4bc1c8" />
   <img width="320" height="718" alt="Screenshot 2026-02-18 114558" src="https://github.com/user-attachments/assets/ed69aadb-8841-4ec5-9283-8d8ce2b0c615" />
   <img width="320" height="462" alt="Screenshot 2026-02-18 114639" src="https://github.com/user-attachments/assets/7fe172cc-a969-4e7b-8334-5e0f96767d10" />
   <img width="320" height="559" alt="Screenshot 2026-02-18 114806" src="https://github.com/user-attachments/assets/a9e9cddb-7e6f-4f0e-a98c-e8baa5ec5e18" />
   <img width="320" height="562" alt="Screenshot 2026-02-18 114852" src="https://github.com/user-attachments/assets/7977bbf0-6f7f-4f67-966d-f9b70e380306" />
   <img width="320" height="561" alt="Screenshot 2026-02-18 115003" src="https://github.com/user-attachments/assets/d01a648d-1057-4db2-9e10-202ff720ed51" />
   <img width="320" height="500" alt="Screenshot 2026-02-18 115453" src="https://github.com/user-attachments/assets/5fe49182-12c5-4d56-8dac-131dd56fa099" />
   <img width="320" height="491" alt="Screenshot 2026-02-18 120939" src="https://github.com/user-attachments/assets/6aa5896a-29bf-4195-abe8-b24b9c0839a2" />
   <img width="320" height="524" alt="Screenshot 2026-02-18 121410" src="https://github.com/user-attachments/assets/d8b640ef-5e66-4733-9add-652d59d0bef9" />

</div>

#### Substep 1.5: Create Connector Server VM(s)
- Repeat VM creation process (name e.g., "Connector-01/CS-01").
- Specs: 2 GB RAM, 1 cores, Bridged network.
- Install Windows Server (same ISO).
- Join to domain:
  - After install → System → About → Rename this PC (advanced) → Change → Domain: mylab.local → Use domain admin creds → Reboot.
- Create a second one ("Connector-02") for redundancy (highly recommended; CyberArk docs suggest at least two).

**Networking Tip**: All VMs on Bridged get IPs from your host network (e.g., 192.168.1.x). Ensure they can reach the internet (test ping google.com). The Identity Connector needs outbound internet only—no ports open inbound.

📸 Screenshots of configurations

<div>
   <img width="200" height="432" alt="Screenshot 2026-02-18 124129" src="https://github.com/user-attachments/assets/d90ce087-f3b6-45c7-b471-388073d2fbf1" />
   <img width="200" height="620" alt="Screenshot 2026-02-18 131751" src="https://github.com/user-attachments/assets/fe1543df-72a4-436a-b763-c232c683b73f" />
    <img width="200" height="270" alt="Screenshot 2026-02-18 152221" src="https://github.com/user-attachments/assets/3c52436a-ea96-480f-a677-f1ea6ae33587" />

   <img width="200" height="615" alt="Screenshot 2026-02-18 135213" src="https://github.com/user-attachments/assets/4ff18996-a6ba-4a93-b771-5c08f049a290" />
   <img width="200" height="251" alt="Screenshot 2026-02-18 140401" src="https://github.com/user-attachments/assets/162087d4-5e51-4736-8bc4-2e808b0cb8fd" />

   <img width="200" height="558" alt="Screenshot 2026-02-18 141414" src="https://github.com/user-attachments/assets/75bef66d-b481-46a2-907c-c7002d5c1f5c" />
   <img width="200" height="559" alt="Screenshot 2026-02-18 142002" src="https://github.com/user-attachments/assets/dd9a8622-46af-46fa-aba1-08e31e9a4623" />
   <img width="200" height="551" alt="Screenshot 2026-02-18 142109" src="https://github.com/user-attachments/assets/9836c422-b5ef-41cb-a2fb-d431efb44ec3" />
   <img width="200" height="426" alt="Screenshot 2026-02-18 145445" src="https://github.com/user-attachments/assets/5334d6b7-15e5-47d5-a330-3829ea4d7db3" />
   <img width="200" height="432" alt="Screenshot 2026-02-18 145501" src="https://github.com/user-attachments/assets/6e7a1899-9e8f-4994-aa1b-9a62cb298f23" />
   <img width="200" height="426" alt="Screenshot 2026-02-18 145445" src="https://github.com/user-attachments/assets/dc56f322-85b3-49d1-ae72-029ef3276857" />
<img width="200" height="432" alt="Screenshot 2026-02-18 145501" src="https://github.com/user-attachments/assets/044ba0ae-a565-456e-a46e-b3a7da1ab3fe" />
<img width="200" height="627" alt="Screenshot 2026-02-18 152133" src="https://github.com/user-attachments/assets/aa52cfdd-8982-4456-a40f-c93e0a6bccc1" />
<img width="200" height="259" alt="Screenshot 2026-02-18 152234" src="https://github.com/user-attachments/assets/52aea113-224f-4eac-a0d3-8a823f78a18c" />
<img width="200" height="568" alt="Screenshot 2026-02-18 153138" src="https://github.com/user-attachments/assets/49d9eb43-ef8b-436e-afeb-70bcac1a9c13" />
<img width="200" height="460" alt="Screenshot 2026-02-18 153233" src="https://github.com/user-attachments/assets/3baa8637-1dfb-4d94-b75a-1b5c8492d7f9" />
<img width="200" height="463" alt="Screenshot 2026-02-18 153324" src="https://github.com/user-attachments/assets/a085f2e1-3d35-4c2e-84b6-6e03ed003f91" />
<img width="200" height="560" alt="Screenshot 2026-02-18 153905" src="https://github.com/user-attachments/assets/f0a65b70-d6f7-4cef-8edc-efa56bb61f7d" />
<img width="200" height="559" alt="Screenshot 2026-02-18 154408" src="https://github.com/user-attachments/assets/ed6aadad-47e2-4866-b017-c95ba0dc7700" />
<img width="200" height="558" alt="Screenshot 2026-02-18 154847" src="https://github.com/user-attachments/assets/5c686ccd-a8b5-42ac-8c98-53a968e694c7" />
</div>

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
