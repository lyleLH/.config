#!/bin/bash
# Toggle app as floating scratchpad (app must have manage=off in yabairc)
# Usage: scratchpad-app.sh "App Name"

APP_NAME="$1"
YABAI=/opt/homebrew/bin/yabai
JQ=/opt/homebrew/bin/jq

# Get focused window's app name
FOCUSED_APP=$($YABAI -m query --windows --window 2>/dev/null | $JQ -r '.app // empty')

if [ "$FOCUSED_APP" = "$APP_NAME" ]; then
    # App is focused — hide it
    WINDOW_ID=$($YABAI -m query --windows --window | $JQ '.id')
    $YABAI -m window "$WINDOW_ID" --minimize
else
    # Find existing window
    WINDOW_ID=$($YABAI -m query --windows | $JQ -r --arg app "$APP_NAME" '[.[] | select(.app == $app)] | first | .id // empty')
    if [ -n "$WINDOW_ID" ] && [ "$WINDOW_ID" != "null" ]; then
        $YABAI -m window "$WINDOW_ID" --deminimize 2>/dev/null
        CURRENT_SPACE=$($YABAI -m query --spaces --space | $JQ '.index')
        $YABAI -m window "$WINDOW_ID" --space "$CURRENT_SPACE" 2>/dev/null
        $YABAI -m window --focus "$WINDOW_ID" 2>/dev/null
        $YABAI -m window "$WINDOW_ID" --grid 6:6:1:1:4:4 2>/dev/null
    else
        open -a "$APP_NAME"
        for i in $(seq 1 20); do
            sleep 0.2
            WINDOW_ID=$($YABAI -m query --windows | $JQ -r --arg app "$APP_NAME" '[.[] | select(.app == $app)] | first | .id // empty')
            if [ -n "$WINDOW_ID" ] && [ "$WINDOW_ID" != "null" ]; then
                $YABAI -m window "$WINDOW_ID" --grid 6:6:1:1:4:4 2>/dev/null
                break
            fi
        done
    fi
fi
