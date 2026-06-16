# CREATE SPLUNK DASHBOARD - COMPLETE GUIDE
## Windows IDS/IPS Project

---

## 🚀 STEP 1: CREATE NEW DASHBOARD

### In Splunk Web:

```
1. Click: "Dashboards" (top menu)
2. Click: "Create New Dashboard"
3. Name: "IDS Alerts Overview"
4. Click: "Create Dashboard"
```

You're now in edit mode!

---

## 📊 STEP 2: ADD PANEL 1 - ALL ALERTS (Table)

### Click: "Add Panel"

```
1. Click: "Add Panel"
2. Click: "New Search"
3. Copy this search:
```

**Search Query:**
```spl
sourcetype=suricata event_type=alert
| stats count as "Total", latest(_time) as "Last Alert" by alert.signature, src_ip, dest_ip
| sort - Total
| head 20
```

### After pasting:
```
1. Click: "Visualize"
2. Select: "Table" (default)
3. Click: "Save to Dashboard"
4. Title: "Alert Summary"
5. Click: "Save"
```

---

## 📊 STEP 3: ADD PANEL 2 - TOP ATTACKERS (Bar Chart)

### Click: "Add Panel" again

**Search Query:**
```spl
sourcetype=suricata event_type=alert
| stats count as "Attack Count" by src_ip
| sort - "Attack Count"
| head 10
```

### After pasting:
```
1. Click: "Visualize"
2. Select: "Bar Chart"
3. Click: "Save to Dashboard"
4. Title: "Top Attack Sources"
5. Click: "Save"
```

---

## 📊 STEP 4: ADD PANEL 3 - ATTACK CATEGORIES (Pie Chart)

### Click: "Add Panel" again

**Search Query:**
```spl
sourcetype=suricata event_type=alert
| stats count by alert.category
| sort - count
```

### After pasting:
```
1. Click: "Visualize"
2. Select: "Pie Chart"
3. Click: "Save to Dashboard"
4. Title: "Attack Types Distribution"
5. Click: "Save"
```

---

## 📊 STEP 5: ADD PANEL 4 - TIMELINE (Line Chart)

### Click: "Add Panel" again

**Search Query:**
```spl
sourcetype=suricata event_type=alert
| timechart count as "Alert Count"
```

### After pasting:
```
1. Click: "Visualize"
2. Select: "Line Chart"
3. Click: "Save to Dashboard"
4. Title: "Attacks Over Time"
5. Click: "Save"
```

---

## 📊 STEP 6: ADD PANEL 5 - RECENT ALERTS (Table)

### Click: "Add Panel" again

**Search Query:**
```spl
sourcetype=suricata event_type=alert
| sort - _time
| head 20
| table _time, alert.signature, src_ip, dest_ip, alert.category
```

### After pasting:
```
1. Click: "Visualize"
2. Select: "Table"
3. Click: "Save to Dashboard"
4. Title: "Latest Alerts"
5. Click: "Save"
```

---

## 📊 STEP 7: ADD PANEL 6 - UNIQUE ATTACKERS (Single Value)

### Click: "Add Panel" again

**Search Query:**
```spl
sourcetype=suricata event_type=alert
| dedup src_ip
| stats count
```

### After pasting:
```
1. Click: "Visualize"
2. Select: "Single Value"
3. Click: "Save to Dashboard"
4. Title: "Unique Attackers"
5. Click: "Save"
```

---

## 🎨 STEP 8: ARRANGE PANELS

### In Dashboard Edit Mode:

```
1. Panels appear in order added
2. Drag panels to rearrange
3. Click: "Save Dashboard" (top right)
```

---

## ✅ YOUR DASHBOARD IS COMPLETE!

You now have a professional **SOC Dashboard** showing:
- ✅ All alerts summary
- ✅ Top attacking sources
- ✅ Attack type distribution
- ✅ Attack timeline
- ✅ Recent alerts
- ✅ Total unique attackers

---

## 📸 SCREENSHOT:

Send me screenshot of completed dashboard!

---

## 🔄 TO REFRESH DASHBOARD:

```
1. Open dashboard
2. Click: "Refresh" button (or press F5)
3. Click: "Time range" to change time window
```

---

## 💾 TO SAVE DASHBOARD:

Dashboard auto-saves changes. To view later:

```
Dashboards → "IDS Alerts Overview"
```

---

**Dashboard creation complete!** ✅

Now move to: **ATTACK SIMULATION** 👉
