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
| **Finance Analyst** | `SG-Finance-SharePoint-RW` | Security Group | CFO (Sarah) | 1-Stage (Manager) | 365 Days |
|  | `App-NetSuite-Finance` | Enterprise App | CFO (Sarah) |  |  |
| **HR Specialist** | `Team-HR-Confidential` | M365 Group | HR VP (David) | 2-Stage (Manager + Owner) | 180 Days |
|  | `SG-Workday-SSO` | Security Group | HR VP (David) |  |  |


## 3. Phase 2: Implementation (Hands-On)

### Step 1: Create Business Catalogs (The Container)

Catalogs allow resources to be grouped and to delegate management to non-admins.

1. Go to **Entra ID Admin Center** > **Identity Governance** > **Entitlement Management** > **Catalogs**.
2. Create a new Catalog named **"Finance Department"**.
3. **Enabled:** Yes.
4. **Catalog Owners:** Add a generic user (e.g., "Finance Director") to simulate business ownership.

📸 Screenshots of catalog creation:

<div>
  <img width="480" height="782" alt="Screenshot 2026-01-29 153703" src="https://github.com/user-attachments/assets/d5183b13-4a35-4ddc-ae41-5117da107197" />
  <img width="480" height="796" alt="Screenshot 2026-01-30 152624" src="https://github.com/user-attachments/assets/33d84432-bafa-43e3-86af-8ee70fab286d" />
</div>


### Step 2: Add Resources to Catalog

1. Open the **"Finance Department"** Catalog.
2. Click **Resources** on the left menu.
3. Add the resources identified in your matrix:
   - **Groups/Teams:** Select a Finance Security Group or Microsoft Team.
   - **Applications:** Select an Enterprise Application (e.g., Salesforce, or a sample app).

📸 Screenshots of resources added:

  <div>
    <img width="640" height="803" alt="Screenshot 2026-01-30 154600" src="https://github.com/user-attachments/assets/61b44047-0174-431f-8e97-b17483a484ac" />
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
        <img width="450" height="803" alt="Screenshot 2026-01-30 162630" src="https://github.com/user-attachments/assets/d41972bc-0dc3-4afc-accd-705ea799c426" />
        <img width="450" height="802" alt="Screenshot 2026-01-30 162645" src="https://github.com/user-attachments/assets/608d0a5e-c88d-454d-8b56-91f7dc996e5b" />
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
  <img width="320" height="799" alt="Screenshot 2026-01-30 171412" src="https://github.com/user-attachments/assets/397b2796-033b-47ce-8cf5-d285745aec99" />
  <img width="320" height="788" alt="Screenshot 2026-01-30 171734" src="https://github.com/user-attachments/assets/b1b34e74-7325-407f-aba8-326f30c8ab8e" />
  <img width="320" height="797" alt="Screenshot 2026-01-30 172050" src="https://github.com/user-attachments/assets/180feeef-e362-4eb2-8179-4f8edf9be002" />
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
    <img width="320" height="811" alt="Screenshot 2026-01-30 171429" src="https://github.com/user-attachments/assets/85c0d031-1337-4f5e-b3b6-81dfffb295cf" />
</div>
---

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
    * Go back to the Employee account. Verify they are now a member of the `SG-Finance-Data` group automatically.
