# Simple Windows IDS/IPS Setup
Write-Host "Windows IDS/IPS Setup Starting..." -ForegroundColor Green

# Create log directory
New-Item -ItemType Directory -Path "C:\logs\suricata" -Force
Write-Host "Log directory created: C:\logs\suricata" -ForegroundColor Green

# Check Suricata
$suricataPath = "C:\Program Files\Suricata\suricata.exe"
if (Test-Path $suricataPath) {
    Write-Host "Suricata found at: $suricataPath" -ForegroundColor Green
} else {
    Write-Host "Suricata NOT found!" -ForegroundColor Red
}

# List network adapters
Write-Host "Network Adapters:" -ForegroundColor Yellow
Get-NetAdapter | Select-Object Name, Status

Write-Host "Setup Complete!" -ForegroundColor Green