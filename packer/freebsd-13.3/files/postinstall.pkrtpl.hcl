#!/bin/sh
set -e

# Set the time
service ntpdate onestart || true

# Update FreeBSD

# Bootstrap pkg
env ASSUME_ALWAYS_YES=yes pkg bootstrap -f

# Upgrade packages

# Upgrade boot partition
fetch -o /tmp https://raw.githubusercontent.com/freebsd/freebsd-src/main/tools/boot/install-boot.sh
sh /tmp/install-boot.sh


VMWARE_GUESTD_RC_CONF_FILE=/etc/rc.conf

pkg install -qy open-vm-tools-nox11

cat >> "$VMWARE_GUESTD_RC_CONF_FILE" <<- END
vmware_guest_vmblock_enable="YES"
vmware_guest_vmmemctl_enable="YES"
vmware_guest_vmxnet_enable="YES"
vmware_guestd_enable="YES"
END

shutdown -r now
