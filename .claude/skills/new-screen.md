# New Screen

Create a new screen following the project's MVVM architecture and specification principles.

## Arguments

- `name`: The name of the screen (e.g., "Settings", "History")

## Instructions

When the user invokes this skill with a screen name, create the following files:

### 1. Screen View (Features/{Name}/{Name}Screen.swift)

```swift
import SwiftUI

struct {Name}Screen: View {
    @StateObject private var viewModel = {Name}ViewModel()

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: DSSpacing.lg) {
                // Header
                Text("{Name}")
                    .font(DSTypography.titleLarge)
                    .foregroundColor(DSColor.textPrimary)

                // Content cards here
            }
            .padding(DSLayout.screenPadding)
        }
        .background(DSColor.screenBackground)
        .onAppear {
            EventLogger.shared.logScreenView("{Name}")
        }
    }
}

#Preview {
    {Name}Screen()
}
```

### 2. ViewModel (Features/{Name}/{Name}ViewModel.swift)

```swift
import Foundation

@MainActor
final class {Name}ViewModel: ObservableObject {
    private let logger = EventLogger.shared

    init() {
        loadData()
    }

    private func loadData() {
        // Load initial data
    }
}
```

### 3. Update AppCoordinator (if navigation needed)

Add a new route case to the `Route` enum in `Presentation/Coordinators/AppCoordinator.swift`:
```swift
case {name}
```

Add the corresponding view case in the `view(for:)` method:
```swift
case .{name}:
    {Name}Screen()
```

## Specification Principles

Per the canonical specification, ensure:

### Core Philosophy
- Track perception, not performance
- Guide direction without recommending actions
- Usage is tracked, never judged
- Silence is a valid state

### UI & Readability
- No charts, no numbers, no jargon
- 8-11 short lines total per section
- Clear conclusions with calm explanations
- Visual comfort is primary requirement

### Design System Usage
- Use `DSColor.*` for all colors
- Use `DSTypography.*` for all fonts
- Use `DSSpacing.*` for all spacing
- Use `DSCard` for card containers

## Post-Creation Checklist

- [ ] Uses Design System tokens (no hardcoded colors/fonts)
- [ ] Single clear purpose per screen
- [ ] Follows 8pt grid spacing
- [ ] Works in Dark Mode
- [ ] Has accessibility labels
