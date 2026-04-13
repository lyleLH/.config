#!/bin/bash
# F21 handler: trigger Xcode build from any app, then notify on completion

# Save current yabai window ID before switching
PREV_WIN_ID=$(/opt/homebrew/bin/yabai -m query --windows --window 2>/dev/null | python3 -c "import sys,json; print(json.load(sys.stdin).get('id',''))" 2>/dev/null)

# Switch to Xcode, send Cmd+R, wait for keystroke to land
osascript << 'EOF'
tell application "Xcode" to activate
delay 0.5
tell application "System Events" to keystroke "r" using command down
delay 0.2
EOF

# Switch back via yabai — brief sleep lets AeroSpace space animation settle
if [ -n "$PREV_WIN_ID" ]; then
    /opt/homebrew/bin/yabai -m window --focus "$PREV_WIN_ID" 2>/dev/null
    sleep 0.1
fi

# Run build completion notifier in background
nohup /Users/hao92/.config/scripts/xcode-build-notify.sh &
