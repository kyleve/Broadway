import Foundation

/// Spacing tokens providing a consistent spacing scale.
///
/// The scale is loosely based on a 4-pt grid. Components use
/// these values rather than magic numbers so that spacing can
/// be adjusted globally by providing a different theme.
public struct SpacingTokens: Sendable, Equatable {

    /// Extra-small spacing (4 pt by default).
    public var xs: CGFloat

    /// Small spacing (8 pt).
    public var sm: CGFloat

    /// Medium spacing (16 pt).
    public var md: CGFloat

    /// Large spacing (24 pt).
    public var lg: CGFloat

    /// Extra-large spacing (32 pt).
    public var xl: CGFloat

    /// Double extra-large spacing (48 pt).
    public var xxl: CGFloat

    public init(
        xs: CGFloat,
        sm: CGFloat,
        md: CGFloat,
        lg: CGFloat,
        xl: CGFloat,
        xxl: CGFloat
    ) {
        self.xs = xs
        self.sm = sm
        self.md = md
        self.lg = lg
        self.xl = xl
        self.xxl = xxl
    }
}
