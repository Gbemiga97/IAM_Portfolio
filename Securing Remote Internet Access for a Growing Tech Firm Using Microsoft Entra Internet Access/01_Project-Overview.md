
#### Scenario
I am the IT Security Lead at TechNova, a mid-sized software development company with 200 employees. Over the past year, the workforce has shifted to hybrid and remote models, with employees accessing the internet from various locations using company-issued Windows laptops and mobile devices (iOS/Android). 

Recent challenges include:
- Increased latency and bandwidth consumption from routing all remote traffic through the on-premises VPN and firewall.
- Exposure to risky web content (e.g., sites promoting weapons, gambling, or malware), leading to two phishing incidents in the last quarter.
- Inefficient filtering for Microsoft 365 apps (e.g., Teams, SharePoint), which slows productivity.
- No centralized control for non-Windows devices, making compliance with zero-trust policies difficult.

The CEO has mandated a solution that optimizes internet traffic, enforces content filtering, and integrates with existing Entra ID for user authentication—without deploying additional Azure resources like virtual networks or firewalls. Based on research, I've decided to implement Entra Internet Access, part of the Microsoft Entra Suite, to route and secure web traffic at the cloud edge.

My goal is to deploy and test web content filtering for a pilot group of 10 remote developers, blocking categories like "weapons" and "gambling" while optimizing Microsoft 365 access.

#### Objectives
By the end of this project, I would have:
- Enable traffic forwarding profiles to route Internet and Microsoft 365 traffic securely.
- Configure bypass rules for specific internal resources.
- Create and apply web content filtering policies integrated with Conditional Access.
- Verify the setup on a test device and troubleshoot common issues.
- Evaluate the solution's impact on security and performance in the scenario.

#### Prerequisites
- Microsoft Entra P1 or P2 license (or Entra Suite add-on).
- A test Entra ID tenant with admin access.
- A hybrid-joined Windows 10/11 device for testing (or Cloud-only for simplicity).
- Global Secure Access client installed on the test device (download from aka.ms/GlobalSecureAccessClientWindows).
- A pilot user group in Entra ID (e.g., "Remote Developers Pilot").
- Familiarity with Entra Admin Center navigation.

