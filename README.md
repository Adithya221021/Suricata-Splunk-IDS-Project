# 🔐 Suricata + Splunk IDS Project

## 📌 Project Overview
Real-time Network Intrusion Detection System (IDS) built using Suricata and Splunk. This project detects network attacks, logs them, and visualizes them in a live security dashboard with automated email alerts.

## 🛠️ Tools Used
- **Suricata 8.0.5** — Open source IDS/IPS engine
- **Splunk Enterprise 10.4.0** — SIEM platform
- **Nmap** — Network scanning tool (attack simulation)
- **Windows 10/11** — Host operating system
- **Gmail SMTP** — Automated email alerts

## 🏗️ Architecture Flow
## ⚙️ Implementation Steps
1. Installed Suricata and registered as Windows Service
2. Configured log output to C:\logs\suricata
3. Installed Splunk Enterprise
4. Connected Splunk to monitor Suricata log files
5. Wrote SPL queries to filter and display alerts
6. Created IPS/IDS Alerts Overview dashboard
7. Configured Gmail SMTP for automated email alerts
8. Tested using Nmap network scanning tool

## 🔍 SPL Query Used
```spl
sourcetype=suricata "Alert:"
| rex "Alert: (?<alert_message>.+)"
| table _time, alert_message
| sort - _time
```

## 📊 Dashboard
- **Suricata Alerts Table** — Shows timestamp and attack type
- **IDS Alerts Bar Chart** — Shows frequency of each attack type

## 🚨 Alerts Detected
- Nmap SYN Scan
- Port Scan
- Service Detection
- OS Detection
- Brute Force Attack
- DDoS Attack
- SQL Injection
- Malware Communication

## 📧 Email Alerts
Configured Splunk to send real-time email notifications using Gmail SMTP with TLS encryption and App Password authentication.

## 📸 Screenshots
See `/screenshots` folder for project screenshots.

## 👨‍💻 Author
Adithya — Cybersecurity Project
