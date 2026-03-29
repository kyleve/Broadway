//
//  BStylesheets.swift
//  BroadwayCore
//
//  Created by Kyle Van Essen on 3/3/26.
//

import Foundation


public protocol BStylesheet : Equatable {
    
    init(context : SlicingContext)
}

public struct SlicingContext {
    
    public var stylesheets : BStylesheets
}

public struct BStylesheets : Equatable {
    
    public subscript<Stylesheet:BStylesheet>(_ value : Stylesheet.Type) -> Stylesheet {
        get {
            let id = ObjectIdentifier(Stylesheet.self)
            
            guard let value = stylesheets[id], let value = value.base as? Stylesheet else {
                let context = SlicingContext(stylesheets: self)
                let new = Stylesheet(context: context)
                
                _stylesheets._unsafeUnderlyingValue[id] = AnyEquatable(new)
                
                return new
            }
            
            return value
        }
        
        set {
            let id = ObjectIdentifier(Stylesheet.self)
            
            stylesheets[id] = AnyEquatable(newValue)
        }
    }
    
    mutating func clear() {
        stylesheets.removeAll(keepingCapacity: true)
    }
    
    @CopyOnWrite private var stylesheets : [ObjectIdentifier:AnyEquatable] = [:]
}
