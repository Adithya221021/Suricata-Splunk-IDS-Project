# COMPLETE WINDOWS IDS/IPS PROJECT GUIDE
## All-in-One Setup (Pure Windows)

---

## 📦 YOUR PROJECT STRUCTURE

```
Desktop\intrusion project\
├── Splunk Enterprise (installed in C:\Program Files\Splunk\)
├── Suricata 8.0.5 (installed in C:\Program Files\Suricata\)
├── Windows_Master_Setup.ps1 ← RUN THIS FIRST
├── WINDOWS_COMMAND_REFERENCE.md
├── SPLUNK_DASHBOARD_QUERIES.md
└── This guide
```

---

## ⏱️ ESTIMATED TIME: 2-3 HOURS (Total)

| Phase | Task | Time |
|-------|------|------|
| 1 | Verify Installation | 5 min |
| 2 | Configure Suricata | 15 min |
| 3 | Setup Windows Service | 10 min |
| 4 | Configure Splunk | 10 min |
| 5 | Test Detection | 10 min |
| 6 | Create Dashboard | 30 min |
| **Total** | **Complete Project** | **~90 min** |

---

## 🚀 PHASE 1: VERIFY INSTALLATION (5 minutes)

### 1.1 Check Suricata Installation

Open **CMD as Administrator:**

```cmd
cd "C:\Program Files\Suricata\bin"
suricata --version
```

**Expected output:**
```
Suricata Version 8.0.5
```

✅ If you see this, installation is successful!

---

### 1.2 Check Splunk Installation

```cmd
sc query SplunkD
```

Should show:
```
STATE : 4 RUNNING
```

✅ Splunk is running!

---

### 1.3 Verify Network

```cmd
netstat -ano | findstr :8000
```

Should show Splunk listening on port 8000.

---

## ⚙️ PHASE 2: CONFIGURE SURICATA (15 minutes)

### 2.1 Run Master Setup Script

**Open PowerShell as Administrator:**

```powershell
cd Desktop\intrusion project
powershell -ExecutionPolicy Bypass -File Windows_Master_Setup.ps1
```

This will:
- Create log directories
- Verify Suricata
- List your network adapters
- Set firewall rules
- Show next steps

---

### 2.2 Edit Suricata Configuration

Open the config file:

```cmd
notepad "C:\Program Files\Suricata\etc\suricata\suricata.yaml"
```

**Find and change 2 things:**

**Thing 1: Around line 100**
Find: `default-log-dir:`
Change to:
```yaml
default-log-dir: C:\logs\suricata
```

**Thing 2: Around line 420-430**
Find: `af-packet:`
Change `interface:` to your adapter name (from ipconfig):
```yaml
af-packet:
  - interface: Ethernet
    cluster-id: 99
    cluster-type: cluster_flow
    defrag: yes
```

**Save:** Ctrl+S, then close

---

### 2.3 Get Your Adapter Name

If unsure what adapter name to use:

```cmd
ipconfig
```

Look for:
- `Ethernet adapter Ethernet:` → use `Ethernet`
- `Wireless LAN adapter WiFi:` → use `WiFi`
- Any other name shown → use that name

---

### 2.4 Update Rules

```cmd
cd "C:\Program Files\Suricata\bin"
suricata.exe -u
```

Wait 2-3 minutes for rules to download from the internet.

---

## 🔧 PHASE 3: SETUP WINDOWS SERVICE (10 minutes)

### 3.1 Install Suricata as Service

**Replace `Ethernet` with YOUR adapter name:**

```cmd
cd "C:\Program Files\Suricata\bin"
suricata.exe --install-service -c "C:\Program Files\Suricata\etc\suricata\suricata.yaml" -i Ethernet
```

Expected: `Service installed successfully`

---

### 3.2 Start Suricata

```cmd
net start Suricata
```

Expected: `The Suricata service has been started successfully`

---

### 3.3 Verify Service is Running

```cmd
sc query Suricata
```

Should show:
```
STATE : 4 RUNNING
```

---

### 3.4 Check Logs are Being Created

```cmd
dir C:\logs\suricata\
```

