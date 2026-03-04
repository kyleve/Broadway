import SwiftUI

/// A complete Broadway design-system theme.
///
/// `BroadwayTheme` bundles all token categories (colors, typography,
/// spacing, and shapes) into a single value that can be injected into
/// the SwiftUI environment. Swap the theme at any point in the view
/// hierarchy to re-theme everything below it.
public struct BroadwayTheme: Sendable, Equatable, Hashable {

    public func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }


    /// Human-readable name for this theme (e.g. "Light", "Dark").
    public var name: String

    public var colors: ColorTokens
    public var typography: TypographyTokens
    public var spacing: SpacingTokens
    public var shape: ShapeTokens

    public init(
        name: String,
        colors: ColorTokens,
        typography: TypographyTokens,
        spacing: SpacingTokens,
        shape: ShapeTokens
    ) {
        self.name = name
        self.colors = colors
        self.typography = typography
        self.spacing = spacing
        self.shape = shape
    }
}

// MARK: - Built-in Themes

extension BroadwayTheme {

    /// The default light theme.
    public static let light = BroadwayTheme(
        name: "Light",
        colors: ColorTokens(
            primary: Color(red: 0.26, green: 0.32, blue: 0.83),
            onPrimary: .white,
            secondary: Color(red: 0.38, green: 0.49, blue: 0.96),
            onSecondary: .white,
            background: Color(red: 0.98, green: 0.98, blue: 1.0),
            onBackground: Color(red: 0.10, green: 0.10, blue: 0.14),
            surface: .white,
            onSurface: Color(red: 0.10, green: 0.10, blue: 0.14),
            error: Color(red: 0.80, green: 0.18, blue: 0.18),
            onError: .white,
            outline: Color(red: 0.78, green: 0.78, blue: 0.82)
        ),
        typography: .default,
        spacing: .default,
        shape: .default
    )

    /// A dark theme.
    public static let dark = BroadwayTheme(
        name: "Dark",
        colors: ColorTokens(
            primary: Color(red: 0.65, green: 0.71, blue: 1.0),
            onPrimary: Color(red: 0.08, green: 0.12, blue: 0.42),
            secondary: Color(red: 0.75, green: 0.80, blue: 1.0),
            onSecondary: Color(red: 0.12, green: 0.18, blue: 0.48),
            background: Color(red: 0.07, green: 0.07, blue: 0.11),
            onBackground: Color(red: 0.91, green: 0.91, blue: 0.95),
            surface: Color(red: 0.13, green: 0.13, blue: 0.18),
            onSurface: Color(red: 0.91, green: 0.91, blue: 0.95),
            error: Color(red: 1.0, green: 0.55, blue: 0.55),
            onError: Color(red: 0.37, green: 0.04, blue: 0.04),
            outline: Color(red: 0.36, green: 0.36, blue: 0.42)
        ),
        typography: .default,
        spacing: .default,
        shape: .default
    )
}

// MARK: - Token Defaults

extension TypographyTokens {
    /// System default type scale using Dynamic Type–friendly fonts.
    public static let `default` = TypographyTokens(
        displayLarge: .largeTitle.bold(),
        titleLarge: .title.bold(),
        titleMedium: .title3.weight(.semibold),
        bodyLarge: .body,
        bodyMedium: .callout,
        caption: .caption
    )
}

extension SpacingTokens {
    /// 4-pt grid spacing scale.
    public static let `default` = SpacingTokens(
        xs: 4,
        sm: 8,
        md: 16,
        lg: 24,
        xl: 32,
        xxl: 48
    )
}

extension ShapeTokens {
    public static let `default` = ShapeTokens(
        cornerRadiusSmall: 4,
        cornerRadiusMedium: 8,
        cornerRadiusLarge: 16,
        borderWidth: 1
    )
}
