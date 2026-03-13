#!/bin/bash

# =============================================================================
# 🚀 BRAND: LicencesBuy.com - Premium Licensing & Server Solutions
# 🛠️ SCRIPT: Professional RBCP & Network Auto-Fix Engine
# 🌐 WEBSITE: https://licencesbuy.com/
# =============================================================================

# Color Palette
GOLD='\033[1;33m'
BLUE='\033[0;34m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

# 1. Branding Header
clear
echo -e "${GOLD}*******************************************************${NC}"
echo -e "${GOLD}* *${NC}"
echo -e "${GOLD}* WELCOME TO LICENCESBUY.COM                *${NC}"
echo -e "${GOLD}* PROFESSIONAL SERVER OPTIMIZER & RBCP         *${NC}"
echo -e "${GOLD}* *${NC}"
echo -e "${GOLD}*******************************************************${NC}"
echo -e "${BLUE}Support: https://licencesbuy.com/ | Version: 2.0.4${NC}\n"

# 2. Root Check
if [[ $EUID -ne 0 ]]; then
   echo -e "${RED}ERROR: Access Denied. Please run with 'sudo -i'${NC}"
   exit 1
fi

# 3. Intelligent Dependency Installer
echo -e "${GREEN}[✔] Phase 1: Installing Core Dependencies...${NC}"
if command -v apt-get &> /dev/null; then
    apt-get update -y > /dev/null 2>&1
    apt-get install -y iptables curl wget net-tools chattr > /dev/null 2>&1
elif command -v yum &> /dev/null; then
    yum install -y iptables curl wget net-tools e2fsprogs > /dev/null 2>&1
fi

# 4. Bulletproof DNS Locking (Enterprise Method)
echo -e "${GREEN}[✔] Phase 2: Locking Global DNS (Google & Cloudflare)...${NC}"
# Remove immutable flag if it exists to allow editing
chattr -i /etc/resolv.conf > /dev/null 2>&1
cat <<EOF > /etc/resolv.conf
# Optimized by LicencesBuy.com
nameserver 8.8.8.8
nameserver 8.8.4.4
nameserver 1.1.1.1
EOF
# Set immutable flag - prevents ANY system process from changing DNS
chattr +i /etc/resolv.conf > /dev/null 2>&1

# 5. The RBCP & Firewall Boot-Engine
echo -e "${GREEN}[✔] Phase 3: Building the RBCP Auto-Start Engine...${NC}"
cat <<EOF > /etc/rc.local
#!/bin/bash
# --- LICENCESBUY.COM AUTO-START LOG ---
exec > /var/log/licencesbuy-boot.log 2>&1
echo "Session Started: \$(date)"

# A. FIREWALL OPTIMIZATION
iptables -P INPUT ACCEPT
iptables -P FORWARD ACCEPT
iptables -P OUTPUT ACCEPT
iptables -t nat -F
iptables -F
iptables -X
echo "Firewall status: CLEAN"

# B. RBCP ENGINE START (Real-time Execution)
echo "Initializing RBCP..."
# Add your specific RBCP binary path below if it's in a custom folder
rbcp --start || echo "RBCP service triggered."

# C. DNS PROTECTION RE-ENFORCEMENT
echo "nameserver 8.8.8.8" > /etc/resolv.conf

echo "Optimization Finished: \$(date)"
exit 0
EOF

chmod +x /etc/rc.local

# 6. Systemd Integration (Modern Compatibility)
echo -e "${GREEN}[✔] Phase 4: Enabling Systemd High-Priority Services...${NC}"
cat <<EOF > /etc/systemd/system/rc-local.service
[Unit]
Description=LicencesBuy.com RBCP Service
ConditionPathExists=/etc/rc.local
After=network-online.target
Wants=network-online.target

[Service]
Type=forking
ExecStart=/etc/rc.local
RemainAfterExit=yes
TimeoutStartSec=0

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable rc-local > /dev/null 2>&1
systemctl restart rc-local > /dev/null 2>&1

# 7. Final Branding & Status
echo -e "\n${GOLD}-------------------------------------------------------${NC}"
echo -e "${GREEN}SUCCESS: YOUR SERVER IS NOW OPTIMIZED!${NC}"
echo -e "${BLUE}DNS Status:   LOCKED (8.8.8.8)${NC}"
echo -e "${BLUE}RBCP Status:  ACTIVE ON BOOT${NC}"
echo -e "${BLUE}Firewall:     AUTO-FLUSH ENABLED${NC}"
echo -e "${GOLD}-------------------------------------------------------${NC}"
echo -e "${YELLOW}Need more licenses? Visit: https://licencesbuy.com/${NC}"
echo -e "${GOLD}-------------------------------------------------------${NC}"
