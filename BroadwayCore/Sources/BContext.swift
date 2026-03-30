//
//  BContext.swift
//  BroadwayCore
//
//  Created by Kyle Van Essen on 3/3/26.
//

import Foundation


/// The root environment container that flows through the view hierarchy,
/// carrying the current ``BTraits``, ``BThemes``, and the lazily-populated
/// ``BStylesheets`` cache. Updating `traits` or `themes` propagates to
/// `stylesheets`, ensuring cached stylesheets are re-created with fresh inputs.
public struct BContext : Equatable {

    public init(traits : BTraits = .init(), themes : BThemes = .init()) {
        self.traits = traits
        self.themes = themes
        self.stylesheets = BStylesheets(config: .init(traits: traits, themes: themes))
    }

    /// The current trait values (accessibility, size class, etc.).
    /// Setting this propagates the new traits into ``stylesheets``.
    public var traits : BTraits {
        didSet {
            stylesheets.traits = traits
        }
    }
    
    /// The current theme values. Setting this propagates the new
    /// themes into ``stylesheets``.
    @CopyOnWrite public var themes : BThemes {
        didSet {
            stylesheets.themes = themes
        }
    }
    
    /// The stylesheet cache, keyed by `(stylesheet type, traits, themes)`.
    /// Stylesheets are created lazily on first access. Changing `traits`
    /// or `themes` causes subsequent lookups to produce fresh instances.
    @CopyOnWrite public private(set) var stylesheets : BStylesheets
}
