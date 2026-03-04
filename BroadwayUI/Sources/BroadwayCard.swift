import SwiftUI
import BroadwayCore

/// A themed card surface that reads its appearance from the current
/// ``BroadwayTheme`` in the environment.
///
///     BroadwayCard {
///         Text("Hello")
///     }
///
public struct BroadwayCard<Content: View>: View {

    @Environment(\.broadwayTheme) private var theme

    private let content: Content

    public init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    public var body: some View {
        content
            .padding(theme.spacing.md)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(theme.colors.surface)
            .foregroundStyle(theme.colors.onSurface)
            .clipShape(RoundedRectangle(cornerRadius: theme.shape.cornerRadiusMedium))
            .overlay(
                RoundedRectangle(cornerRadius: theme.shape.cornerRadiusMedium)
                    .strokeBorder(theme.colors.outline, lineWidth: theme.shape.borderWidth)
            )
    }
}
