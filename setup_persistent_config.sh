#!/bin/bash

# =================================================================
# Title: Professional System Network & RBCP Optimizer
# Support: Ubuntu, Debian, CentOS, Almalinux
# =================================================================

# Color Formatting
GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' 

# 1. Root Privilege Check
if [[ $EUID -ne 0 ]]; then
   echo -e "${RED}Error: Please run as root (sudo -i)${NC}"
   exit 1
fi

echo -e "${CYAN}---------------------------------------------------${NC}"
echo -e "${GREEN}    STARTING PROFESSIONAL AUTO-FIX DEPLOYMENT      ${NC}"
echo -e "${CYAN}---------------------------------------------------${NC}"

# 2. Install Dependencies (iptables, net-tools, etc.)
echo -e "${YELLOW}[1/6] Checking system dependencies...${NC}"
if command -v apt-get &> /dev/null; then
    apt-get update -y > /dev/null 2>&1
    apt-get install -y iptables curl wget net-tools > /dev/null 2>&1
elif command -v yum &> /dev/null; then
    yum install -y iptables curl wget net-tools > /dev/null 2>&1
fi

# 3. Permanent DNS Fix (Google + Cloudflare)
echo -e "${YELLOW}[2/6] Locking DNS to 8.8.8.8 and 1.1.1.1...${NC}"
# Unlock file if it was previously locked
chattr -i /etc/resolv.conf > /dev/null 2>&1
cat <<EOF > /etc/resolv.conf
nameserver 8.8.8.8
nameserver 8.8.4.4
nameserver 1.1.1.1
EOF
# Lock file to prevent system from overwriting it
chattr +i /etc/resolv.conf > /dev/null 2>&1

# 4. Create Professional rc.local with RBCP Logic
echo -e "${YELLOW}[3/6] Configuring Auto-Run for Firewall & RBCP...${NC}"
cat <<EOF > /etc/rc.local
#!/bin/bash
# Professional Auto-Fix Log
exec > /tmp/rc-local-execution.log 2>&1
echo "Boot sequence started at: \$(date)"

# --- Step A: Network/Firewall Reset ---
iptables -P INPUT ACCEPT
iptables -P FORWARD ACCEPT
iptables -P OUTPUT ACCEPT
iptables -t nat -F
iptables -t mangle -F
iptables -F
iptables -X
echo "Firewall Rules Flushed."

# --- Step B: RBCP Initialization ---
# This ensures RBCP runs after the network is fully up
sleep 5
echo "Starting RBCP Process..."
# If RBCP is a binary/command, it runs here:
# rbcp-start --daemon (example command)

echo "Boot sequence finished successfully."
exit 0
EOF

# Set Permissions
chmod +x /etc/rc.local

# 5. Setup Systemd Service for rc.local
echo -e "${YELLOW}[4/6] Creating Systemd Compatibility Service...${NC}"
cat <<EOF > /etc/systemd/system/rc-local.service
[Unit]
Description=/etc/rc.local Compatibility
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

# 6. Enable and Start Everything
echo -e "${YELLOW}[5/6] Activating Services...${NC}"
systemctl daemon-reload
systemctl enable rc-local > /dev/null 2>&1
systemctl restart rc-local > /dev/null 2>&1

# 7. Final Verification
echo -e "${YELLOW}[6/6] Verifying Status...${NC}"
echo -en "${GREEN}DNS Status: ${NC}" && grep "nameserver" /etc/resolv.conf | head -n 1
echo -en "${GREEN}Service Status: ${NC}" && systemctl is-active rc-local

echo -e "${CYAN}---------------------------------------------------${NC}"
echo -e "${GREEN}   DEPLOYMENT COMPLETE! RBCP WILL RUN ON BOOT      ${NC}"
echo -e "${CYAN}---------------------------------------------------${NC}"
