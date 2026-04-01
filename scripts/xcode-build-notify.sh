#!/bin/bash
# Watch for Xcode build completion and show macOS notifications

DERIVED_DATA="$HOME/Library/Developer/Xcode/DerivedData"
MARKER="/tmp/.xcode_build_marker"
LOG="/tmp/xcode-notify.log"

exec >> "$LOG" 2>&1
echo "[$(date)] notify script started (pid=$$)"

notify() {
    local text="$1"
    echo "[$(date)] notify: $text"
    osascript -e "tell application \"Alfred 5\" to run trigger \"xcode-build-status\" in workflow \"com.haoliu.xcode-build-notify\" with argument \"$text\""
}

# 1. Mark time to detect NEW log files (no start notification — user already knows they triggered it)
touch "$MARKER"
echo "[$(date)] marker touched, watching DerivedData..."

# 3. Wait for a new .xcactivitylog (build started in Xcode)
MAX_WAIT=20
elapsed=0
NEW_LOG=""
while [ $elapsed -lt $MAX_WAIT ]; do
    sleep 1
    NEW_LOG=$(find "$DERIVED_DATA" -name "*.xcactivitylog" -newer "$MARKER" 2>/dev/null | sort | tail -1)
    if [ -n "$NEW_LOG" ]; then
        echo "[$(date)] new log detected: $NEW_LOG"
        break
    fi
    elapsed=$((elapsed + 1))
done

if [ -z "$NEW_LOG" ]; then
    echo "[$(date)] no new log found after ${MAX_WAIT}s"
    notify "⚠️  No build detected"
    exit 1
fi

# 4. Wait for log file to stop growing (build finished)
MAX_BUILD=300
elapsed=0
last_size=-1
stable_count=0
while [ $elapsed -lt $MAX_BUILD ]; do
    sleep 2
    cur_size=$(stat -f%z "$NEW_LOG" 2>/dev/null || echo 0)
    if [ "$cur_size" -eq "$last_size" ] && [ "$cur_size" -gt 0 ]; then
        stable_count=$((stable_count + 1))
        if [ $stable_count -ge 2 ]; then
            echo "[$(date)] log stable at ${cur_size} bytes, build done"
            break
        fi
    else
        stable_count=0
    fi
    last_size=$cur_size
    elapsed=$((elapsed + 2))
done

# 5. Check log content for "Build failed" string
if zcat "$NEW_LOG" 2>/dev/null | strings | grep -q "Build failed"; then
    STATUS="failed"
else
    STATUS="done"
fi

echo "[$(date)] build status: $STATUS"

if [ "$STATUS" = "failed" ]; then
    notify "❌  Build Failed"
    osascript -e 'tell application "Xcode" to activate'
else
    notify "✅  Build Succeeded"
fi
