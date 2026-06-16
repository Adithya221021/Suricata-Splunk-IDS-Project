# Splunk on Windows - Automated Setup Script
# Run as Administrator
# Purpose: Configure Firewall, Network inputs, and basic Splunk setup

#Requires -RunAsAdministrator

param(
    [string]$SplunkPath = "C:\Program Files\Splunk",
    [string]$SyslogPort = 514,
    [string]$WebPort = 8000
)

Write-Host "╔════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║  Splunk on Windows - Setup Automation Script               ║" -ForegroundColor Cyan
Write-Host "║  IDS/IPS with Suricata Integration                         ║" -ForegroundColor Cyan
Write-Host "╚════════════════════════════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host ""

# Function to check if Splunk is installed
function Test-SplunkInstallation {
    if (Test-Path "$SplunkPath\bin\splunk.exe") {
        Write-Host "✓ Splunk Enterprise found at: $SplunkPath" -ForegroundColor Green
        return $true
    } else {
        Write-Host "✗ Splunk not found. Please install first from:" -ForegroundColor Red
        Write-Host "  https://www.splunk.com/en_us/download/splunk-enterprise.html" -ForegroundColor Yellow
        return $false
    }
}

# Function to configure Windows Firewall
function Set-FirewallRules {
    Write-Host "`n[1] Configuring Windows Firewall Rules..." -ForegroundColor Yellow
    
    try {
        # Allow Syslog input (UDP 514)
        Write-Host "  → Adding UDP 514 (Syslog) rule..." -ForegroundColor White
        netsh advfirewall firewall add rule name="Splunk Syslog Input (UDP 514)" `
            dir=in action=allow protocol=udp localport=$SyslogPort | Out-Null
        
        # Allow Splunk Web (TCP 8000)
        Write-Host "  → Adding TCP 8000 (Splunk Web) rule..." -ForegroundColor White
        netsh advfirewall firewall add rule name="Splunk Web (TCP 8000)" `
            dir=in action=allow protocol=tcp localport=$WebPort | Out-Null
        
        # Allow Splunk Receiver (TCP 9997) - for distributed setup
        Write-Host "  → Adding TCP 9997 (Splunk Receiver) rule..." -ForegroundColor White
        netsh advfirewall firewall add rule name="Splunk Receiver (TCP 9997)" `
            dir=in action=allow protocol=tcp localport=9997 | Out-Null
        
        Write-Host "✓ Firewall rules configured successfully" -ForegroundColor Green
    } catch {
        Write-Host "✗ Error configuring firewall: $_" -ForegroundColor Red
    }
}

# Function to start Splunk service
function Start-SplunkService {
    Write-Host "`n[2] Starting Splunk Service..." -ForegroundColor Yellow
    
    try {
        $service = Get-Service SplunkD -ErrorAction SilentlyContinue
        if ($null -eq $service) {
            Write-Host "✗ SplunkD service not found. Installing..." -ForegroundColor Yellow
            & "$SplunkPath\bin\splunk.exe" show default-hostname
        }
        
        if ((Get-Service SplunkD).Status -eq "Running") {
            Write-Host "✓ SplunkD service is already running" -ForegroundColor Green
        } else {
            Start-Service SplunkD
            Start-Sleep -Seconds 3
            Write-Host "✓ SplunkD service started" -ForegroundColor Green
        }
    } catch {
        Write-Host "✗ Error starting Splunk service: $_" -ForegroundColor Red
    }
}

# Function to create inputs.conf for Suricata logs
function Set-SplunkNetworkInput {
    Write-Host "`n[3] Configuring Splunk Network Input (UDP 514)..." -ForegroundColor Yellow
    
    try {
        $inputsConfPath = "$SplunkPath\etc\system\local\inputs.conf"
        $inputsLocalPath = "$SplunkPath\etc\apps\suricata_app\default\inputs.conf"
        
        # Create default inputs configuration
        $inputsConfig = @"
[udp://0.0.0.0:514]
connection_host = ip
sourcetype = suricata
index = main
disabled = false

[splunktcp-ssl:8089]
disabled = false
"@
        
        # Ensure directory exists
        $dir = Split-Path -Parent $inputsLocalPath
        if (-not (Test-Path $dir)) {
            New-Item -ItemType Directory -Path $dir -Force | Out-Null
        }
        
        Set-Content -Path $inputsLocalPath -Value $inputsConfig
        Write-Host "✓ inputs.conf created at: $inputsLocalPath" -ForegroundColor Green
    } catch {
        Write-Host "✗ Error creating inputs.conf: $_" -ForegroundColor Red
    }
}

# Function to verify network connectivity
function Test-NetworkConnectivity {
    Write-Host "`n[4] Testing Network Connectivity..." -ForegroundColor Yellow
    
    try {
        $listening = netstat -ano | findstr ":514.*LISTENING"
        if ($listening) {
            Write-Host "✓ Splunk is listening on UDP 514" -ForegroundColor Green
        } else {
            Write-Host "⚠ UDP 514 not in listening state. Restart Splunk service." -ForegroundColor Yellow
        }
        
        $webListener = netstat -ano | findstr ":8000.*LISTENING"
        if ($webListener) {
            Write-Host "✓ Splunk Web is listening on TCP 8000" -ForegroundColor Green
        }
    } catch {
        Write-Host "✗ Error checking network: $_" -ForegroundColor Red
    }
}

# Function to display next steps
function Show-NextSteps {
    Write-Host "`n╔════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
    Write-Host "║  SETUP COMPLETE - Next Steps                               ║" -ForegroundColor Cyan
    Write-Host "╚════════════════════════════════════════════════════════════╝" -ForegroundColor Cyan
    
    Write-Host @"

1. ACCESS SPLUNK WEB
   → Open browser: http://localhost:8000
   → Default credentials: admin / changeme
   → Change admin password on first login

2. INSTALL SURICATA ADD-ON
   → Download from: https://splunkbase.splunk.com/app/2814/
   → Splunk Web → Apps → Install from file
   → Select the downloaded file and install

3. CREATE SURICATA VM (Ubuntu/CentOS)
   → Follow the guide for VM setup with Suricata
   → Configure rsyslog to forward to: <YOUR_WINDOWS_IP>:514

4. VERIFY LOG FLOW
   → In Splunk: Settings → Data Inputs → Network & Security
   → Should show UDP 514 active
   → Search: sourcetype=suricata to see incoming logs

5. CREATE DASHBOARDS
   → Follow the guide for dashboard creation
   → Use provided search queries
   → Customize for your environment

6. CONFIGURE ALERTS
   → Settings → Alert Actions → Email
   → Configure SMTP details
   → Create searches with alert actions

7. RUN ATTACK SIMULATIONS
   → Use isolated network/VLAN
   → Run nmap, hydra, or other attack tools
   → Verify detection in Splunk dashboards

IMPORTANT FILES:
   → Installation Guide: Windows_IDS_IPS_Implementation_Guide.md
   → Log directory: $SplunkPath\var\log\splunk
   → Config directory: $SplunkPath\etc\system\local

MONITORING SERVICE HEALTH:
   → PowerShell: Get-Service SplunkD | Select Status
   → Restart: Restart-Service SplunkD
   → Logs: $SplunkPath\var\log\splunk\*.log

SECURITY NOTES:
   → Restrict Splunk Web access to authorized IPs only
   → Change default admin password immediately
   → Keep Splunk and rule sets updated
   → Enable TLS/SSL for external connections

"@ -ForegroundColor White
}

# Main execution
function Main {
    # Check prerequisites
    if (-not (Test-SplunkInstallation)) {
        exit 1
    }
    
    # Run setup steps
    Set-FirewallRules
    Start-SplunkService
    Set-SplunkNetworkInput
    Test-NetworkConnectivity
    
    Write-Host ""
    Write-Host "Splunk Status:" -ForegroundColor Cyan
    Get-Service SplunkD | Select-Object Name, Status, StartType
    
    Show-NextSteps
}

# Run main function
Main
