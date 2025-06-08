#!/bin/bash

set -e

echo "Installing dnf-automatic..."
dnf install -y dnf-automatic

echo "Configuring dnf-automatic..."

CONFIG_FILE="/etc/dnf/automatic.conf"

# Backup original config
cp "$CONFIG_FILE" "${CONFIG_FILE}.bak"

# Overwrite the config with desired settings
cat <<CONF > "$CONFIG_FILE"
[commands]
upgrade_type = security
download_updates = yes
apply_updates = yes
random_sleep = 0
reboot = when-needed
reboot_when_needed = true

[emitters]
emit_via = motd

[email]
email_from = root@localhost
email_to = root@localhost
email_host = localhost

[base]
debuglevel = 1
CONF

echo "Enabling and starting dnf-automatic timer..."
systemctl enable --now dnf-automatic.timer

echo "Done. dnf-automatic is now configured to install security updates and reboot if needed."