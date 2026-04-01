//
//  BTraits+Values.swift
//  BroadwayCore
//
//  Created by Kyle Van Essen on 3/31/26.
//

import Foundation

extension BTraits {
    public var mode: BMode {
        get { self[BMode.self] }
        set { self[BMode.self] = newValue }
    }

    public var contentSizeCategory: BContentSizeCategory {
        get { self[BContentSizeCategory.self] }
        set { self[BContentSizeCategory.self] = newValue }
    }
}

extension BTraits.Overrides {
    public var mode: BMode? {
        get { self[BMode.self] }
        set { self[BMode.self] = newValue }
    }

    public var contentSizeCategory: BContentSizeCategory? {
        get { self[BContentSizeCategory.self] }
        set { self[BContentSizeCategory.self] = newValue }
    }
}

public enum BMode: Equatable, Hashable {
    case dark
    case light
}

extension BMode: BTraitsValue {
    public static let defaultValue: BMode = .light
}

public enum BContentSizeCategory: Equatable, Hashable, Comparable {
    case extraSmall
    case small
    case medium
    case large
    case extraLarge
    case extraExtraLarge
    case extraExtraExtraLarge
    case accessibilityMedium
    case accessibilityLarge
    case accessibilityExtraLarge
    case accessibilityExtraExtraLarge
    case accessibilityExtraExtraExtraLarge

    public var isAccessibilitySize: Bool {
        self >= Self.accessibilityMedium
    }
}

extension BContentSizeCategory: BTraitsValue {
    public static let defaultValue: BContentSizeCategory = .large
}
