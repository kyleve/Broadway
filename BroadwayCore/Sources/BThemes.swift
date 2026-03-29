//
//  BThemes.swift
//  BroadwayCore
//
//  Created by Kyle Van Essen on 3/29/26.
//

import Foundation


public protocol BTheme : Equatable, Hashable {
    
    static var defaultValue : Self { get }
    
}

public struct BThemes : Equatable, Hashable {
        
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
            
            themes[id] = AnyHashable(newValue)
        }
    }
    
    @CopyOnWrite private var themes : [TypeIdentifier:AnyHashable] = [:]
}
