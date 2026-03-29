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

    public var themes : BThemes
    public var stylesheets : BStylesheets
}

public struct BStylesheets : Equatable {
        
    public subscript<Stylesheet:BStylesheet>(_ value : Stylesheet.Type) -> Stylesheet {
        get {
            let key = Key(stylesheet: .init(Stylesheet.self), traits: traits, themes: themes)
            
            guard let value = stylesheets[key], let value = value.base as? Stylesheet else {
                let context = SlicingContext(themes: themes, stylesheets: self)
                let new = Stylesheet(context: context)
                
                _stylesheets._unsafeUnderlyingValue[key] = AnyEquatable(new)
                
                return new
            }
            
            return value
        }
        
        set {
            let key = Key(stylesheet: .init(Stylesheet.self), traits: traits, themes: themes)

            stylesheets[key] = AnyEquatable(newValue)
        }
    }
    
    var traits : BTraits
    var themes : BThemes
    
    // TODO: Eventually we should clear this out on memory warnings for sheets not accessed within 10(?) min
    @CopyOnWrite private var stylesheets : [Key:AnyEquatable] = [:]
    
    struct Key : Hashable {
        let stylesheet : TypeIdentifier
        let traits : BTraits
        let themes : BThemes
    }
}
