import SwiftUI
import BroadwayCore

/// The visual emphasis level for a ``BroadwayButton``.
public enum BroadwayButtonStyle: Sendable {
    /// Solid filled background using the primary color.
    case primary
    /// Outlined border with a transparent background.
    case secondary
}

/// A themed button that reads its appearance from the current
/// ``BroadwayTheme`` in the environment.
///
///     BroadwayButton("Save", style: .primary) {
///         save()
///     }
///
public struct BroadwayButton: View {

    @Environment(\.broadwayTheme) private var theme

    private let title: String
    private let style: BroadwayButtonStyle
    private let action: () -> Void

    public init(
        _ title: String,
        style: BroadwayButtonStyle = .primary,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.style = style
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            Text(title)
                .font(theme.typography.bodyLarge)
                .padding(.vertical, theme.spacing.sm)
                .padding(.horizontal, theme.spacing.md)
                .frame(maxWidth: .infinity)
                .foregroundStyle(foregroundColor)
                .background(backgroundColor)
                .clipShape(RoundedRectangle(cornerRadius: theme.shape.cornerRadiusMedium))
                .overlay(
                    RoundedRectangle(cornerRadius: theme.shape.cornerRadiusMedium)
                        .strokeBorder(borderColor, lineWidth: theme.shape.borderWidth)
                )
        }
        .buttonStyle(.plain)
    }

    // MARK: - Private

    private var foregroundColor: Color {
        switch style {
        case .primary: theme.colors.onPrimary
        case .secondary: theme.colors.primary
        }
    }

    private var backgroundColor: Color {
        switch style {
        case .primary: theme.colors.primary
        case .secondary: .clear
        }
    }

    private var borderColor: Color {
        switch style {
        case .primary: .clear
        case .secondary: theme.colors.primary
        }
    }
}
