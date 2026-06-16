# SPLUNK DASHBOARD & QUERIES
## Windows IDS/IPS Project

---

## 🎯 HOW TO CREATE DASHBOARD IN SPLUNK

### Step 1: Create New Dashboard
```
1. Go to: http://localhost:8000
2. Click: "Dashboards"
3. Click: "Create New Dashboard"
4. Name: "IDS Alerts Overview"
5. Click: "Create Dashboard"
```

### Step 2: Add Panels
```
1. Click: "Add Panel"
2. Click: "New Search"
3. Paste query from below
4. Click: "Visualize"
5. Select visualization type
6. Click: "Save to Dashboard"
```

---

## 📊 DASHBOARD PANEL 1: All Alerts (Table)

**Panel Title:** Alert Summary

**Search Query:**
```spl
sourcetype=suricata event_type=alert
| stats count as Total, latest(_time) as "Last Alert" by alert.signature, src_ip, dest_ip
| sort - Total
| head 20
```

**Visualization:** Table

**Description:** Shows all detected attacks with count and last alert time

---

## 📊 DASHBOARD PANEL 2: Top 10 Attackers (Bar Chart)

**Panel Title:** Top Attack Sources

**Search Query:**
```spl
sourcetype=suricata event_type=alert
| stats count as "Attack Count" by src_ip
| sort - "Attack Count"
| head 10
```

**Visualization:** Bar Chart

**Description:** Shows which IP addresses are attacking most frequently

---

## 📊 DASHBOARD PANEL 3: Attack Categories (Pie Chart)

**Panel Title:** Attack Types Distribution

**Search Query:**
```spl
sourcetype=suricata event_type=alert
| stats count by alert.category
| sort - count
```

**Visualization:** Pie Chart

**Description:** Shows distribution of different attack categories

---

## 📊 DASHBOARD PANEL 4: Timeline (Line Chart)

**Panel Title:** Attacks Over Time

**Search Query:**
```spl
sourcetype=suricata event_type=alert
| timechart count as "Alert Count"
```

**Visualization:** Line Chart

**Description:** Shows attack trends over time

---

## 📊 DASHBOARD PANEL 5: Alert Severity (Column Chart)

**Panel Title:** Severity Distribution

**Search Query:**
```spl
sourcetype=suricata event_type=alert
| eval severity_level=case(alert.severity=1, "High (1)", alert.severity=2, "Medium (2)", alert.severity=3, "Low (3)")
| stats count by severity_level
| sort severity_level
```

**Visualization:** Column Chart

**Description:** Shows severity level distribution of alerts

---

## 📊 DASHBOARD PANEL 6: Unique Attack Sources (Single Value)

**Panel Title:** Unique Attackers Count

**Search Query:**
```spl
sourcetype=suricata event_type=alert
| dedup src_ip
| stats count
```

**Visualization:** Single Value

**Description:** Shows total number of unique attacking IP addresses

---

## 📊 DASHBOARD PANEL 7: Recent Alerts (Table)

**Panel Title:** Latest Alerts

**Search Query:**
```spl
sourcetype=suricata event_type=alert
| sort - _time
| head 20
| table _time, alert.signature, src_ip, dest_ip, alert.category, alert.severity
```

**Visualization:** Table

**Description:** Shows most recent alerts in real-time

---

## 📊 DASHBOARD PANEL 8: Attacks by Destination (Table)

**Panel Title:** Targeted Systems

**Search Query:**
```spl
sourcetype=suricata event_type=alert
| stats count as "Attacks" by dest_ip
| sort - "Attacks"
| head 10
```

**Visualization:** Table

**Description:** Shows which internal systems are being targeted

---

## 🔍 USEFUL ADDITIONAL SEARCHES

### Search: Port Scan Detection
```spl
sourcetype=suricata event_type=alert alert.signature="*Port Scan*"
| stats count by src_ip, alert.signature
| sort - count
```

### Search: Brute Force Attempts
```spl
sourcetype=suricata event_type=alert alert.signature="*Brute*"
| stats count as "Attempts" by src_ip
| where "Attempts" > 5
```

### Search: HTTP Attacks
```spl
sourcetype=suricata event_type=http
| stats count by src_ip, http.http_method, http.url
```

### Search: DNS Requests
```spl
sourcetype=suricata event_type=dns
| stats count by dns.rrname, src_ip
| sort - count
```

### Search: SSH Attacks
```spl
sourcetype=suricata event_type=ssh
| stats count by src_ip, ssh.client_version
```

### Search: Alerts Last Hour
```spl
sourcetype=suricata event_type=alert earliest=-1h
| stats count by alert.signature
| sort - count
```

### Search: Alerts Last 24 Hours
```spl
sourcetype=suricata event_type=alert earliest=-24h
| stats count
```

### Search: Top Signatures
```spl
sourcetype=suricata event_type=alert
| stats count by alert.signature
| sort - count
| head 15
```

### Search: Attack Locations (Needs GeoIP)
```spl
sourcetype=suricata event_type=alert
| iplocation src_ip
| stats count by src_ip, City, Country
| geostats count by src_ip
```

