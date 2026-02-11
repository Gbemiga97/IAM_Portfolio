#### Project Tasks
Following the steps below, I will be implementing the solution in my Entra environment.  And also document my actions, any errors encountered, and resolutions in a project log.

1. **Enable Traffic Forwarding Profiles (Setup Phase)**
   - Log in to the Entra Admin Center (entra.microsoft.com).
   - Navigate to Global Secure Access > Connect > Traffic Forwarding.
   - Enable the "Microsoft 365 Traffic" profile to optimize routing for apps like Exchange, Teams, and SharePoint through the Microsoft Edge Network.
   - Enable the "Internet Access" profile to handle all other internet traffic.
   - Add custom bypass rules:
     - Bypass internal subnets (e.g., 10.0.0.0/24 for TechNova's on-premises servers).
     - Bypass specific FQDNs (e.g., internal.techova.com or a diagnostic site like ipchicken.com for testing).
   - Assign the profiles to your pilot group ("Remote Developers Pilot") or select "All users" for broader testing.
   - Expected Outcome: Traffic for Microsoft 365 is tunneled efficiently, while general internet traffic is routed for security checks. Allow 5-10 minutes for propagation.

      📸 Screenshots of configurations on Traffic Forwarding
      
      <div>
      <img width="420" height="608" alt="Screenshot 2026-02-10 145749" src="https://github.com/user-attachments/assets/9c19c7ff-9bed-40e0-aea1-d55ab808d7db" />
      <img width="420" height="613" alt="Screenshot 2026-02-10 150015" src="https://github.com/user-attachments/assets/20a1942a-9acf-4917-a050-5d38ee03af9d" />
      <img width="420" height="609" alt="Screenshot 2026-02-10 150050" src="https://github.com/user-attachments/assets/0c12159f-5896-4664-8756-3f00307c652f" />
      <img width="420" height="597" alt="Screenshot 2026-02-10 150922" src="https://github.com/user-attachments/assets/38e8dea1-9533-491d-8f25-87d88bf7ce01" />
      </div>

2. **Install and Verify the Global Secure Access Client (Device Phase)**
   - On your test Windows device, install the Global Secure Access client and restart the machine.
   - Open the client app and go to Advanced Diagnostics > Health to ensure all checks pass (e.g., no IPv4 preference issues; disable Quick Assist in Edge if needed).
   - In Diagnostics > Rules, confirm the "Microsoft 365" and "Internet Access" profiles are active.
   - Test bypass rules: Attempt to access a bypassed site (e.g., ipchicken.com). In Diagnostics > Traffic Logs, filter for the FQDN and verify it shows "bypass" status (not tunneled).
   - Test Microsoft traffic: Access Teams or SharePoint and check logs for "tunneled" via Microsoft 365 profile.
   - Troubleshooting: If health checks fail, review IPv4 settings or reinstall the client. For mobile devices (iOS/Android), ensure the client is installed via Intune or manual setup.

3. **Configure Web Content Filtering Policies (Security Phase)**
   - Go to Global Secure Access > Secure > Web Content Filtering > Web Content Filtering Policies.
   - Create a new policy named "TechNova Web Filter - Block Risky Categories."
     - Set action to "Block."
     - Add rules: Select predefined categories like "Weapons," "Gambling," "Alcohol and Tobacco," or custom FQDNs (e.g., block guns.com or casinosite.com).
   - Create a Security Profile: Link the new policy, set a priority (e.g., 100), and name it "Remote Access Security Profile."
   - Integrate with Conditional Access:
     - Navigate to Identity > Protection > Conditional Access > New Policy.
     - Target: All cloud apps (or specifically internet resources via Global Secure Access).
     - Assign to your pilot group.
     - Under Grant, require the "Remote Access Security Profile."
   - Expected Outcome: Policies enforce zero-trust checks at the cloud edge. Propagation may take 60-90 minutes.

4. **Test and Validate the Implementation (Verification Phase)**
   - After propagation, log in as a pilot user on the test device.
   - Attempt access to blocked sites (e.g., a weapons site like guns.com or a gambling site).
     - Expected: Access denied with a block page; check client logs for "connection closed" on port 443 (HTTPS) or 80 (HTTP).
   - Test allowed sites: Access a neutral site (e.g., news.com) and confirm it's tunneled via Internet Access without issues.
   - Simulate a phishing attempt: Try a risky URL (use a safe test site if needed) and verify blocking.
   - Monitor performance: Compare latency before/after (e.g., using speedtest.net). Note improvements in Microsoft 365 access.
   - For multi-device testing: Repeat on an iOS or Android device in the pilot group.
   - Document: Capture screenshots of logs, block pages, and any latency metrics.

5. **Evaluate and Scale (Reflection Phase)**
   - Assess the solution against TechNova's challenges: Did it reduce VPN dependency? Improve security without Azure infra? Optimize bandwidth?
   - Identify limitations: E.g., no support for multi-user OS like Windows Server; category coverage vs. custom needs.
   - Propose next steps: Roll out to all remote users, add more categories (e.g., malware sites), or integrate with Microsoft Defender for Endpoint.
   - Reflection Questions:
     - How does this align with zero-trust principles?
     - What risks remain if a user bypasses the client?
     - How would you handle policy exceptions for specific roles (e.g., researchers needing access to "weapons" sites for work)?

