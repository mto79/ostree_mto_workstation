#!/usr/bin/env bash
#
# Setup script to run after installing Fedora Silverblue and composing custom
# OSTREE image mto-desktop 
# Author: MTO (https://www.mto.nu)

echo "Set hostname to notus"
echo ""
hostnamectl set-hostname notus 
#[notus|boreas|zephyrus|eurus]

echo "Set certificates for duplicati mono (can only be done with flag --user)"
echo ""
cert-sync --user /etc/pki/tls/certs/ca-bundle.crt

echo ""

echo "Flatpak installation"
echo ""
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
flatpak install flathub com.spotify.Client -y
flatpak install flathub com.getpostman.Postman -y
#flatpak install flathub org.mozilla.Thunderbird -y
flatpak install flathub org.fedoraproject.MediaWriter -y
flatpak install flathub com.mattermost.Desktop -y
flatpak install flathub us.zoom.Zoom -y
flatpak install flathub com.bluejeans.BlueJeans -y
flatpak install flathub com.slack.Slack -y
flatpak install flathub com.microsoft.Teams -y
flatpak install flathub com.skype.Client -y
flatpak install flathub com.adobe.Flash-Player-Projector -y
flatpak install flathub com.visualstudio.code -y
flatpak install flathub com.belmoussaoui.Authenticator -y
flatpak install flathub org.chromium.Chromium -y
