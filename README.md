MTO desktop
=====================

Basic setup

## Silverblue
Install Silverblue with encryption on disk.

## 
cd /var/home/mto 
git clone https://github.com/mto79/ostree_mto_workstation.git  

git clone git@github.com:mto79/ostree_mto_workstation.git (for ssh you need private key )

Download the local rpms in the directory local-rpms.
There will be bash script to be made


cd ostree_mto_workstation
sudo ./mto-compose.sh

sudo ./mto-setup.sh

# to be place in mto-setup.sh 
sudo ostree remote add mto-workstation file:///var/tmp/repo --no-gpg-verify
sudo rpm-ostree rebase mto-workstation:mto-desktop

sudo rpm-ostree upgrade (--allow-downgrade) when timestamps are not correct.

# 
sudo rpm-ostree kargs --append=rd.driver.blacklist=nouveau --append=modprobe.blacklist=nouveau --append=nvidia-drm.modeset=1
systemctl reboot

## Import data
While needing some encrypted data it is can handy to have the crdentials before proceeding.

Dulplicati

## Set GPG key

Import gpg key 
```console
gpg --list-keys
gpg --import private key
gpg --list-keys
gpg --list-secret-keys --keyid-format long
```

You can set every key to ultimate trust through opening the key edit command line
```console
gpg --edit-key [key-id]
```
and running the trust command. You will now be prompted to select the trust level:
```console
lease decide how far you trust this user to correctly verify other users' keys
(by looking at passports, checking fingerprints from different sources, etc.)

  1 = I don't know or won't say
  2 = I do NOT trust
  3 = I trust marginally
  4 = I trust fully
  5 = I trust ultimately
  m = back to the main menu

Your decision? 
```

=> 5

## Get password repo

git clone https://github.com/mto79/password-store.git .password-store

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

cp chezmoi.toml ~/.config/chezmoi/
chmod 600 ~/.config/chezmoi/
chezmoi add --autotemplate ~/.gitconfig

