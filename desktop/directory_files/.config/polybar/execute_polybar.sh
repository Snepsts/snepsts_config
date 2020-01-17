#!/bin/bash

SCRIPT_NAME=$0
SCRIPT_FULL_PATH=$(dirname "$0")
POLYBAR_TRAY=$(< "${SCRIPT_FULL_PATH}/polybar_tray_setting")
POLYBAR_MULTI=$(< "${SCRIPT_FULL_PATH}/polybar_multi_monitor_setting")

if [ "$POLYBAR_TRAY" = "1" ] && [ "$POLYBAR_MULTI" = "1" ]; then
	sh "${SCRIPT_FULL_PATH}/launch_multi_tray.sh"
elif [ "$POLYBAR_TRAY" = "0" ] && [ "$POLYBAR_MULTI" = "1" ]; then
	sh "${SCRIPT_FULL_PATH}/launch_multi.sh"
elif [ "$POLYBAR_TRAY" = "1" ] && [ "$POLYBAR_MULTI" = "0" ]; then
	sh "${SCRIPT_FULL_PATH}/launch_single_tray.sh"
elif [ "$POLYBAR_TRAY" = "0" ] && [ "$POLYBAR_MULTI" = "0" ]; then
	sh "${SCRIPT_FULL_PATH}/launch_single.sh"
else
	sh "${SCRIPT_FULL_PATH}/launch_single.sh"
fi
