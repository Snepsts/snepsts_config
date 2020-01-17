#!/bin/bash

# Terminate any already running polybars
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Launch polybar
echo "---" | tee -a /tmp/polybar.log
polybar top >>/tmp/polybar_top.log 2>&1 &
polybar right >>/tmp/polybar_right.log 2>&1 &

echo "Polybar launched"
