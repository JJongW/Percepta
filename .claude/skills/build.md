# Build

Build the Xcode project for the Percepta iOS app.

## Instructions

When the user invokes this skill, build the project using xcodebuild:

```bash
xcodebuild -project Percepta.xcodeproj -scheme Percepta -destination 'platform=iOS Simulator,name=iPad Pro 13-inch (M4)' build
```

If the build fails, analyze the error output and provide actionable fixes. Common issues include:
- Missing provisioning profiles (suggest using automatic signing)
- Swift syntax errors (show the file and line number)
- Missing dependencies (this project has no external dependencies)

Report the build result clearly to the user.
