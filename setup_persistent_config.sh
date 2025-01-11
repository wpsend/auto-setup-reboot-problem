#!/bin/bash

# Step 1: Configure /etc/resolv.conf for DNS
echo "nameserver 8.8.8.8" > /etc/resolv.conf
echo "nameserver 8.8.4.4" >> /etc/resolv.conf

# Ensure resolv.conf changes persist after reboot
cat <<EOF > /etc/systemd/resolved.conf
[Resolve]
DNS=8.8.8.8 8.8.4.4
FallbackDNS=1.1.1.1 1.0.0.1
EOF
systemctl restart systemd-resolved

# Step 2: Create /etc/rc.local with custom commands
cat <<EOF > /etc/rc.local
#!/bin/bash
iptables -F
iptables -X
echo "nameserver 8.8.8.8" > /etc/resolv.conf
echo "nameserver 8.8.4.4" >> /etc/resolv.conf
exit 0
EOF

# Step 3: Make /etc/rc.local executable
chmod +x /etc/rc.local

# Step 4: Enable rc-local service
cat <<EOF > /etc/systemd/system/rc-local.service
[Unit]
Description=/etc/rc.local Compatibility
ConditionPathExists=/etc/rc.local
After=network.target

[Service]
Type=forking
ExecStart=/etc/rc.local
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
EOF

# Enable and start rc-local service
systemctl enable rc-local
systemctl start rc-local

echo "Setup complete! Your commands will now run automatically after every reboot."
