#!/bin/bash

APP_NAME="BetterDisplay"
PREV_STATE=0

while true; do
    # Считаем количество активных разрешений (мониторов)
    MONITOR_COUNT=$(system_profiler SPDisplaysDataType | grep -c "Resolution:")

    if [ "$MONITOR_COUNT" -gt 1 ]; then
        # Монитор подключен
        if [ "$PREV_STATE" -ne 2 ]; then
            open -a "$APP_NAME"
            defaults write com.apple.dock autohide -bool false
            killall Dock
            PREV_STATE=2
        fi
    else
        # Только встроенный экран
        if [ "$PREV_STATE" -ne 1 ]; then
            if pgrep -x "$APP_NAME" > /dev/null; then
                pkill -x "$APP_NAME"
            fi
            defaults write com.apple.dock autohide -bool true
            killall Dock
            PREV_STATE=1
        fi
    fi

    sleep 3
done
