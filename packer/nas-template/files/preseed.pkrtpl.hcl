### Setting the locales, country
d-i debian-installer/locale string en_GB
d-i keyboard-configuration/xkb-keymap select us
d-i console-setup/ask_detect boolean false
choose-mirror-bin mirror/http/proxy string

### Clock
d-i clock-setup/utc boolean true
d-i time/zone string Europe/London
d-i netcfg/choose_interface select auto

### Host
d-i netcfg/get_domain string home.lan
d-i netcfg/hostname string deb-x12-template
d-i netcfg/wireless_wep string

### Account setup - Root
d-i passwd/root-password password 
d-i passwd/root-password-again password 

### Account setup - Normal
d-i passwd/user-fullname string ${user_fullname}
d-i passwd/username string ${user_name}
d-i passwd/user-password password ${user_password}
d-i passwd/user-password-again password ${user_password}
d-i passwd/user-uid string 1000

### Mirror settings
# If you select ftp, the mirror/country string does not need to be set.
d-i mirror/country string manual
d-i mirror/http/hostname string deb.debian.org
d-i mirror/http/directory string /debian
d-i mirror/http/proxy string


################################################################## ]]]
## Disk Partitioning/Boot loader [[[
######################################################################

d-i partman-auto/disk string /dev/sda
d-i partman-auto-lvm/guided_size string max
d-i partman-auto/choose_recipe select atomic
d-i partman-auto/method string regular
d-i partman-lvm/confirm boolean true
d-i partman-lvm/confirm_nooverwrite boolean true
d-i partman-lvm/device_remove_lvm boolean true
d-i partman/choose_partition select finish
d-i partman/confirm boolean true
d-i partman/confirm_nooverwrite boolean true
d-i partman-partitioning/choose_label string gpt
d-i partman-partitioning/default_label string gpt
d-i partman/confirm_write_new_label boolean true
d-i partman-efi/non_efi_system boolean true

# The installer will warn about weak passwords. If you are sure you know
# what you're doing and want to override it, uncomment this.
d-i user-setup/allow-password-weak boolean true
d-i user-setup/encrypt-home boolean false

# Disable scanning install image (because netinst)
d-i apt-setup/cdrom/set-first boolean false
d-i apt-setup/cdrom/set-next boolean false
d-i apt-setup/cdrom/set-failed boolean false


### Package selection
popularity-contest popularity-contest/participate boolean false
tasksel tasksel/first multiselect standard
d-i pkgsel/include string openssh-server build-essential open-vm-tools vim bash-completion ca-certificates curl dnsutils git htop iotop net-tools rsync screen software-properties-common tree wget zip
d-i pkgsel/install-language-support boolean false

# disable automatic package updates
d-i pkgsel/update-policy select none
d-i pkgsel/upgrade select full-upgrade

d-i grub-installer/only_debian boolean true
d-i grub-installer/with_other_os boolean true
d-i grub-installer/bootdev string /dev/sda

# ignore the completion message
d-i finish-install/reboot_in_progress note