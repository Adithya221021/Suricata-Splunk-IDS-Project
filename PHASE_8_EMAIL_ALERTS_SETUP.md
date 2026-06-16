# EMAIL ALERTS SETUP GUIDE
## Windows IDS/IPS Project - Splunk Email Notifications

---

## 🎯 GOAL

Configure Splunk to send **email alerts** when high-risk IDS events are detected!

---

## 📋 WHAT YOU'LL NEED

1. **Email account** (Gmail recommended)
2. **Gmail App Password** (if using Gmail)
3. **SMTP server details**
4. **Email address to send alerts to**

---

## 🔐 STEP 1: GET GMAIL APP PASSWORD

### Why?

Gmail requires special "App Password" for third-party apps like Splunk.

### How to Get It:

**1. Go to Google Account:**
```
https://myaccount.google.com/
```

**2. Click: Security (left menu)**

**3. Scroll down to: "App passwords"**

**4. Select:**
- Device type: Windows Computer
- App: Mail

**5. Google generates 16-character password**

**Copy this password!** (You'll need it soon)

Example: `abcd efgh ijkl mnop`

---

## ⚙️ STEP 2: CONFIGURE SPLUNK EMAIL SETTINGS

### In Splunk Web:

```
1. Click: Settings (top right)
2. Click: Alert Actions
3. Click: Email
```

### Fill in These Fields:

**SMTP Server:**
```
smtp.gmail.com
```

**SMTP Port:**
```
587
```

**Sender Email Address:**
```
your-email@gmail.com
```

**Sender Username:**
```
your-email@gmail.com
```

**Sender Password:**
```
(paste the 16-character App Password from above)
```

**Use TLS:**
```
Check: YES
```

### Click: "Save"

---

## ✅ TEST EMAIL CONFIGURATION

### In Alert Actions section:

```
1. Look for "Send Test Email"
2. Enter test email address
3. Click: "Send Test Email"
4. Check inbox for test email
```

If test email arrives, configuration is correct! ✅

---

## 🚨 STEP 3: CREATE ALERT SEARCH

### In Splunk:

```
1. Click: Search & Reporting
2. Enter search: sourcetype=suricata event_type=alert
3. Click: Search
```

### Save as Alert:

```
1. Click: Save As
2. Click: Alert
3. Name: "High Risk Suricata Alerts"
4. Click: Save
```

---

## 🔔 STEP 4: CONFIGURE ALERT TRIGGER

### Alert Settings:

**Search:**
```spl
sourcetype=suricata event_type=alert
```

**Run Frequency:**
```
Every 5 minutes
```

**Trigger Condition:**
```
When: count > 0
```

(Trigger when ANY alert detected)

---

## 📧 STEP 5: ADD EMAIL ACTION

### In Alert Configuration:

```
1. Click: "Add action" button
2. Select: "Send Email"
3. Check: "Send email"
```

### Email Settings:

**Send email to:**
```
your-email@gmail.com
(or your work email)
```

**Email subject:**
```
🚨 IDS ALERT: Suricata Detected Attack
```

**Email message:**

Copy this template:

```
IDS Alert Summary

Alert Count: $result.count$
Alert Signature: $result.alert.signature$
Source IP: $result.src_ip$
Destination IP: $result.dest_ip$
Alert Category: $result.alert.category$
Time: $result._time$

Action Required: Check dashboard immediately!

Dashboard: http://localhost:8000/app/launcher/view/ids_alerts_overview
```

---

## 💾 STEP 6: SAVE ALERT

```
1. Click: "Save Alert"
2. Alert is now ACTIVE!
3. Will send email when triggered
```

---

## 🧪 TEST ALERT EMAIL

### Trigger Alert by Running Attack:

```cmd
nmap -sV localhost
```

### Wait 5 minutes

### Check Your Email

You should receive email from Splunk with alert details!

---

## 📊 ADVANCED: HIGH-RISK ALERT ONLY

### Create More Selective Alert:

**Search:**
```spl
sourcetype=suricata event_type=alert alert.severity=1
```

This only alerts on **HIGH severity** attacks!

---

## 🔧 CONFIGURE MULTIPLE EMAIL RECIPIENTS

### In Email Settings:

**Send email to:**
```
your-email@gmail.com, manager@company.com, security-team@company.com
```

(Separate with commas)

---

## 📈 ALERT VARIATIONS

### Alert 1: Immediate on Port Scan

```spl
sourcetype=suricata event_type=alert alert.signature="*Port Scan*"
```

**Trigger:** When count > 0  
**Frequency:** Every minute  
**Action:** Email security team

---

### Alert 2: Brute Force Attempts

```spl
sourcetype=suricata event_type=alert alert.signature="*Brute*"
| stats count as attempts by src_ip
| where attempts > 5
```

**Trigger:** When count > 0  
**Frequency:** Every 10 minutes

---

### Alert 3: Unusual Activity

```spl
sourcetype=suricata event_type=alert
| stats count as alert_count
| where alert_count > 20
```

**Trigger:** When 20+ alerts in 15 min window

---

## 📱 OPTIONAL: SLACK/WEBHOOK ALERTS

### If You Have Slack:

**In Alert Configuration:**
```
1. Add action: Webhook
2. URL: (your Slack webhook URL)
3. Message: Alert details
```

---

## ✅ VERIFY EMAIL ALERTS

### Check Alert Status:

```
Dashboards → Scheduled Searches
Look for: "High Risk Suricata Alerts"
Status should show: Active
```

---

## 🚨 ALERT MANAGEMENT

### View All Alerts:

```
Settings → Searches, Reports and Alerts
See all configured alerts
Enable/Disable as needed
```

### Edit Alert:

```
Click alert name
Modify trigger conditions
Save changes
```

### Delete Alert:

```
Click alert
Click: More actions
Click: Delete
```

---

## 📧 GMAIL TROUBLESHOOTING

### "Authentication failed" Error

**Solution:**
1. Verify Gmail App Password copied correctly
2. No spaces in password
3. Make sure you used App Password, not regular password

### Test Email Not Arriving

**Solutions:**
1. Check spam/junk folder
2. Verify sender email is correct
3. Check firewall isn't blocking SMTP port 587
4. Try port 465 instead (different config)

### SMTP Connection Timeout

**Solutions:**
1. Check internet connection
2. Verify firewall allows outbound port 587
3. Try Gmail's other SMTP settings:
   - Port: 465 (SSL instead of TLS)

---

## 🔐 SECURITY BEST PRACTICES

```
✅ Use App Passwords, not regular passwords
✅ Don't share email/password in configs
✅ Regularly review who gets alerts
✅ Disable old alerts you no longer need
✅ Monitor alert email frequency (no spam)
✅ Use separate alert email vs daily email
```

---

## 📊 EMAIL ALERT CHECKLIST

```
[ ] Gmail account setup
[ ] App Password generated
[ ] SMTP server configured (smtp.gmail.com)
[ ] Sender email set to your Gmail
[ ] App Password entered correctly
[ ] TLS enabled
[ ] Test email sent and received
[ ] Alert search created
[ ] Alert trigger configured (count > 0)
[ ] Email action added
[ ] Recipients configured
[ ] Alert saved and active
[ ] Attack simulation run
[ ] Email alert received
```

---

## 🎉 EMAIL ALERTS COMPLETE!

You now have:

✅ Automated IDS alerting  
✅ Email notifications on attacks  
✅ Multiple recipients supported  
✅ Configurable trigger conditions  
✅ Real-time threat notifications  

---

## 📸 FINAL PROJECT SETUP

Your complete Windows IDS/IPS system includes:

✅ **Suricata 8.0.5** - Network threat detection  
✅ **Splunk Enterprise** - Log analysis & search  
✅ **SOC Dashboard** - Real-time visualization  
✅ **Attack Simulation** - Testing capability  
✅ **Email Alerts** - Automated notifications  

---

## 🚀 YOUR PROJECT IS NOW COMPLETE!

---

## 📋 FINAL CHECKLIST

```
Installation & Setup
[✅] Suricata installed on Windows
[✅] Splunk Enterprise running
[✅] Npcap packet capture driver
[✅] Log directory created

Configuration
[✅] suricata.yaml configured
[✅] Network interface set (Wi-Fi)
[✅] Splunk data input created
[✅] Log monitoring active

Testing
[✅] Suricata logs generated
[✅] Splunk ingesting data
[✅] Dashboard created with 6 panels
[✅] Attack simulations running
[✅] Alerts detected in Splunk
[✅] Email alerts configured
[✅] Test email received

Complete Windows IDS/IPS System ✅
```

---

## 🎓 NEXT LEARNING STEPS

Once you have basics working:

1. **Advanced Dashboards**
   - Add MITRE ATT&CK mapping
   - Create risk scoring
   - Add GeoIP mapping

2. **Rule Tuning**
   - Disable false positive rules
   - Create custom detection rules
   - Tune sensitivity levels

3. **Incident Response**
   - Create playbooks
   - Automate responses
   - Document findings

4. **Performance Optimization**
   - Monitor resource usage
   - Optimize Splunk queries
   - Archive old data

---

## 📚 DOCUMENTATION

Keep these files for reference:

```
C:\intrusion project\
├── Windows_Master_Setup.ps1
├── WINDOWS_COMMAND_REFERENCE.md
├── WINDOWS_IDS_IPS_COMPLETE_GUIDE.md
├── SPLUNK_DASHBOARD_QUERIES.md
├── PHASE_6_CREATE_DASHBOARD.md
├── PHASE_7_ATTACK_SIMULATION.md
└── PHASE_8_EMAIL_ALERTS_SETUP.md
```

---

## 🎉 CONGRATULATIONS!

You've successfully built an **Enterprise-Grade IDS/IPS System on Windows**!

### Key Achievements:
- ✅ Threat detection working
- ✅ Log analysis running
- ✅ Dashboards visualizing data
- ✅ Alerts notifying you
- ✅ Attack simulation verified

**Your IDS/IPS system is now operational!** 🚀

---

**Questions? Refer to documentation files or re-run any phase!**

**Final Status: COMPLETE ✅**
