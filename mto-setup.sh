#!/usr/bin/env bash
#
# Setup script to run after installing Fedora Silverblue and composing custom
# OSTREE image mto-desktop 
# Author: MTO (https://www.mto.nu)

set -eux
HOSTNAME=notus

echo "Set hostname: $HOSTNAME"
echo "-----------------------"
hostnamectl set-hostname $HOSTNAME 

if [[ ! -e /etc/ostree/remotes.d/$HOSTNAME.conf ]]; then
    echo "Rebase to custom image mto-desktop with remote workstation"
    echo "-----------------------"
    ostree remote add $HOSTNAME file:///var/tmp/repo --no-gpg-verify
    rpm-ostree rebase $HOSTNAME:mto-desktop
fi


echo "Set kernel settings"
echo "-----------------------"
rpm-ostree kargs --append=rd.driver.blacklist=nouveau --append=modprobe.blacklist=nouveau --append=nvidia-drm.modeset=1
systemctl reboot

echo "Create Data locations"
echo "-----------------------"
mkdir -p /var/home/mto/data
mkdir -p /var/home/mto/.ssh/controlmasters




echo "Install Flatpak"
echo "-----------------------"

# echo "Flatpak installation"
# echo ""
# flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
flatpak install flathub com.spotify.Client -y
flatpak install flathub com.getpostman.Postman -y
flatpak install flathub org.fedoraproject.MediaWriter -y
flatpak install flathub us.zoom.Zoom -y
flatpak install flathub com.bluejeans.BlueJeans -y
flatpak install flathub com.slack.Slack -y
flatpak install flathub com.microsoft.Teams -y
flatpak install flathub com.skype.Client -y
flatpak install flathub org.jitsi.jitsi-meet -y
flatpak install flathub com.mattermost.Desktop -y
flatpak install flathub com.belmoussaoui.Authenticator -y
flatpak install flathub org.libreoffice.LibreOffice -y 
flatpak install flathub org.gnome.Shotwell -y

echo "Libvirt: Prevenpassword prompts for each and every libvirt action, install the following polkit rule."
echo "-----------------------"

sudo tee /etc/polkit-1/rules.d/80-libvirt.rules <<EOF
polkit.addRule(function(action, subject) {
 if (action.id == "org.libvirt.unix.manage" && subject.local && subject.active && subject.isInGroup("wheel")) {
 return polkit.Result.YES;
 }
});
EOF
