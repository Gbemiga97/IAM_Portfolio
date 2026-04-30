# Project: Business-Driven Access Governance Model (Entra ID)

## 1. The Scenario

**Company:** *Apex Financial Services*
**The Problem:** The IT Service Desk is drowning in tickets. New hires in the Finance and HR departments wait days for access to SharePoint sites, Teams, and SaaS apps. IT admins are blindly approving requests without knowing if the user *actually* needs the data.
**The Solution:**  I'll implement **Entra ID Entitlement Management**, and delegate decision-making authority to the "Business Owners" (Finance Director and HR Manager) so they control who can access their data, while IT controls the security guardrails.

---

## 2. Phase 1: The Business-to-IAM Mapping (Planning)

*Mapping business needs to technical objects.*

**Task:** Create a "Governance Matrix" defining the ownership.

| Business Role | Data/Resources (The "What") | Resource Type | Data Owner (The "Who") | Approval Workflow | Access Duration |
| --- | --- | --- | --- | --- | --- |
| **Finance Analyst** | `SG-Finance-SharePoint-RW` | Security Group | Finance Director | 1-Stage (Manager), (Finance Director) | 365 Days |
|  | `App-NetSuite-Finance` | Enterprise App | CFO (Sarah) |  |  |
| **HR Specialist** | `Team-HR-Confidential` | M365 Group | HR VP (Harry) | 2-Stage (Manager + Owner) | 180 Days |
|  | `Workday-SSO` | Enterprise App | HR VP (Harry) |  |  |


## 3. Phase 2: Implementation (Hands-On)

### Step 1: Create Business Catalogs (The Container)

Catalogs allow resources to be grouped and to delegate management to non-admins.

1. Go to **Entra ID Admin Center** > **Identity Governance** > **Entitlement Management** > **Catalogs**.
2. Create a new Catalog named **"Finance Department"**.
3. **Enabled:** Yes.
4. **Catalog Owners:** Add a generic user (e.g., "Finance Director") to simulate business ownership.

📸 Screenshots of catalog creation:

<div>
  <img width="480"  alt="Screenshot 2026-01-29 153703" src="https://github.com/user-attachments/assets/d5183b13-4a35-4ddc-ae41-5117da107197" />
  <img width="480"  alt="Screenshot 2026-01-30 152624" src="https://github.com/user-attachments/assets/33d84432-bafa-43e3-86af-8ee70fab286d" />
</div>
<div>
  <img width="480"  alt="Screenshot 2026-02-03 150226" src="https://github.com/user-attachments/assets/c799b63e-6db5-4fd6-ae32-363a0a54526a" />
<img width="480"  alt="Screenshot 2026-02-03 150352" src="https://github.com/user-attachments/assets/0aa1a62b-e5b4-4207-8523-71d46974c590" />
</div>

### Step 2: Add Resources to Catalog

1. Open the **"Finance Department"** Catalog.
2. Click **Resources** on the left menu.
3. Add the resources identified in your matrix:
   - **Groups/Teams:** Select a Finance Security Group or Microsoft Team.
   - **Applications:** Select an Enterprise Application (e.g., Salesforce, or a sample app).

📸 Screenshots of resources added:

  <div>
    <img width="480"  alt="Screenshot 2026-01-30 154600" src="https://github.com/user-attachments/assets/61b44047-0174-431f-8e97-b17483a484ac" />
    <img width="480"  alt="Screenshot 2026-02-05 135718" src="https://github.com/user-attachments/assets/95d281ad-e2c3-457b-8498-ed37a510949d" />
  </div>

### Step 3: Create the Access Package (The Product)

1. Go to **Access Packages** > **New Access Package**.
2. **Basics:**
    * Name: "Finance Analyst Role."
    * Description: "Standard access for Finance Analysts (SharePoint + NetSuite)."
    * Catalog: "Finance Department."
3. **Resource Roles:**
    - Select the resources you added in Step 2.
    - Assign the role (e.g., "Member" for the Group, "User" for the App).
📸 Screenshots of resources added:

