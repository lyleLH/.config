#!/bin/bash
# Hyprland-style scratchpad: toggle a dedicated space (default: space 9)
# Usage:
#   scratchpad.sh toggle   — switch to/from scratchpad space
#   scratchpad.sh move     — move current window to scratchpad space

SCRATCHPAD_SPACE=9
STATE_FILE="/tmp/yabai-scratchpad-last-space"
YABAI=/opt/homebrew/bin/yabai
JQ=/opt/homebrew/bin/jq

current_space() {
    $YABAI -m query --spaces --space | $JQ '.index'
}

ensure_scratchpad_space() {
    TOTAL=$($YABAI -m query --spaces | $JQ 'length')
    while [ "$TOTAL" -lt "$SCRATCHPAD_SPACE" ]; do
        $YABAI -m space --create
        TOTAL=$(( TOTAL + 1 ))
    done
    $YABAI -m space "$SCRATCHPAD_SPACE" --label scratchpad 2>/dev/null
}

ensure_scratchpad_space

case "${1:-toggle}" in
    toggle)
        CURRENT=$(current_space)
        if [ "$CURRENT" -eq "$SCRATCHPAD_SPACE" ]; then
            if [ -f "$STATE_FILE" ]; then
                LAST=$(cat "$STATE_FILE")
                $YABAI -m space --focus "$LAST"
            else
                $YABAI -m space --focus 1
            fi
            rm -f "$STATE_FILE"
        else
            echo "$CURRENT" > "$STATE_FILE"
            $YABAI -m space --focus "$SCRATCHPAD_SPACE"
        fi
        ;;
    move)
        $YABAI -m window --space "$SCRATCHPAD_SPACE"
        ;;
    *)
        echo "Usage: scratchpad.sh [toggle|move]"
        exit 1
        ;;
esac
