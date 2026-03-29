//
//  BThemes.swift
//  BroadwayCore
//
//  Created by Kyle Van Essen on 3/29/26.
//

import Foundation


/// A named, hashable theme value stored in ``BThemes``.
///
/// Conform to this protocol for app-level theme types (e.g. color palettes,
/// typography scales) that are used by stylesheets during slicing.
public protocol BTheme : Equatable, Hashable {

    static var defaultValue : Self { get }

}

/// A type-keyed container of ``BTheme`` values.
///
/// Themes are optional; accessing a type that hasn't been set returns `nil`.
public struct BThemes : Equatable, Hashable {

    /// Gets or sets the theme for the given type. Returns `nil` if no
    /// theme of that type has been set.
    public subscript<Theme:BTheme>(_ value : Theme.Type) -> Theme? {
        get {
            let id = TypeIdentifier(Theme.self)
            
            guard let value = themes[id], let value = value.base as? Theme else {
                return nil
            }
            
            return value
        }
        
        set {
            let id = TypeIdentifier(Theme.self)
            
            if let newValue {
                themes[id] = AnyHashable(newValue)
            } else {
                themes[id] = nil
            }
        }
    }
    
    @CopyOnWrite private var themes : [TypeIdentifier:AnyHashable] = [:]
}
