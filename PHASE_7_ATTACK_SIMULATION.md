# ATTACK SIMULATION & TESTING GUIDE
## Windows IDS/IPS Project

---

## 🎯 GOAL

Run attack simulations to trigger Suricata alerts and verify your IDS is detecting threats!

---

## ⚠️ IMPORTANT WARNINGS

```
⚠️ ONLY RUN ON YOUR OWN NETWORK
⚠️ DO NOT ATTACK OTHER SYSTEMS
⚠️ ONLY FOR TESTING YOUR IDS
```

---

## 📥 STEP 1: Install Nmap (Port Scanner)

### Download Nmap

Go to: https://nmap.org/download.html

Download: **nmap-7.94-setup.exe** (or latest version)

### Install:
```
1. Run installer
2. Click: Next, Next, Install
3. Complete installation
```

### Verify Installation:

```cmd
nmap --version
```

Should show version number.

---

## 🚀 STEP 2: RUN ATTACK SIMULATION #1 - PORT SCAN

### Open CMD as Administrator

```
Windows Key + X → Command Prompt (Admin)
```

### Run Port Scan (Triggers IDS Alert):

```cmd
nmap -sV localhost
```

Press **Enter**

---

### What This Does:

- Scans local machine ports
- Suricata detects port scan
- Generates alert in logs
- Splunk ingests the alert

---

### Expected Output:

```
Starting Nmap 7.94
Nmap scan report for localhost (127.0.0.1)
Host is up
PORT     STATE  SERVICE VERSION
...
Nmap done
```

---

## 🔍 VERIFY IN SPLUNK

### After running nmap, go to Splunk:

```
1. Open: http://localhost:8000
2. Click: Search & Reporting
3. Search: sourcetype=suricata alert
4. Should see port scan alerts!
```

---

## 🚀 STEP 3: RUN ATTACK SIMULATION #2 - OS DETECTION SCAN

```cmd
nmap -O localhost
```

This triggers OS detection alerts.

---

## 🚀 STEP 4: RUN ATTACK SIMULATION #3 - AGGRESSIVE SCAN

```cmd
nmap -A localhost
```

This triggers multiple alert types.

---

## 🚀 STEP 5: RUN ATTACK SIMULATION #4 - UDP SCAN

```cmd
nmap -sU localhost
```

This scans UDP ports (different detection).

---

## 🚀 STEP 6: BRUTE FORCE SIMULATION (Optional)

### Install Hydra (Brute Force Tool)

Download: https://github.com/vanhauser-thc/thc-hydra/releases

Or use pre-built Windows version.

### Simulate SSH Brute Force:

```cmd
hydra -l admin -P passwords.txt ssh://localhost
```

**Note:** Requires valid target with SSH service.

---

## 📊 VIEWING ATTACK RESULTS IN SPLUNK

### Search for Port Scans:

```spl
sourcetype=suricata alert alert.signature="*Port*"
| stats count by alert.signature, src_ip
```

### Search for All Alerts:

```spl
sourcetype=suricata event_type=alert
| stats count by alert.signature
| sort - count
```

### Search by Source IP:

```spl
sourcetype=suricata event_type=alert src_ip=127.0.0.1
| stats count by alert.signature
```

### Real-time Monitoring:

```spl
sourcetype=suricata event_type=alert
| timechart count
```

---

## 🎯 COMPLETE ATTACK SIMULATION SEQUENCE

### Run all these commands in order:

```cmd
# Attack 1: Port Scan
nmap -sV localhost

# Wait 10 seconds

# Attack 2: OS Detection
nmap -O localhost

# Wait 10 seconds

# Attack 3: Aggressive Scan
nmap -A localhost

# Wait 10 seconds

# Attack 4: UDP Scan
nmap -sU localhost
```

---

## 📈 CHECK SPLUNK DASHBOARD

After running attacks:

```
1. Go to: Dashboards → "IDS Alerts Overview"
2. Should see:
   - Alerts in timeline
   - Multiple attack sources
   - Different attack types
   - Recent alerts table populated
```

---

## 🔬 ADVANCED ATTACK SIMULATIONS

### SQL Injection Attempt:

```cmd
curl "http://localhost/page.php?id=1' OR '1'='1"
```

(Requires vulnerable web server)

### Directory Scan:

```cmd
nmap --script http-enum localhost -p 80
```

### Service Version Detection:

```cmd
nmap -sV -p 1-65535 localhost
```

---

## 📊 INTERPRETING RESULTS

### What You Should See in Splunk:

```
Alert Type          Count    Source
Port Scan           5        127.0.0.1
Network Scan        3        127.0.0.1
Service Detection   2        127.0.0.1
```

---

## ✅ ATTACK SIMULATION CHECKLIST

```
[ ] Installed Nmap
[ ] Ran port scan (nmap -sV localhost)
[ ] Checked Splunk for alerts
[ ] Ran OS detection (nmap -O localhost)
[ ] Ran aggressive scan (nmap -A localhost)
[ ] Ran UDP scan (nmap -sU localhost)
[ ] Dashboard showing alerts
[ ] Timeline updated
[ ] Top attackers showing 127.0.0.1
```

---

## 🎉 SUCCESS INDICATORS

You'll know it's working when:

✅ Splunk shows events from suricata  
✅ Dashboard panel fills with data  
✅ Timeline shows alert spikes  
✅ Alert summary shows different signatures  
✅ Recent alerts table populates  

---

## 📸 SCREENSHOT:

Run attacks and send screenshot of:
1. Splunk search results showing alerts
2. Dashboard with populated panels

---

## ⚠️ CLEANUP

After testing:

```cmd
# Clear logs (optional)
del C:\logs\suricata\eve.json
```

Then Suricata will start fresh for next test.

---

## 🔧 TROUBLESHOOTING

### Nmap says "permission denied"

Run CMD as Administrator!

### No alerts appearing in Splunk

Check:
```cmd
dir C:\logs\suricata\
```

File should be growing in size.

### Splunk not updating

Refresh the search:
```
Click: Search button again
Or press: F5
```

---

**Attack simulation guide complete!** ✅

Next: **EMAIL ALERTS SETUP** 👉
