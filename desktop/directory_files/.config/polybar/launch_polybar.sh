#!/bin/bash

SCRIPT_NAME=$0
SCRIPT_FULL_PATH=$(dirname "$0")
POLYBAR_VARIABLE=$(< "${SCRIPT_FULL_PATH}/polybar_setting")

echo $POLYBAR_VARIABLE

if [ "$POLYBAR_VARIABLE" = "1" ]; then
	sh "${SCRIPT_FULL_PATH}/launch.sh"
elif [ "$POLYBAR_VARIABLE" = "2" ]; then
	sh "${SCRIPT_FULL_PATH}/launch_tray.sh"
else
	sh "${SCRIPT_FULL_PATH}/launch.sh"
fi
