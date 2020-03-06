#!/bin/bash
#SUDO_ASKPASS=~/.scripts/dpass.sh sudo -A $(dmenu_path | dmenu)

#option=$(lsblk -pldno NAME,SIZE | dmenu)
#disk=$(echo $option | awk '{print $1}')

sudo cryptsetup luksOpen /dev/sdc USBDrive
sudo mount /dev/mapper/USBDrive /USBDrive

# Unmount mount first
#~/.scripts/dpass.sh sudo -A $(umount /USBDrive)
#~/.scripts/dpass.sh sudo -A $(cryptsetup luksClose USBDrive)
