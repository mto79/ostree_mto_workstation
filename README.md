MTO desktop
=====================

Basic setup

## Silverblue
Install Silverblue with encryption on disk.

## 
cd /var/home/mto 
git clone https://github.com/mto79/ostree_mto_workstation.git  

git clone git@github.com:mto79/ostree_mto_workstation.git (for ssh you need
private key )

Download the local rpms in the directory local-rpms.
There will be bash script to be made


cd ostree_mto_workstation
sudo ./mto-compose.sh

sudo ./mto-setup.sh

# to be place in mto-setup.sh 
sudo ostree remote add mto-workstation file:///var/tmp/repo --no-gpg-verify
sudo rpm-ostree rebase mto-workstation:mto-desktop

sudo rpm-ostree upgrade (--allow-downgrade) when timestamps are not correct.

## Import data
While needing some encrypted data it is can handy to have the crdentials before proceeding.

Dulplicati


## Chezmoi
chezmoi init
chezmoi cd
git branch --show-current
git branch -m main
git branch --show-current
git config --local init.defaultBranch main
git remote add origin https://github.com/mto79/dotfiles.git

git config --global user.email "marc@mto.nu"
git config --global user.name "mto"
