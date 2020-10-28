#!/bin/bash

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Launch on every monitor polybar can see, using default config location ~/.config/polybar/config
MONS=$(polybar -m | cut -f 1 -d ":")
readarray -t MONITORS <<<"$MONS"

for mon in "${MONITORS[@]}"; do
     MONITOR=$mon
     (export MONITOR && polybar topleft &)
     (export MONITOR && polybar topright &)
     (export MONITOR && polybar spotify &)
done


echo "Polybar launched..."
