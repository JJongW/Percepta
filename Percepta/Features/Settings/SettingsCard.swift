import SwiftUI

// MARK: - Settings Card
// Isolated feature: Self-contained with own ViewModel
// Displays notification and app settings

struct SettingsCard: View {
    @StateObject private var viewModel = SettingsViewModel()

    var body: some View {
        DSCard {
            VStack(alignment: .leading, spacing: DSSpacing.md) {
                // Header
                HStack {
                    Image(systemName: "gearshape")
                        .font(.system(size: 16))
                        .foregroundColor(DSColor.accentPrimary)

                    Text("설정")
                        .font(DSTypography.title)
                        .foregroundColor(DSColor.textPrimary)

                    Spacer()
                }

                Divider()
                    .background(DSColor.divider)

                // Evening Notification Toggle
                VStack(alignment: .leading, spacing: DSSpacing.xs) {
                    Toggle(isOn: $viewModel.isEveningNotificationEnabled) {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("저녁 알림 (22:30)")
                                .font(DSTypography.body)
                                .foregroundColor(DSColor.textPrimary)

                            Text("매일 저녁 경제 체감을 기록하도록 알려드립니다")
                                .font(DSTypography.caption)
                                .foregroundColor(DSColor.textSecondary)
                        }
                    }
                    .tint(DSColor.accentPrimary)

                    // Permission denied warning
                    if viewModel.showPermissionDeniedWarning {
                        HStack(spacing: DSSpacing.xs) {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .font(.system(size: 12))
                                .foregroundColor(.orange)

                            Text("시스템 설정에서 알림이 비활성화되어 있습니다.")
                                .font(DSTypography.small)
                                .foregroundColor(.orange)
                        }
                        .padding(.top, DSSpacing.xs)
                    }
                }
            }
        }
        .onAppear {
            viewModel.onAppear()
        }
    }
}

// MARK: - Preview

#Preview {
    SettingsCard()
        .padding(DSSpacing.lg)
        .background(DSColor.bgPrimary)
}
