//
//  BStylesheets.swift
//  BroadwayCore
//
//  Created by Kyle Van Essen on 3/3/26.
//

import Foundation


/// A type that computes derived style values from a ``SlicingContext``.
///
/// Conform to this protocol to define a stylesheet that is lazily created
/// and cached by ``BStylesheets``. A stylesheet's `init` receives the
/// current themes and may access other stylesheets through the context;
/// circular dependencies are detected at runtime and throw a
/// ``CyclicDependencyError``.
public protocol BStylesheet : Equatable {

    init(context : SlicingContext) throws
}

/// Thrown when a stylesheet's initialization creates a dependency cycle.
///
/// The ``path`` array describes the cycle, e.g. `["A", "B", "A"]`
/// means `A` depends on `B` which depends on `A`.
public struct CyclicDependencyError : Error, CustomStringConvertible {

    /// The type names involved in the cycle, starting and ending with the same type.
    public let path : [String]

    public var description : String {
        "Stylesheet dependency cycle: \(path.joined(separator: " → "))"
    }
}

/// The context passed to ``BStylesheet/init(context:)`` during lazy creation,
/// providing access to the current themes and other stylesheets.
public struct SlicingContext {

    public var themes : BThemes
    public var stylesheets : BStylesheets
}

/// A keyed cache of ``BStylesheet`` instances, scoped to a specific
/// combination of traits and themes. Stylesheets are created lazily on
/// first access and cached for subsequent lookups with the same key.
public struct BStylesheets : Equatable {

    public static func == (lhs : Self, rhs : Self) -> Bool {
        lhs.traits == rhs.traits
        && lhs.themes == rhs.themes
        && lhs.stylesheets == rhs.stylesheets
    }

    /// Returns the cached stylesheet of the given type, creating it lazily if needed.
    ///
    /// - Throws: ``CyclicDependencyError`` if creation triggers a dependency cycle.
    public func get<Stylesheet:BStylesheet>(_ type : Stylesheet.Type) throws -> Stylesheet {
        let key = Key(stylesheet: .init(Stylesheet.self), traits: traits, themes: themes)

        guard let value = stylesheets[key], let value = value.base as? Stylesheet else {
            let id = TypeIdentifier(Stylesheet.self)

            let creating = _creating._unsafeUnderlyingValue

            if let cycleStart = creating.firstIndex(of: id) {
                let path = creating[cycleStart...].map(\.debugDescription) + [id.debugDescription]
                throw CyclicDependencyError(path: path)
            }

            _creating._unsafeUnderlyingValue.append(id)

            let context = SlicingContext(themes: themes, stylesheets: self)
            let new = try Stylesheet(context: context)

            _creating._unsafeUnderlyingValue.removeLast()
            _stylesheets._unsafeUnderlyingValue[key] = AnyEquatable(new)

            return new
        }

        return value
    }

    /// Explicitly sets a cached stylesheet value for the given type,
    /// replacing any previously cached instance for the current traits and themes.
    public mutating func set<Stylesheet:BStylesheet>(_ newValue : Stylesheet) {
        let key = Key(stylesheet: .init(Stylesheet.self), traits: traits, themes: themes)
        stylesheets[key] = AnyEquatable(newValue)
    }

    var traits : BTraits
    var themes : BThemes

    // TODO: Eventually we should clear this out on memory warnings for sheets not accessed within 10(?) min
    @CopyOnWrite private var stylesheets : [Key:AnyEquatable] = [:]

    @CopyOnWrite private var creating : [TypeIdentifier] = []

    /// Cache key combining the stylesheet type with the traits and themes
    /// that were active at creation time.
    struct Key : Hashable {
        let stylesheet : TypeIdentifier
        let traits : BTraits
        let themes : BThemes
    }
}
