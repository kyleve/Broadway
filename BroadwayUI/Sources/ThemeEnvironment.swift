import SwiftUI
import BroadwayCore

// MARK: - Environment Key

private struct BroadwayThemeKey: EnvironmentKey {
    static let defaultValue: BroadwayTheme = .light
}

extension EnvironmentValues {
    /// The current Broadway theme.
    public var broadwayTheme: BroadwayTheme {
        get { self[BroadwayThemeKey.self] }
        set { self[BroadwayThemeKey.self] = newValue }
    }
}

// MARK: - View Modifier

extension View {

    /// Applies a Broadway theme to this view and all of its descendants.
    ///
    ///     ContentView()
    ///         .broadwayTheme(.dark)
    ///
    public func broadwayTheme(_ theme: BroadwayTheme) -> some View {
        environment(\.broadwayTheme, theme)
    }
}
