#!/bin/bash

# Only exported variables can be used within the timer's command.
export PRIMARY_DISPLAY="$(xrandr | awk '/ primary/{print $1}')"

# Run xidlehook
xidlehook \
  `# Don't lock when there's a fullscreen application` \
  --not-when-fullscreen \
  `# Don't lock when there's audio playing` \
  --not-when-audio \
  `# Dim the screen after 60 seconds, undim if user becomes active` \
  --timer 300 \
    'xrandr --output "$PRIMARY_DISPLAY" --brightness .1 --crtc 0;
     xrandr --ouptut "$PRIMARY_DISPLAY" --brightness .1 --crtc 1;
     xrandr --ouptut "$PRIMARY_DISPLAY" --brightness .1 --crtc 2' \
    'xrandr --output "$PRIMARY_DISPLAY" --brightness 1 --crtc 0;
     xrandr --output "$PRIMARY_DISPLAY" --brightness 1 --crtc 1;
     xrandr --output "$PRIMARY_DISPLAY" --brightness 1 --crtc 2' \
  `# Undim & lock after 10 more seconds` \
  --timer 300 \
    'xrandr --output "$PRIMARY_DISPLAY" --brightness 1 --crtc 0;
     xrandr --output "$PRIMARY_DISPLAY" --brightness 1 --crtc 1;
     xrandr --output "$PRIMARY_DISPLAY" --brightness 1 --crtc 2;
     blurlock' \
    ''
 