<div>
    <img width="480"  alt="Screenshot 2026-01-30 162630" src="https://github.com/user-attachments/assets/d41972bc-0dc3-4afc-accd-705ea799c426" />
    <img width="480"  alt="Screenshot 2026-01-30 162645" src="https://github.com/user-attachments/assets/608d0a5e-c88d-454d-8b56-91f7dc996e5b" />
    <img width="480"  alt="Screenshot 2026-02-05 134345" src="https://github.com/user-attachments/assets/67b6c195-990f-4b6e-a6b7-eb24328acb2b" />
    <img width="480"  alt="Screenshot 2026-02-05 135141" src="https://github.com/user-attachments/assets/814aaf9b-09bd-4096-893c-8e86c7161f2e" />
</div>    

### Step 4: Configure Approval Workflows (The Governance)

*This is the core "Business Data Ownership" task.*

1. **Requests Tab:**
    * *Users who can request access:* "For users in your directory."
    * Select "Specific users and groups" (or "All members").


2. **Requestor Information:**
      * Add a question: "Cost Center Number" (Required). *This adds business context to the request.*


3. **Lifecycle Tab:**
    * *Expiration:* 365 Days.
    * *Access Reviews:* Yes (Set to "Self-review" or "Review by Manager" – this is necessary for governance).

📸 Screenshots of configuration:

  <div>
  <img width="320"  alt="Screenshot 2026-01-30 171412" src="https://github.com/user-attachments/assets/397b2796-033b-47ce-8cf5-d285745aec99" />
  <img width="320"  alt="Screenshot 2026-01-30 171734" src="https://github.com/user-attachments/assets/b1b34e74-7325-407f-aba8-326f30c8ab8e" />
  <img width="320"  alt="Screenshot 2026-01-30 172050" src="https://github.com/user-attachments/assets/180feeef-e362-4eb2-8179-4f8edf9be002" />
  <img width="320"  alt="Screenshot 2026-02-05 134532" src="https://github.com/user-attachments/assets/6419cc16-29c3-4115-b6a2-66f6cd5e6338" />
  <img width="320"  alt="Screenshot 2026-02-05 141909" src="https://github.com/user-attachments/assets/442be183-7b7d-453f-b095-626056257213" />
  <img width="320"  alt="Screenshot 2026-02-05 135115" src="https://github.com/user-attachments/assets/14951771-9d58-4608-98d5-4f9482ab7624" />
  </div>

### Step 5: The "Owner Approval" Logic

In the **Requests** tab (from Step 4), strictly define the approval chain:

1. **Require Approval:** Yes.
2. **First Approver:**
    * Choose **"Specific approvers"**.
    * Select the **Finance Director** user.
    * *Alternative:* Choose **"Manager as approver"**. This dynamically routes the request to the user's manager defined in Entra ID.


3. **Fallback:** Select the IT Admin account (in case the Owner is on vacation).

📸 Screenshots of configuration:

<div>
    <img width="480"  alt="Screenshot 2026-01-30 171429" src="https://github.com/user-attachments/assets/85c0d031-1337-4f5e-b3b6-81dfffb295cf" />
    <img width="480"  alt="Screenshot 2026-02-05 134804" src="https://github.com/user-attachments/assets/2915ffad-0a90-40ab-ad4b-958ad83744c2" />
</div>


## 4. Phase 3: The User Experience (Validation)

### Task: Simulate the Workflow

1. **The Request:**
    * Open a private browser window.
    * Log in as a standard user (The "Employee").
    * Navigate to the **MyAccess Portal** (`myaccess.microsoft.com`).
    * Find "Finance Analyst Roles" and click **Request**.
    * Fill in the business justification.


2. **The Approval:**
    * Log in as the **Finance Director** (The Approver).
    * Check email or refresh the MyAccess portal to see "Approvals".
    * Approve the request.


3. **The Verification:**
    * Go back to the Employee account. Verify they are now a member of the `Finance-Team` group automatically.


📸 Screenshots of Request, Approval, and Verification:

<div>
  <img width="320"  alt="Screenshot 2026-02-02 152630" src="https://github.com/user-attachments/assets/167b8028-1b20-4a4e-b43a-90064aecee43" />
