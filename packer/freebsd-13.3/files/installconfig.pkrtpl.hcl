

GEOM=da0
export ZFSBOOT_DISKS="$GEOM"
export ZFSBOOT_POOL_CREATE_OPTIONS="-O compress=zstd -O atime=off"

export ZFSBOOT_SWAP_ENCRYPTION=1
export nonInteractive="YES"

#!/bin/sh

SSHD_RC_CONF_FILE=/etc/rc.conf
SENDMAIL_RC_CONF_FILE=/etc/rc.conf
SYSCTL_CONF_FILE=/etc/sysctl.conf

# Disable X11
echo 'OPTIONS_UNSET+=X11' >> /etc/make.conf

# Basic network options
sysrc hostname=${hostname}

# Use DHCP to get the network configuration
sysrc ifconfig_DEFAULT=SYNCDHCP

# Enable sshd by default
sysrc -f "$SSHD_RC_CONF_FILE" sshd_enable=YES
# Disable DNS lookups by default to make SSH connect quickly
sed -i '' -e 's/^#UseDNS yes/UseDNS no/' /etc/ssh/sshd_config
# Allow root logins during build.  Deactivated upon cleanup
sed -i '' -e 's/^#PermitRootLogin no/PermitRootLogin yes/' /etc/ssh/sshd_config

# Disable sendmail
sysrc -f "$SENDMAIL_RC_CONF_FILE" sendmail_enable=NONE

# Change root's password to vagrant
echo '${user_password}' | pw usermod root -h 0

# Reboot quickly, don't wait at the panic screen
{
	echo 'debug.trace_on_panic=1'
	echo 'debug.debugger_on_panic=0'
	echo 'kern.panic_reboot_wait_time=0'
} >> "$SYSCTL_CONF_FILE"

# The console is not interactive, so we might as well boot quickly
sysrc -f /boot/loader.conf autoboot_delay=-1

# Reboot
shutdown -r now
