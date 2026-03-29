//
//  BStylesheets.swift
//  BroadwayCore
//
//  Created by Kyle Van Essen on 3/3/26.
//

import Foundation


public protocol BStylesheet : Equatable {
    
    init(context : Any)
}

public struct BStylesheets {
    
    public subscript<Stylesheet:BStylesheet>(_ value : Stylesheet.Type) -> Stylesheet? {
        get {
            let id = ObjectIdentifier(Stylesheet.self)
            
            guard let value = stylesheets[id] as? Stylesheet else {
                return nil
            }
            
            return value
        }
        
        set {
            let id = ObjectIdentifier(Stylesheet.self)
            
            stylesheets[id] = AnyEquatable(newValue)
        }
    }
    
    private var stylesheets : [ObjectIdentifier:AnyEquatable] = [:]
}
