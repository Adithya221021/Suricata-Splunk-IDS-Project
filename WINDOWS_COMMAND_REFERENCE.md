# WINDOWS IDS/IPS - COMMAND REFERENCE
## Copy & Paste All Commands Here

---

## 🔧 STEP-BY-STEP SETUP COMMANDS

### STEP 1: Run Master Setup Script

```powershell
cd Desktop\intrusion project
powershell -ExecutionPolicy Bypass -File Windows_Master_Setup.ps1
```

---

### STEP 2: Configure Suricata (Edit Config File)

```cmd
notepad "C:\Program Files\Suricata\etc\suricata\suricata.yaml"
```

**Find and change these lines:**

**Around line 420-430 - Find: `af-packet:`**
```yaml
af-packet:
  - interface: Ethernet
    cluster-id: 99
    cluster-type: cluster_flow
    defrag: yes
```
Change `Ethernet` to your adapter name

**Around line 100 - Find: `default-log-dir:`**
```yaml
default-log-dir: C:\logs\suricata
```

**Save file:** Ctrl+S, then close

---

### STEP 3: Find Your Network Adapter Name

```cmd
ipconfig
```

Look for lines like:
- `Ethernet adapter Ethernet: ...`
- `Wireless LAN adapter WiFi: ...`

Use that name (usually `Ethernet` or `WiFi`)

---

### STEP 4: Update Suricata Rules

```cmd
cd "C:\Program Files\Suricata\bin"
suricata.exe -u
```

Wait 2-3 minutes for completion.

---

### STEP 5: Create Windows Service

**Replace `Ethernet` with YOUR adapter name:**

```cmd
cd "C:\Program Files\Suricata\bin"
suricata.exe --install-service -c "C:\Program Files\Suricata\etc\suricata\suricata.yaml" -i Ethernet
```

If successful, you'll see: `Service installed successfully`

---

### STEP 6: Start Suricata Service

```cmd
net start Suricata
```

Should show: `The Suricata service has been started successfully`

---

### STEP 7: Verify Suricata is Running

```cmd
sc query Suricata
```

Should show:
```
STATE : 4 RUNNING
```

---

### STEP 8: Check Log Files

```cmd
dir C:\logs\suricata\
```

Should show: `eve.json` file

---

### STEP 9: Configure Splunk Data Input

**In browser, open:** http://localhost:8000

**Steps:**
1. Click "Settings" (top right)
2. Click "Data Inputs"
3. Click "Files & Directories"
4. Click "New"
5. Input path: `C:\logs\suricata\eve.json`
6. Source type: `suricata`
7. Index: `main`
8. Click "Save"

---

### STEP 10: Test Detection with Nmap

```cmd
nmap -sV localhost
```

This generates port scan alerts that Suricata will detect.

---

### STEP 11: Verify in Splunk

**In Splunk Web, search:**
```
sourcetype=suricata
```

Should see JSON logs from Suricata.

**Search for alerts:**
```
sourcetype=suricata event_type=alert
```

Should see nmap port scan alerts.

---

## 📊 USEFUL COMMANDS (Copy & Paste)

### Check Suricata Status
```cmd
sc query Suricata
```

### Start Suricata
```cmd
net start Suricata
```

### Stop Suricata
```cmd
net stop Suricata
```

### Restart Suricata
```cmd
net stop Suricata && net start Suricata
```

### View Suricata Logs
```cmd
type C:\logs\suricata\eve.json | more
```

### Count Alerts Generated
```cmd
find /c "alert" C:\logs\suricata\eve.json
```

### Check Listening Ports
```cmd
netstat -ano | findstr :514
netstat -ano | findstr :8000
```

### Check Firewall Rules
```cmd
netsh advfirewall firewall show rule name=*Splunk*
netsh advfirewall firewall show rule name=*Suricata*
```

### Check Splunk Status
```cmd
sc query SplunkD
```

### Start Splunk
```cmd
net start SplunkD
```

### Restart Splunk
```cmd
net stop SplunkD && net start SplunkD
```

### List Network Adapters
```cmd
ipconfig
```

### Get All Network Adapter Names
```cmd
Get-NetAdapter | Select-Object Name
```

### View Network Traffic (Real-time)
```cmd
netstat -ano
```

### Check if File Exists
```cmd
dir "C:\logs\suricata\eve.json"
```