Should list files:
- `eve.json` (alerts)
- `suricata.log` (debug info)

✅ If files exist, Suricata is working!

---

## 💻 PHASE 4: CONFIGURE SPLUNK (10 minutes)

### 4.1 Access Splunk Web

Open browser:
```
http://localhost:8000
```

Login:
```
Username: admin
Password: (the new password you set)
```

---

### 4.2 Create Data Input for Suricata Logs

```
1. Click "Settings" (top right)
2. Click "Data Inputs"
3. Click "Files & Directories"
4. Click "New"
5. Input path: C:\logs\suricata\eve.json
6. Source type: suricata
7. Index: main
8. Click "Save"
```

---

### 4.3 Verify Data Input

```
1. Click "Search & Reporting"
2. Search: sourcetype=suricata
3. Should see Suricata JSON logs
```

✅ If logs appear, integration is working!

---

## 🧪 PHASE 5: TEST DETECTION (10 minutes)

### 5.1 Install Nmap (if not installed)

Download from: https://nmap.org/download.html

Run installer, click Next, Next, Install.

---

### 5.2 Generate Test Alert

Run port scan (triggers IDS alert):

```cmd
nmap -sV localhost
```

This scans local ports and generates Suricata alerts.

---

### 5.3 Verify Alert in Splunk

In Splunk Web:

```
Search: sourcetype=suricata alert
```

Should show port scan alerts from nmap!

**Expected to see:**
- alert.signature: Port scan detection
- src_ip: 127.0.0.1
- dest_ip: 127.0.0.1

✅ If alerts visible, your IDS is detecting attacks!

---

## 📊 PHASE 6: CREATE DASHBOARD (30 minutes)

### 6.1 Create Dashboard

```
1. Click "Dashboards"
2. Click "Create New Dashboard"
3. Name: "IDS Alerts Overview"
4. Click "Create Dashboard"
```

---

### 6.2 Add Panel 1: All Alerts

```
1. Click "Add Panel"
2. Click "New Search"
3. Paste from WINDOWS_COMMAND_REFERENCE.md → Panel 1
4. Click "Visualize"
5. Select "Table"
6. Click "Save to Dashboard"
```

---

### 6.3 Add Panel 2: Top Attackers

```
1. Click "Add Panel"
2. Click "New Search"
3. Paste query for Top Attackers
4. Click "Visualize"
5. Select "Bar Chart"
6. Click "Save to Dashboard"
```

---

### 6.4 Add Panel 3: Timeline

```
1. Click "Add Panel"
2. Click "New Search"
3. Paste query for Timeline
4. Click "Visualize"
5. Select "Line Chart"
6. Click "Save to Dashboard"
```

---

### 6.5 Add More Panels (Optional)

Repeat process for:
- Alert Categories (Pie Chart)
- Severity Distribution (Column Chart)
- Recent Alerts (Table)
- Targeted Systems (Table)

See **SPLUNK_DASHBOARD_QUERIES.md** for all queries.

---

### 6.6 Save Dashboard

```
Click "Save" button
Your dashboard is now live!
```

---

## ✅ VERIFICATION CHECKLIST

Print this and check off as you complete:

```
Installation & Verification
[ ] Suricata version 8.0.5 confirmed (suricata --version)
[ ] Splunk running (sc query SplunkD shows Running)
[ ] Network listening verified (netstat -ano | findstr :8000)

Configuration
[ ] Master Setup script executed
[ ] suricata.yaml configured with correct adapter
[ ] Log directory C:\logs\suricata\ exists
[ ] Rules updated (suricata.exe -u completed)

Service Setup
[ ] Windows service installed
[ ] Service running (sc query Suricata shows Running)
[ ] eve.json file exists and growing
[ ] suricata.log file exists

Splunk Integration
[ ] Data input created for C:\logs\suricata\eve.json
[ ] Search "sourcetype=suricata" returns results
[ ] Sample logs visible in Splunk

Testing
[ ] Nmap installed
[ ] Port scan test executed (nmap -sV localhost)
[ ] Alerts triggered in Suricata
[ ] Alerts visible in Splunk (sourcetype=suricata alert)

Dashboard
[ ] Dashboard created
[ ] Panel 1: All Alerts (Table) working
[ ] Panel 2: Top Attackers (Bar) working
[ ] Panel 3: Timeline (Line) working
[ ] Additional panels added (optional)
[ ] Dashboard saved and accessible

Final
[ ] All systems running
[ ] Real-time data flowing
[ ] Project complete ✅
```

