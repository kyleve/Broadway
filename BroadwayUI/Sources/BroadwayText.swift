import SwiftUI
import BroadwayCore

/// Semantic text roles used by ``BroadwayText``.
public enum BroadwayTextRole: Sendable {
    case displayLarge
    case titleLarge
    case titleMedium
    case bodyLarge
    case bodyMedium
    case caption
}

/// A themed text view that maps a semantic ``BroadwayTextRole``
/// to the corresponding typography token from the current theme.
///
///     BroadwayText("Welcome", role: .titleLarge)
///
public struct BroadwayText: View {

    @Environment(\.broadwayTheme) private var theme

    private let text: String
    private let role: BroadwayTextRole

    public init(_ text: String, role: BroadwayTextRole = .bodyLarge) {
        self.text = text
        self.role = role
    }

    public var body: some View {
        Text(text)
            .font(font)
            .foregroundStyle(theme.colors.onBackground)
    }

    private var font: Font {
        switch role {
        case .displayLarge: theme.typography.displayLarge
        case .titleLarge: theme.typography.titleLarge
        case .titleMedium: theme.typography.titleMedium
        case .bodyLarge: theme.typography.bodyLarge
        case .bodyMedium: theme.typography.bodyMedium
        case .caption: theme.typography.caption
        }
    }
}
