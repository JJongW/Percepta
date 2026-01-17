import SwiftUI

// MARK: - Chip / Tag Component

struct DSChip: View {
    let text: String
    let style: ChipStyle

    enum ChipStyle {
        case primary    // Accent background
        case secondary  // Light background
        case outline    // Border only

        var backgroundColor: Color {
            switch self {
            case .primary: return DSColor.accentPrimary
            case .secondary: return DSColor.accentTint
            case .outline: return .clear
            }
        }

        var textColor: Color {
            switch self {
            case .primary: return .white
            case .secondary: return DSColor.accentPrimary
            case .outline: return DSColor.textSecondary
            }
        }

        var borderColor: Color {
            switch self {
            case .primary, .secondary: return .clear
            case .outline: return DSColor.divider
            }
        }
    }

    init(_ text: String, style: ChipStyle = .secondary) {
        self.text = text
        self.style = style
    }

    var body: some View {
        Text(text)
            .font(DSTypography.small)
            .foregroundColor(style.textColor)
            .padding(.horizontal, DSSpacing.sm)
            .frame(height: DSLayout.chipHeight)
            .background(style.backgroundColor)
            .cornerRadius(DSLayout.chipCornerRadius)
            .overlay(
                RoundedRectangle(cornerRadius: DSLayout.chipCornerRadius)
                    .stroke(style.borderColor, lineWidth: 1)
            )
    }
}

// MARK: - Source Chip (for news sources)

struct DSSourceChip: View {
    let source: String

    var body: some View {
        Text(source)
            .font(DSTypography.small)
            .foregroundColor(sourceColor)
            .padding(.horizontal, DSSpacing.sm)
            .frame(height: DSLayout.chipHeight)
            .background(sourceBackgroundColor)
            .cornerRadius(DSLayout.chipCornerRadius)
    }

    private var sourceColor: Color {
        switch source.lowercased() {
        case "bloomberg": return Color(hex: "FF6900")
        case "ft", "financial times": return Color(hex: "FCD0A1")
        case "reuters": return Color(hex: "FF8200")
        default: return DSColor.textSecondary
        }
    }

    private var sourceBackgroundColor: Color {
        switch source.lowercased() {
        case "bloomberg": return Color(hex: "FF6900").opacity(0.1)
        case "ft", "financial times": return Color(hex: "FFF1E6")
        case "reuters": return Color(hex: "FF8200").opacity(0.1)
        default: return DSColor.bgPrimary
        }
    }
}

// MARK: - Preview

#Preview {
    VStack(spacing: DSSpacing.md) {
        HStack(spacing: DSSpacing.sm) {
            DSChip("안정", style: .primary)
            DSChip("중립", style: .secondary)
            DSChip("불안", style: .outline)
        }

        HStack(spacing: DSSpacing.sm) {
            DSSourceChip(source: "Bloomberg")
            DSSourceChip(source: "FT")
            DSSourceChip(source: "Reuters")
        }
    }
    .padding(DSSpacing.lg)
    .background(DSColor.surface)
}
