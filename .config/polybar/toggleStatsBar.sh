#!/bin/bash

MONS=$(xrandr | grep '\bconnected')
readarray -t MONITORS <<<"$MONS"

XMOUSE=$(xdotool getmouselocation | awk -F "[: ]" '{print $2}')
YMOUSE=$(xdotool getmouselocation | awk -F "[: ]" '{print $4}')

for mon in "${MONITORS[@]}"; do

    MONDIM=$(echo ${mon} | grep -o '[0-9]*x[0-9]*[+-][0-9]*[+-][0-9]*')
    
    MONW=$(echo ${MONDIM} | awk -F "[x+]" '{print $1}')
    MONH=$(echo ${MONDIM} | awk -F "[x+]" '{print $2}')
    MONX=$(echo ${MONDIM} | awk -F "[x+]" '{print $3}')
    MONY=$(echo ${MONDIM} | awk -F "[x+]" '{print $4}')
    
    if (( ${XMOUSE} >= ${MONX} )); then
        if (( ${XMOUSE} <= ${MONX}+${MONW} )); then
            if (( ${YMOUSE} >= ${MONY} )); then
                if (( ${YMOUSE} <= ${MONY}+${MONH} )); then
                    #We have found our monitor!
                    MONITOR=$(echo ${mon} | awk '{print $1}')
                   
                    PID=$(ps axe | grep "polybar stats" | grep -v "grep" | grep "\bMONITOR\=${MONITOR}" | awk '{print $1}')
                    
                    if [ -z "$PID" ]; then
                        (export MONITOR && polybar stats &)
                    else
                        kill -9 $PID
                    fi
                fi
            fi
        fi
    fi
done

