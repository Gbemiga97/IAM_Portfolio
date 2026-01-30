# Project: Business-Driven Access Governance Model (Entra ID)

## 1. The Scenario

**Company:** *Apex Financial Services*
**The Problem:** The IT Service Desk is drowning in tickets. New hires in the Finance and HR departments wait days for access to SharePoint sites, Teams, and SaaS apps. IT admins are blindly approving requests without knowing if the user *actually* needs the data.
**The Solution:** You will implement **Entra ID Entitlement Management**. You will delegate decision-making authority to the "Business Owners" (Finance Director and HR Manager) so they control who accesses their data, while IT controls the security guardrails.

---

## 2. Phase 1: The Business-to-IAM Mapping (Planning)

*Before touching the portal, you must map business needs to technical objects. This document is a critical piece of your portfolio.*

**Task:** Create a "Governance Matrix" (Excel/Table) defining the ownership.

| Business Role | Data/Resources (The "What") | Resource Type | Data Owner (The "Who") | Approval Workflow | Access Duration |
| --- | --- | --- | --- | --- | --- |
| **Finance Analyst** | `SG-Finance-SharePoint-RW` | Security Group | CFO (Sarah) | 1-Stage (Manager) | 365 Days |
|  | `App-NetSuite-Finance` | Enterprise App | CFO (Sarah) |  |  |
| **HR Specialist** | `Team-HR-Confidential` | M365 Group | HR VP (David) | 2-Stage (Manager + Owner) | 180 Days |
|  | `SG-Workday-SSO` | Security Group | HR VP (David) |  |  |


## 3. Phase 2: Implementation (Hands-On)

### Step 1: Create Business Catalogs (The Container)

Catalogs allow you to group resources and delegate management to non-admins.

1. Go to **Entra ID Admin Center** > **Identity Governance** > **Entitlement Management** > **Catalogs**.
2. Create a new Catalog named **"Finance Department"**.
3. **Enabled:** Yes.
4. **Catalog Owners:** Add a generic user (e.g., "Finance Director") to simulate business ownership. This proves you understand delegation.

### Step 2: Add Resources to Catalog

1. Open the **"Finance Department"** Catalog.
2. Click **Resources** on the left menu.
3. Add the resources identified in your matrix:
* **Groups/Teams:** Select a Finance Security Group or Microsoft Team.
* **Applications:** Select an Enterprise Application (e.g., Salesforce, or a sample app).
* *Note: If you don't have these, create dummy Security Groups named `SG-Finance-Data` first.*



### Step 3: Create the Access Package (The Product)

1. Go to **Access Packages** > **New Access Package**.
2. **Basics:**
* Name: "Finance Analyst Roles"
* Description: "Standard access for Finance Analysts (SharePoint + NetSuite)."
* Catalog: "Finance Department"


3. **Resource Roles:**
* Select the resources you added in Step 2.
* Assign the role (e.g., "Member" for the Group, "User" for the App).



### Step 4: Configure Approval Workflows (The Governance)

*This is the core "Business Data Ownership" task.*

1. **Requests Tab:**
* *Users who can request access:* "For users in your directory."
* Select "Specific users and groups" (or "All members").


2. **Requestor Information:**
* Add a question: "Cost Center Number" (Required). *This adds business context to the request.*


3. **Lifecycle Tab:**
* *Expiration:* 365 Days.
* *Access Reviews:* Yes (Set to "Self-review" or "Review by Manager" – this is a huge bonus for governance).



### Step 5: The "Owner Approval" Logic

In the **Requests** tab (from Step 4), strictly define the approval chain:

1. **Require Approval:** Yes.
2. **First Approver:**
* Choose **"Specific approvers"**.
* Select the **Finance Director** user.
* *Alternative:* Choose **"Manager as approver"**. This dynamically routes the request to the user's manager defined in Entra ID.


3. **Fallback:** Select the IT Admin account (in case the Owner is on vacation).

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