### Search: High Severity Only
```spl
sourcetype=suricata event_type=alert alert.severity=1
| stats count by alert.signature, src_ip
| sort - count
```

---

## ⚙️ DASHBOARD CREATION STEP-BY-STEP

### Complete Walkthrough:

**1. Go to Splunk Web**
```
http://localhost:8000
```

**2. Navigate to Dashboards**
```
Click top menu: Dashboards
```

**3. Create New Dashboard**
```
Click: Create New Dashboard
Enter name: "IDS Alerts Overview"
Click: Create Dashboard
```

**4. Add First Panel (All Alerts)**
```
Click: Add Panel
Click: New Search
Copy query from PANEL 1 above
Click: Visualize
Select: Table
Click: Save to Dashboard
Title: "Alert Summary"
```

**5. Add More Panels**
```
Repeat step 4 for each panel below using different queries
```

**6. Arrange Panels**
```
Click: Edit Dashboard
Drag panels to arrange
Click: Save Dashboard
```

---

## 💾 SAVE DASHBOARD SEARCHES

### To save searches for later use:

```
1. In search bar, enter your query
2. Click: "Save As"
3. Name: descriptive name
4. Click: "Save"
```

**Saved searches appear in:** Dashboards → Saved Searches

---

## 🔔 CREATE ALERTS (Optional)

### To get email alerts when attacks detected:

```
1. Enter search query
2. Click: "Save As" → "Alert"
3. Name: "High Risk Alerts"
4. Trigger: When count > 0
5. Throttle: 5 minutes
6. Add action: Email
7. Recipient: your@email.com
8. Click: "Save Alert"
```

---

## 📈 RISK SCORING (Advanced)

### Add Risk Scoring to Searches:

```spl
sourcetype=suricata event_type=alert
| eval risk_score=case(
  alert.severity=1, 90,
  alert.severity=2, 50,
  alert.severity=3, 20,
  1=1, 0
)
| stats count as "Alert Count", avg(risk_score) as "Avg Risk" by alert.signature
| sort - "Alert Count"
```

---

## 🎭 MITRE ATT&CK MAPPING (Advanced)

### Map alerts to MITRE techniques:

First, create a lookup file at:
```
C:\Program Files\Splunk\etc\apps\search\lookups\mitre_mapping.csv
```

Content:
```csv
signature,technique_id,technique,tactic
Port Scan*,T1046,Network Service Discovery,Discovery
Brute Force*,T1110,Brute Force,Credential Access
SQL Injection*,T1190,Exploit Public-Facing Application,Initial Access
Malware*,T1566,Phishing,Initial Access
```

Then use in search:
```spl
sourcetype=suricata event_type=alert
| lookup mitre_mapping signature
| stats count by technique, tactic
```

---

## 📊 DASHBOARD EXPORT

### To export/backup dashboard:

```
1. Go to dashboard
2. Click: "..." menu
3. Click: "Export as PDF"
4. Or use API to export JSON
```

---

## 🔧 TROUBLESHOOTING SEARCHES

### If no results show:

```spl
sourcetype=suricata
```

Should show any Suricata data. If empty:
1. Check: Settings → Data Inputs → Files & Directories
2. Verify: C:\logs\suricata\eve.json exists
3. Check: File has content (dir C:\logs\suricata\)
4. Restart Splunk: net stop SplunkD && net start SplunkD

### If eve.json not ingesting:

```
1. Stop Splunk: net stop SplunkD
2. Delete input: Settings → Data Inputs → Remove
3. Restart Suricata: net stop Suricata && net start Suricata
4. Wait 30 seconds
5. Start Splunk: net start SplunkD
6. Re-add data input: C:\logs\suricata\eve.json
7. Search: sourcetype=suricata
```

---

## 📋 CHECKLIST: SPLUNK SETUP

```
[ ] Splunk Web accessible at localhost:8000
[ ] Admin password changed
[ ] Data input created for C:\logs\suricata\eve.json
[ ] Search "sourcetype=suricata" returns results
[ ] Dashboard created
[ ] All 8 panels added
[ ] Panel 1: All Alerts (Table) working
[ ] Panel 2: Top Attackers (Bar) working
[ ] Panel 3: Categories (Pie) working
[ ] Panel 4: Timeline (Line) working
[ ] Panel 5: Severity (Column) working
[ ] Panel 6: Unique Count (Single Value) working
[ ] Panel 7: Recent Alerts (Table) working
[ ] Panel 8: Targeted Systems (Table) working
```

---

## 🚀 QUICK DASHBOARD SETUP

**Create entire dashboard in 10 minutes:**

1. Create dashboard (1 min)
2. Add panel 1 - All Alerts (1 min)
3. Add panel 2 - Top Attackers (1 min)
4. Add panel 4 - Timeline (1 min)
5. Add panel 7 - Recent Alerts (1 min)
6. Add panel 5 - Severity (1 min)
7. Arrange panels (2 min)
8. Save (1 min)

Done! You now have a working SOC dashboard! ✅

---

**Copy these queries as needed for your Splunk dashboard!**
