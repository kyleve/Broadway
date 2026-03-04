import SwiftUI

/// Semantic color tokens for a Broadway theme.
///
/// Colors are organized by role rather than literal appearance, making it
/// straightforward to swap palettes without touching component code.
public struct ColorTokens: Sendable, Equatable {

    // MARK: - Brand

    /// Primary brand color used for prominent UI elements.
    public var primary: Color

    /// Color for content rendered on top of `primary`.
    public var onPrimary: Color

    /// Secondary brand accent, used for less prominent elements.
    public var secondary: Color

    /// Color for content rendered on top of `secondary`.
    public var onSecondary: Color

    // MARK: - Surfaces

    /// Main background color of the app.
    public var background: Color

    /// Color for content rendered on top of `background`.
    public var onBackground: Color

    /// Elevated surface color (cards, sheets, etc.).
    public var surface: Color

    /// Color for content rendered on top of `surface`.
    public var onSurface: Color

    // MARK: - Semantic

    /// Color indicating destructive or error states.
    public var error: Color

    /// Color for content rendered on top of `error`.
    public var onError: Color

    /// Subtle outline / divider color.
    public var outline: Color

    // MARK: - Init

    public init(
        primary: Color,
        onPrimary: Color,
        secondary: Color,
        onSecondary: Color,
        background: Color,
        onBackground: Color,
        surface: Color,
        onSurface: Color,
        error: Color,
        onError: Color,
        outline: Color
    ) {
        self.primary = primary
        self.onPrimary = onPrimary
        self.secondary = secondary
        self.onSecondary = onSecondary
        self.background = background
        self.onBackground = onBackground
        self.surface = surface
        self.onSurface = onSurface
        self.error = error
        self.onError = onError
        self.outline = outline
    }
}
