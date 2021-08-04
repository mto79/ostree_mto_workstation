MTO desktop
=====================

Basic setup


Install Silverblue with encryption on disk.

cd /var/home/mto 
git clone https://github.com/mto79/ostree_mto_workstation.git  

git clone git@github.com:mto79/ostree_mto_workstation.git (for ssh you need
private key )

cd ostree_mto_workstation
sudo ./compose.sh

sudo ostree remote add mto-workstation file:///var/tmp/repo --no-gpg-verify
sudo rpm-ostree rebase mto-workstation:mto-desktop