<img width="320"  alt="Screenshot 2026-02-02 152719" src="https://github.com/user-attachments/assets/68df439e-ffcd-464e-9578-719f3bc7647f" />
<img width="320"  alt="Screenshot 2026-02-02 152834" src="https://github.com/user-attachments/assets/27408a2c-43f8-4929-986d-d918158ea4aa" />
<img width="320" alt="Screenshot 2026-02-02 152921" src="https://github.com/user-attachments/assets/6508773a-7878-4ced-95d8-b692f0fa154f" />
<img width="160"  alt="Screenshot 2026-02-02 153148" src="https://github.com/user-attachments/assets/7181ed6a-68ce-4fbd-a734-2bb4d2d94883" />
<img width="160"  alt="Screenshot 2026-02-02 153021" src="https://github.com/user-attachments/assets/da6f94a3-bc3b-44cf-aaf9-a27a8c626e1c" />
<img width="320"  alt="Screenshot 2026-02-02 153502" src="https://github.com/user-attachments/assets/4650c7f9-1fe7-471d-8d6d-583f378304d0" />
<img width="160"  alt="Screenshot 2026-02-02 165029" src="https://github.com/user-attachments/assets/f3d58c3c-a8ac-4417-bc91-a1398453c7da" />
  <img width="400" alt="Screenshot 2026-02-03 135144" src="https://github.com/user-attachments/assets/a80697ae-3f8f-462f-9951-3271c131d2d5" />
<img width="400"  alt="Screenshot 2026-02-03 135343" src="https://github.com/user-attachments/assets/0919102c-f67e-4738-9517-07845f4df2d7" />
<img width="480" alt="Screenshot 2026-02-03 135704" src="https://github.com/user-attachments/assets/caca01de-e8e2-451f-a243-ab9e0bde0cbb" />
<img width="480"  alt="Screenshot 2026-02-03 140333" src="https://github.com/user-attachments/assets/2353ae9f-21d2-4ab4-bd0f-e5d6df9a7a36" />
</div>

---

<div>
  <img width="320"  alt="Screenshot 2026-02-05 142448" src="https://github.com/user-attachments/assets/238c96b1-7cb4-4709-a059-7a15094f7511" />
<img width="160"  alt="Screenshot 2026-02-05 142509" src="https://github.com/user-attachments/assets/7aa5099c-19f7-4863-9dd4-989accbf0bf7" />
 <img width="160" alt="Screenshot (2)" src="https://github.com/user-attachments/assets/86c4717a-4eb4-4600-b28c-2ecbe186f0d6" />
<img width="320" alt="Screenshot 2026-02-05 142824" src="https://github.com/user-attachments/assets/903b126f-d155-4efe-b1da-2834d250edc7" />
<img width="160"  alt="Screenshot 2026-02-05 143040" src="https://github.com/user-attachments/assets/bff3bd4c-422b-4ab0-87f1-02340236db5d" />
<img width="160"  alt="Screenshot 2026-02-05 142939" src="https://github.com/user-attachments/assets/2a772067-cfb1-460f-94fd-32e8e0b96974" />
<img width="320"  alt="Screenshot 2026-02-05 143512" src="https://github.com/user-attachments/assets/30372b0d-f350-4e2e-9c18-5a20e91e42ca" />
<img width="160" alt="Screenshot 2026-02-05 143637" src="https://github.com/user-attachments/assets/6fdc729a-b931-4dfa-87b0-79d03be5196f" />
<img width="160"  alt="Screenshot 2026-02-05 143549" src="https://github.com/user-attachments/assets/4c4814bb-c7e3-4c4c-8cf6-cffd08823339" />
<img width="320"  alt="Screenshot 2026-02-05 150349" src="https://github.com/user-attachments/assets/9c088a9a-40ef-40ba-87ca-b2f0859b8fd7" />
<img width="320"  alt="Screenshot 2026-02-05 150439" src="https://github.com/user-attachments/assets/d0170154-1c3e-48bb-b27d-0a54d5ea954f" />
</div>
