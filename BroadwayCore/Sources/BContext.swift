//
//  BContext.swift
//  BroadwayCore
//
//  Created by Kyle Van Essen on 3/3/26.
//

import Foundation


public struct BContext {
    
    public var traits : BTraits {
        didSet {
            stylesheets.traits = traits
        }
    }
    
    @CopyOnWrite public var themes : BThemes {
        didSet {
            stylesheets.themes = themes
        }
    }
    
    @CopyOnWrite public private(set) var stylesheets : BStylesheets
}
