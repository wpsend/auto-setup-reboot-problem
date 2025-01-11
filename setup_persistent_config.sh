#!/bin/bash

# Update /etc/resolv.conf for DNS configuration
echo "nameserver 8.8.8.8" > /etc/resolv.conf
echo "nameserver 8.8.4.4" >> /etc/resolv.conf

# Make sure the resolv.conf changes persist after reboot
cat <<EOF > /etc/systemd/resolved.conf
[Resolve]
DNS=8.8.8.8 8.8.4.4
FallbackDNS=1.1.1.1 1.0.0.1
EOF
systemctl restart systemd-resolved

# Create /etc/rc.local with iptables flush commands
cat <<EOF > /etc/rc.local
#!/bin/bash
iptables -F
iptables -X
exit 0
EOF

# Make /etc/rc.local executable and enable it to start on boot
chmod +x /etc/rc.local
systemctl enable rc-local
systemctl start rc-local

echo "Configuration applied successfully and will persist across reboots."