### Delete Log File (Be Careful!)
```cmd
del C:\logs\suricata\eve.json
```

### Update Rules
```cmd
cd "C:\Program Files\Suricata\bin"
suricata.exe -u
```

### Test Suricata Config
```cmd
cd "C:\Program Files\Suricata\bin"
suricata.exe -c "C:\Program Files\Suricata\etc\suricata\suricata.yaml" -T
```

---

## 🧪 ATTACK SIMULATION COMMANDS

### Install Nmap
```
Download from: https://nmap.org/download.html
Run installer
Add to PATH or use full path
```

### Port Scan (Basic)
```cmd
nmap localhost
```

### Port Scan with Version Detection
```cmd
nmap -sV localhost
```

### Scan Specific Ports
```cmd
nmap -p 22,80,443 localhost
```

### OS Detection Scan
```cmd
nmap -O localhost
```

### Aggressive Scan
```cmd
nmap -A localhost
```

---

## 📈 SPLUNK SEARCH QUERIES

### All Alerts
```
sourcetype=suricata event_type=alert
```

### Recent Alerts (Last 24 hours)
```
sourcetype=suricata event_type=alert earliest=-24h
| stats count by alert.signature, src_ip
| sort - count
```

### Top 10 Attack Sources
```
sourcetype=suricata event_type=alert
| stats count as attempts by src_ip
| sort - attempts
| head 10
```

### Alerts by Category
```
sourcetype=suricata event_type=alert
| stats count by alert.category
| sort - count
```

### Timeline of Attacks
```
sourcetype=suricata event_type=alert
| timechart count
```

### Unique Attack Sources
```
sourcetype=suricata event_type=alert
| dedup src_ip
| stats count
```

### HTTP Events
```
sourcetype=suricata event_type=http
| stats count by src_ip, dest_ip, http.url
```

### DNS Events
```
sourcetype=suricata event_type=dns
| stats count by dns.rrname
```

### Count by Severity
```
sourcetype=suricata event_type=alert
| stats count by alert.severity
```

---

## 🔴 TROUBLESHOOTING COMMANDS

### Service Won't Start
```cmd
cd "C:\Program Files\Suricata\bin"
suricata.exe -c "C:\Program Files\Suricata\etc\suricata\suricata.yaml" -T
```

### Check Event Logs for Errors
```cmd
Get-EventLog -LogName System -Source Suricata -Newest 20
```

### Verify Interface Name
```cmd
ipconfig /all
```

### Check Process Running
```cmd
tasklist | findstr suricata
```

### Kill Suricata Process (if stuck)
```cmd
taskkill /IM suricata.exe /F
```

### Check Disk Space
```cmd
dir C:\logs\suricata\
```

### List Large Files
```cmd
dir C:\logs\suricata\ /s /o:-S
```

### Verify Splunk Can Read File
```cmd
type C:\logs\suricata\eve.json | more
```

---

## 📁 IMPORTANT FILE LOCATIONS

```
Splunk Installation: C:\Program Files\Splunk\
Suricata Installation: C:\Program Files\Suricata\
Suricata Config: C:\Program Files\Suricata\etc\suricata\suricata.yaml
Suricata Rules: C:\Program Files\Suricata\rules\
Suricata Logs: C:\logs\suricata\
Suricata Alerts: C:\logs\suricata\eve.json
Project Folder: Desktop\intrusion project\
```

---

## ✅ SETUP CHECKLIST

```
[ ] Windows Master Setup script run successfully
[ ] Suricata configuration edited (adapter name set)
[ ] Suricata rules updated
[ ] Windows service created
[ ] Service running (sc query Suricata shows RUNNING)
[ ] Log files created (eve.json exists)
[ ] Splunk data input configured
[ ] Nmap installed
[ ] Port scan test runs successfully
[ ] Alerts visible in Splunk
[ ] Dashboard created
[ ] All searches working
```

---

## 🚀 QUICK START SUMMARY

1. Run: `Windows_Master_Setup.ps1`
2. Edit: `C:\Program Files\Suricata\etc\suricata\suricata.yaml`
3. Update rules: `suricata.exe -u`
4. Create service: `suricata.exe --install-service ...`
5. Start service: `net start Suricata`
6. Configure Splunk data input
7. Test with: `nmap -sV localhost`
8. Search in Splunk: `sourcetype=suricata`
9. Create dashboard
10. Done! ✅

---

**Copy these commands as needed!**
