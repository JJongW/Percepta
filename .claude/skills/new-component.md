# New Component

Create a reusable UI component following the Design System.

## Arguments

- `name`: The name of the component (e.g., "InfoBanner", "StatusBadge")

## Instructions

When the user invokes this skill, create a reusable component in `Percepta/Components/`.

### Component Template (Components/{Category}/{Name}.swift)

```swift
import SwiftUI

// MARK: - {Name}

struct {Name}: View {
    // MARK: - Properties
    // Define component properties here

    // MARK: - State
    @State private var isPressed = false

    // MARK: - Body
    var body: some View {
        // Use Design System tokens:
        // - DSColor.* for colors
        // - DSTypography.* for fonts
        // - DSSpacing.* for spacing
        // - DSLayout.* for dimensions
    }
}

// MARK: - Preview

#Preview {
    {Name}()
        .padding(DSSpacing.lg)
        .background(DSColor.bgPrimary)
}
```

## Design System Reference

### Colors (DSColor.*)
```swift
.bgPrimary      // #F9FAFB - Screen background
.surface        // #FFFFFF - Card background
.divider        // #F1F3F5

.accentPrimary  // #1F6F78 - Primary actions
.accentTint     // #D6EFF0 - Light accent background

.textPrimary    // #111827 - Main text
.textSecondary  // #374151 - Secondary text
.textTertiary   // #6B7280 - Subtle text
```

### Typography (DSTypography.*)
```swift
.titleLarge     // 30pt bold
.title          // 21pt semibold
.body           // 17pt regular
.bodyMedium     // 17pt medium
.caption        // 14pt regular
.small          // 13pt regular
```

### Spacing (DSSpacing.*)
```swift
.xs   // 4pt
.sm   // 8pt
.md   // 16pt
.lg   // 24pt
.xl   // 32pt
.xxl  // 48pt
```

### Layout (DSLayout.*)
```swift
.cardCornerRadius   // 18pt
.buttonHeight       // 56pt
.buttonCornerRadius // 14pt
.inputHeight        // 52pt
.chipHeight         // 28pt
```

## Existing Components

Reference these existing components:
- `DSCard` / `DSTappableCard` - Card containers
- `DSPrimaryButton` / `DSSecondaryButton` - Buttons
- `DSTextField` / `DSSingleLineTextField` - Text inputs
- `DSSegmentedPicker` / `DSCompactSegmentedPicker` - Selectors
- `DSChip` / `DSSourceChip` - Tags/labels

## Specification Principles

- Visual comfort is primary requirement
- No charts, no numbers, no jargon
- Clear, calm design language
- Touch targets minimum 44pt

## Post-Creation Checklist

- [ ] Uses DSColor.* (no hardcoded colors)
- [ ] Uses DSTypography.* (no hardcoded fonts)
- [ ] Uses DSSpacing.* (no magic numbers)
- [ ] Touch target >= 44pt if interactive
- [ ] Has press animation if tappable
- [ ] Includes Preview
