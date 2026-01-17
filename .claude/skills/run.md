# Run

Build and run the Percepta app on the iOS Simulator.

## Instructions

When the user invokes this skill:

1. First build the project:
```bash
xcodebuild -project Percepta.xcodeproj -scheme Percepta -destination 'platform=iOS Simulator,name=iPad Pro 13-inch (M4)' build
```

2. If build succeeds, run the app on simulator:
```bash
xcrun simctl boot 'iPad Pro 13-inch (M4)' 2>/dev/null || true
open -a Simulator
xcrun simctl install booted "$(find ~/Library/Developer/Xcode/DerivedData -name 'Percepta.app' -path '*/Debug-iphonesimulator/*' | head -1)"
xcrun simctl launch booted jw.Percepta
```

If the user specifies a different simulator device, use that instead.

Report success or failure clearly to the user.
