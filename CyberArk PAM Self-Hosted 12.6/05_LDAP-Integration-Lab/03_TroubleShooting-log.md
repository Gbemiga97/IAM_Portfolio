
The error message is actually very specific about exactly what needs to be fixed. There are **two things** both required because the connection is using port **636 (LDAPS — secure connection)**:

---

## Fix 1 — Import the Domain Controller's SSL Certificate to the Vault

Since port 636 (LDAPS) is being used, the Vault needs to trust the Domain Controller's SSL certificate. Without it the secure connection is rejected.

**Step 1 — Export the certificate from the Domain Controller:**

1. On the **Domain Controller** (`WIN-6B5GOGITF83`), open PowerShell as Administrator and run:
```powershell
certutil -ca.cert C:\DCcert.cer
```
This exports the CA certificate to `C:\DCcert.cer`

2. Copy `DCcert.cer` to the **Vault server**

**Step 2 — Import the certificate into the Vault:**

1. On the **Vault server**, copy `DCcert.cer` into the Vault's Server directory:
```
C:\Program Files (x86)\PrivateArk\Server\
```
2. Open PowerShell as Administrator on the Vault server and run:
```powershell
certutil -addstore -f "Root" "C:\Program Files (x86)\PrivateArk\Server\DCcert.cer"
```
3. Restart the **CyberArk Vault** service:
```powershell
Stop-Service -Name "CyberArk Vault"
Start-Service -Name "CyberArk Vault"
```


---

## Fix 2 — Add the Domain Controller to the Vault's Hosts File

The Vault server cannot use DNS to resolve hostnames — it has no DNS server configured by design (part of its security isolation). This means you must manually tell the Vault where the Domain Controller lives by adding it to the Windows hosts file **on the Vault server**.

1. RDP into the **Vault server** (`192.168.100.11`)
2. Open **Notepad as Administrator**
3. Open the file:
```
C:\Windows\System32\drivers\etc\hosts
```
4. Add this line at the bottom:
```
192.168.100.10    WIN-6B5GOGITF83.pitythefool.com
```
5. Save and close the file

> 💡 This is why the error specifically says *"Verify that each of the domain controllers was added to the Vault's hosts file"* — it is a known requirement for every DC the Vault will communicate with.

---

## After Both Fixes — Retry the Connection

Go back to PVWA → **User Provisioning** → **LDAP Integration** → **New Domain**, go through Step 1 again (Define Domain), and when you reach Step 2 with `WIN-6B5GOGITF83.pitythefool.com` selected, click **Connect** again. The connection should succeed this time.

> 💡 **Alternative for lab use only:** If you want to skip the certificate complexity, go back to Step 1 (Define Domain) and change the port from `636` to `389`. Port 389 uses plain LDAP without SSL — you still need the hosts file fix but you can skip the certificate import. Only do this in a lab; in production, always use LDAPS (636).
