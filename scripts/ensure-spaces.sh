#!/bin/bash
# Check that at least N macOS spaces exist, warn if not
# Usage: ensure-spaces.sh [count]  (default: 9)

DESIRED=${1:-9}
YABAI=/opt/homebrew/bin/yabai
JQ=/opt/homebrew/bin/jq

CURRENT=$($YABAI -m query --spaces | $JQ 'length')

if [ "$CURRENT" -lt "$DESIRED" ]; then
    NEEDED=$(( DESIRED - CURRENT ))
    osascript -e "display notification \"Need $NEEDED more spaces (have $CURRENT, want $DESIRED). Add them in Mission Control.\" with title \"yabai: Spaces Missing\""
fi
