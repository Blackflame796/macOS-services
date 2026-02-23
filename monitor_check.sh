#!/usr/bin/env bash

MONITOR_NAME="MSI MP243X"
APP_NAME="BetterDisplay"

if system_profiler SPDisplaysDataType | grep -q "$MONITOR_NAME"; then
    # Монитор подключен
    if ! pgrep -f "$APP_NAME" > /dev/null; then
        open -j -a "$APP_NAME"
        echo "Монитор $MONITOR_NAME подключен - запускаем $APP_NAME"
    else
        echo "Монитор $MONITOR_NAME подключен - $APP_NAME уже запущен"
    fi
else
    # Монитор НЕ подключен
    if pgrep -f "$APP_NAME" > /dev/null; then
        # Завершаем приложение (мягко)
        osascript -e "quit app \"$APP_NAME\"" 2>/dev/null
        
        # Если не закрылось мягко - убиваем процесс
        sleep 1
        if pgrep -f "$APP_NAME" > /dev/null; then
            pkill -f "$APP_NAME"
            echo "Монитор $MONITOR_NAME отключен - принудительно завершаем $APP_NAME"
        else
            echo "Монитор $MONITOR_NAME отключен - завершаем $APP_NAME"
        fi
    else
        echo "Монитор $MONITOR_NAME отключен - $APP_NAME не запущен"
    fi
fi

exit 0
