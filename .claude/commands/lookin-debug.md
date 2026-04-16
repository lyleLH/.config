Connect to LookinServer running in the iOS simulator and dump the current view hierarchy for debugging.

## Instructions

1. Build and run the lookin-cli tool:

```bash
cd /Users/hao92/Documents/GitHub/FlyerCard/ios-app/tools/lookin-cli && swift run lookin-cli $ARGUMENTS
```

2. If the connection fails, check:
   - Is the app running in the simulator?
   - Check if LookinServer ports are listening: `lsof -i -P -n | grep -E "4716[4-9]"`
   - LookinServer may need the app to be in DEBUG configuration

3. Parse the output and present findings to the user. If a `--filter` argument was provided, highlight matching views.

4. For ghost page / overlap debugging, run with `--filter=CanvasPages` or `--filter=Viewport` to focus on the pages viewport hierarchy.

## Available arguments

Pass these via $ARGUMENTS:

- `--filter=TEXT` — Only show branches containing TEXT in class name
- `--device` — Connect to real device instead of simulator
- `--depth=N` — Limit tree depth to N levels
- `--raw` — Print raw hierarchy info

## Examples

- `/lookin-debug` — Dump full hierarchy from simulator
- `/lookin-debug --filter=CanvasPages` — Show only CanvasPagesViewportCell branches
- `/lookin-debug --filter=Canvas --depth=3` — Canvas views, max 3 levels deep
- `/lookin-debug --device` — Connect to USB-connected device
