#!/bin/bash

DRIVE=$(ls /dev/sd* | grep -v 'sda' | rofi -dmenu -no-fixed-num-lines -p "Select Drive to Mount")

if [ -n "$DRIVE" ]; then
    UUID=$(lsblk --noheadings --raw -o UUID,PATH | grep "$DRIVE" | cut -f1 -d" ")

    PASS=$(rofi -dmenu -password -i -no-fixed-num-lines -p "USB Password:")

    pkexec bash -c "echo -n $PASS | cryptsetup luksOpen $DRIVE luks-$UUID -d - && mount /dev/mapper/luks-$UUID /mnt/USB"

    notify-send "Drive has been mounted!"
fi
