# Clean

Clean the Xcode build artifacts and derived data.

## Instructions

When the user invokes this skill, clean the project:

```bash
xcodebuild -project Percepta.xcodeproj -scheme Percepta clean
```

Optionally, if the user wants a deep clean, also remove derived data:

```bash
rm -rf ~/Library/Developer/Xcode/DerivedData/Percepta-*
```

Report the result to the user.
