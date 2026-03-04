import Foundation

/// Shape tokens controlling corner radii and border widths.
public struct ShapeTokens: Sendable, Equatable {

    /// Small corner radius (4 pt).
    public var cornerRadiusSmall: CGFloat

    /// Medium corner radius (8 pt).
    public var cornerRadiusMedium: CGFloat

    /// Large corner radius (16 pt).
    public var cornerRadiusLarge: CGFloat

    /// Standard border width.
    public var borderWidth: CGFloat

    public init(
        cornerRadiusSmall: CGFloat,
        cornerRadiusMedium: CGFloat,
        cornerRadiusLarge: CGFloat,
        borderWidth: CGFloat
    ) {
        self.cornerRadiusSmall = cornerRadiusSmall
        self.cornerRadiusMedium = cornerRadiusMedium
        self.cornerRadiusLarge = cornerRadiusLarge
        self.borderWidth = borderWidth
    }
}
