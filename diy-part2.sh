#!/bin/bash
#
# Post-execution script for updates and feed installations
#

# 1. Modify the default IP address
# sed -i 's/192.168.1.1/192.168.5.1/g' package/base-files/files/bin/config_generate

# 2. Clear the login password
sed -i 's/$1$V4UetPzk$CYXluq4wUazHjmCDBCqXF.//g' package/lean/default-settings/files/zzz-default-settings

# 3. Modify the hostname
# sed -i 's/OpenWrt/OpenWrt-Router/g' package/base-files/files/bin/config_generate

# 4. Install AdGuardHome package
ADGUARD_PACKAGE="package/luci-app-adguardhome"
if [ ! -d "$ADGUARD_PACKAGE" ]; then
  git clone --depth 1 https://github.com/rufengsuixing/luci-app-adguardhome.git "$ADGUARD_PACKAGE"
  echo "AdGuardHome package cloned to $ADGUARD_PACKAGE"
else
  echo "AdGuardHome package already exists in $ADGUARD_PACKAGE"
fi

# 5. Create iPerf3 startup script for OpenWrt
IPERF_INIT_SCRIPT="package/base-files/files/etc/init.d/iperf3"
if [ ! -f "$IPERF_INIT_SCRIPT" ]; then
  cat >"$IPERF_INIT_SCRIPT" <<'EOF'
#!/bin/sh /etc/rc.common
# OpenWrt init script for iPerf3

START=90

start() {
    echo "Starting iPerf3 server..."
    /usr/bin/iperf3 -s -D
}

stop() {
    echo "Stopping iPerf3 server..."
    killall iperf3
}

restart() {
    stop
    start
}
EOF
  chmod +x "$IPERF_INIT_SCRIPT"
  echo "iPerf3 init script created at $IPERF_INIT_SCRIPT"
else
  echo "iPerf3 init script already exists at $IPERF_INIT_SCRIPT"
fi

# 6. Modify the menu location for luci-app-zerotier
LUCI_ZEROTIER_CONTROLLER_PATH="feeds/luci/applications/luci-app-zerotier/luasrc/controller/zerotier.lua"
# Ensure the controller file exists
if [ -f "$LUCI_ZEROTIER_CONTROLLER_PATH" ]; then
  # Change the menu entry from "VPN" to "Services"
  sed -i 's/vpn/services/g' "$LUCI_ZEROTIER_CONTROLLER_PATH"
  echo "The luci-app-zerotier menu has been moved to Services."
else
  echo "Warning: $LUCI_ZEROTIER_CONTROLLER_PATH not found!"
fi