---

## 🔍 TROUBLESHOOTING

### Problem: "Suricata is not recognized" (STEP 1)

**Solution:**
```cmd
cd "C:\Program Files\Suricata\bin"
suricata --version
```

If still fails, Suricata not installed. Reinstall from:
https://www.openinfosecfoundation.org/download/suricata/suricata-8.0.5-1-64bit.msi

---

### Problem: Service won't start (STEP 3)

**Solution:**
```cmd
cd "C:\Program Files\Suricata\bin"
suricata.exe -c "C:\Program Files\Suricata\etc\suricata\suricata.yaml" -T
```

Check output for errors. Common issue: wrong adapter name in config.

---

### Problem: No logs in eve.json (STEP 3)

**Solution:**
1. Verify adapter name is correct: `ipconfig`
2. Check config file: `notepad C:\Program Files\Suricata\etc\suricata\suricata.yaml`
3. Restart service: `net stop Suricata && net start Suricata`
4. Wait 10 seconds and check: `dir C:\logs\suricata\`

---

### Problem: No data in Splunk (STEP 4)

**Solution:**
1. Check if eve.json exists: `dir C:\logs\suricata\eve.json`
2. Check if file has content: `type C:\logs\suricata\eve.json | more`
3. Restart Splunk: `net stop SplunkD && net start SplunkD`
4. Wait 30 seconds and search again

---

### Problem: No alerts detected (STEP 5)

**Solution:**
1. Run nmap again: `nmap -sV localhost`
2. Wait 10 seconds
3. Search in Splunk: `sourcetype=suricata alert`
4. If still nothing, check Suricata is running: `sc query Suricata`

---

## 📚 REFERENCE FILES

| File | Purpose |
|------|---------|
| Windows_Master_Setup.ps1 | Automated setup script (Run this!) |
| WINDOWS_COMMAND_REFERENCE.md | All commands for setup/management |
| SPLUNK_DASHBOARD_QUERIES.md | Dashboard queries and setup |
| This file | Complete project guide |

---

## 🎯 NEXT STEPS (After Basic Setup)

### Advanced Features to Add:

1. **Email Alerts**
   - Settings → Alert Actions → Email
   - Configure SMTP
   - Create alert searches

2. **Risk Scoring**
   - Use eval to calculate risk scores
   - Create risk-based searches

3. **MITRE ATT&CK Mapping**
   - Create lookup file
   - Map signatures to techniques
   - Display in dashboards

4. **More Attack Simulation**
   - Brute force (Hydra)
   - Exploitation (Metasploit)
   - Web attacks (SQLi, XSS)

5. **Performance Optimization**
   - Tune Suricata rules
   - Optimize Splunk searches
   - Archive old logs

See **SPLUNK_DASHBOARD_QUERIES.md** for advanced queries.

---

## 📊 FINAL RESULT

After completing all phases, you will have:

✅ Suricata running on Windows (monitoring network)
✅ Splunk Enterprise running (analyzing logs)
✅ Real-time data flowing (eve.json → Splunk)
✅ SOC Dashboard (visualizing attacks)
✅ Alert Detection (finding threats)
✅ Complete IDS/IPS System (all Windows!)

---

## 🚀 START NOW!

**Follow these phases in order:**

1. **PHASE 1** (5 min): Verify Installation
2. **PHASE 2** (15 min): Configure Suricata
3. **PHASE 3** (10 min): Setup Service
4. **PHASE 4** (10 min): Configure Splunk
5. **PHASE 5** (10 min): Test Detection
6. **PHASE 6** (30 min): Create Dashboard

**Total: ~90 minutes to complete project!**

---

**Questions? Check WINDOWS_COMMAND_REFERENCE.md or troubleshooting section above.**

**Good luck! You're building an enterprise-grade IDS/IPS system!** 🎉
