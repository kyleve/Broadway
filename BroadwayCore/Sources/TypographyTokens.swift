import SwiftUI

/// Typography tokens defining the type scale for a Broadway theme.
///
/// Each token maps to a `Font` value. Components use these tokens
/// instead of hard-coded fonts so the entire type scale can be
/// swapped by providing a different theme.
public struct TypographyTokens: Sendable, Equatable {

    /// Large display headings.
    public var displayLarge: Font

    /// Section titles.
    public var titleLarge: Font

    /// Subsection titles.
    public var titleMedium: Font

    /// Standard body text.
    public var bodyLarge: Font

    /// Secondary body text.
    public var bodyMedium: Font

    /// Small labels and captions.
    public var caption: Font

    public init(
        displayLarge: Font,
        titleLarge: Font,
        titleMedium: Font,
        bodyLarge: Font,
        bodyMedium: Font,
        caption: Font
    ) {
        self.displayLarge = displayLarge
        self.titleLarge = titleLarge
        self.titleMedium = titleMedium
        self.bodyLarge = bodyLarge
        self.bodyMedium = bodyMedium
        self.caption = caption
    }
}
