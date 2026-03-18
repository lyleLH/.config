pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Io

/**
 * Polls top memory-consuming processes, grouped by application name.
 */
Singleton {
    id: root

    property var topProcesses: []

    Timer {
        interval: 5000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            proc.running = true
        }
    }

    Process {
        id: proc
        command: ["bash", "-c", `
            ps axo rss,args --no-headers --sort=-rss | awk '
            {
                mb = $1 / 1024
                if (mb < 10) next

                cmd = ""
                for (i = 2; i <= NF; i++) cmd = cmd " " $i

                if (cmd ~ /firefox/) name = "Firefox"
                else if (cmd ~ /claude/) name = "Claude"
                else if (cmd ~ /chrome|chromium/) name = "Chrome"
                else if (cmd ~ /steamwebhelper|steam/) name = "Steam"
                else if (cmd ~ /nanobot/) name = "Nanobot"
                else if (cmd ~ /quickshell|\\/qs/) name = "Quickshell"
                else if (cmd ~ /nvim|neovim/) name = "Neovim"
                else if (cmd ~ /code/) name = "VS Code"
                else if (cmd ~ /discord/) name = "Discord"
                else if (cmd ~ /spotify/) name = "Spotify"
                else if (cmd ~ /dota2/) name = "Dota 2"
                else if (cmd ~ /telegram/) name = "Telegram"
                else if (cmd ~ /kitty/) name = "Kitty"
                else if (cmd ~ /Hyprland/) name = "Hyprland"
                else if (cmd ~ /pipewire/) name = "PipeWire"
                else {
                    n = split($2, parts, "/")
                    name = parts[n]
                }

                mem[name] += mb
            }
            END {
                n = asorti(mem, sorted, "@val_num_desc")
                for (i = 1; i <= 8 && i <= n; i++) {
                    printf "%.0f %s\\n", mem[sorted[i]], sorted[i]
                }
            }'
        `]
        stdout: StdioCollector {
            id: collector
            onStreamFinished: {
                const lines = collector.text.trim().split("\n")
                const result = []
                for (const line of lines) {
                    const parts = line.trim().split(/\s+/)
                    if (parts.length >= 2) {
                        const mb = parseInt(parts[0])
                        const name = parts.slice(1).join(" ")
                        if (mb > 0) {
                            result.push({ name: name, mb: mb })
                        }
                    }
                }
                root.topProcesses = result
            }
        }
    }
}
