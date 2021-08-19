#!/usr/bin/env bash
set -xeuo pipefail

# Enable SysRQ
echo 'kernel.sysrq = 1' > /usr/lib/sysctl.d/90-sysrq.conf

# power saving
# echo 'blacklist e1000e' > /usr/lib/modprobe.d/blacklist-local.conf

# NetworkManager config
cat <<EOF > /usr/lib/NetworkManager/conf.d/local.conf
[main]
plugins=

[device]
#wifi.backend=iwd
EOF
#ln -sfn ../iwd.service /usr/lib/systemd/system/multi-user.target.wants/iwd.service

ln -sfn /run/systemd/resolve/stub-resolv.conf /etc/resolv.conf

# set up PAM for systemd-homed (https://bugzilla.redhat.com/show_bug.cgi?id=1806949)
patch /etc/pam.d/system-auth <<EOF
--- /usr/etc/pam.d/system-auth	1970-01-01 01:00:00.000000000 +0100
+++ /etc/pam.d/system-auth	2020-04-13 14:31:16.866558333 +0200
@@ -3,16 +3,20 @@
 # User changes will be destroyed the next time authselect is run.
 auth        required      pam_env.so
 auth        sufficient    pam_unix.so try_first_pass nullok
+-auth     sufficient pam_systemd_home.so                                  # added
 auth        required      pam_deny.so

-account     required      pam_unix.so
+account     sufficient    pam_unix.so
+-account  sufficient pam_systemd_home.so                                  # added

 password    requisite     pam_pwquality.so try_first_pass local_users_only retry=3 authtok_type=
 password    sufficient    pam_unix.so try_first_pass use_authtok nullok sha512 shadow
+-password sufficient pam_systemd_home.so                                  # added
 password    required      pam_deny.so

 session     optional      pam_keyinit.so revoke
 session     required      pam_limits.so
+-session  optional   pam_systemd_home.so                                  # added
 -session     optional      pam_systemd.so
 session     [success=1 default=ignore] pam_succeed_if.so service in crond quiet use_uid
 session     required      pam_unix.so
EOF
patch /etc/pam.d/password-auth <<EOF
--- password-auth
+++ password-auth
@@ -3,16 +3,20 @@
 # User changes will be destroyed the next time authselect is run.
 auth        required      pam_env.so
 auth        sufficient    pam_unix.so try_first_pass nullok
+-auth       sufficient    pam_systemd_home.so            # added
 auth        required      pam_deny.so

-account     required      pam_unix.so
+account     sufficient    pam_unix.so
+-account  sufficient pam_systemd_home.so                 # added

 password    requisite     pam_pwquality.so try_first_pass local_users_only retry=3 authtok_type=
 password    sufficient    pam_unix.so try_first_pass use_authtok nullok sha512 shadow
+-password   sufficient    pam_systemd_home.so            # added
 password    required      pam_deny.so

 session     optional      pam_keyinit.so revoke
 session     required      pam_limits.so
+-session    optional      pam_systemd_home.so            # added
 -session     optional      pam_systemd.so
 session     [success=1 default=ignore] pam_succeed_if.so service in crond quiet use_uid
 session     required      pam_unix.so
EOF

# homed is missing a lot of SELinux policy (https://bugzilla.redhat.com/show_bug.cgi?id=1809878)
# "disabled" breaks rpm-ostree (https://bugzilla.redhat.com/show_bug.cgi?id=1882933), so just use permissive
sed -i 's/SELINUX=enforcing/SELINUX=permissive/' /etc/selinux/config

# enable other units
mkdir -p /usr/lib/systemd/system/getty.target.wants
ln -s ../getty@.service /usr/lib/systemd/system/getty.target.wants/getty@tty1.service
ln -s ../systemd-timesyncd.service /usr/lib/systemd/system/sysinit.target.wants/systemd-timesyncd.service
ln -s ../systemd-homed.service /usr/lib/systemd/system/multi-user.target.wants/systemd-homed.service
ln -s ../systemd-resolved.service /usr/lib/systemd/system/multi-user.target.wants/systemd-resolved.service
ln -s ../cockpit.socket /usr/lib/systemd/system/sockets.target.wants/cockpit.socket
ln -s ../sshd.socket /usr/lib/systemd/system/sockets.target.wants/sshd.socket

# disable unwanted services
ln -sfn /dev/null /usr/lib/systemd/user/at-spi-dbus-bus.service

# move OS systemd unit defaults to /usr
cp -a --verbose /etc/systemd/system /etc/systemd/user /usr/lib/systemd/
rm -r /etc/systemd/system /etc/systemd/user

# avoid LVM spew in /etc
sed -i 's/backup = 1/backup = 0/; s/archive = 1/archive = 0/' /etc/lvm/lvm.conf

# update for Red Hat certificate
ln -s /etc/pki/ca-trust/source/anchors/2015-RH-IT-Root-CA.pem /etc/pki/tls/certs/2015-RH-IT-Root-CA.pem
update-ca-trust
