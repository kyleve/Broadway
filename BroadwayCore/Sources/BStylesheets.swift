//
//  BStylesheets.swift
//  BroadwayCore
//
//  Created by Kyle Van Essen on 3/3/26.
//

import Foundation


public protocol BStylesheet : Equatable {

    init(context : SlicingContext) throws
}

public struct CyclicDependencyError : Error, CustomStringConvertible {

    public let path : [String]

    public var description : String {
        "Stylesheet dependency cycle: \(path.joined(separator: " → "))"
    }
}

public struct SlicingContext {

    public var themes : BThemes
    public var stylesheets : BStylesheets
}

public struct BStylesheets : Equatable {

    public static func == (lhs : Self, rhs : Self) -> Bool {
        lhs.traits == rhs.traits
        && lhs.themes == rhs.themes
        && lhs.stylesheets == rhs.stylesheets
    }

    public subscript<Stylesheet:BStylesheet>(_ value : Stylesheet.Type) -> Stylesheet {
        get throws {
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
    }

    public mutating func set<Stylesheet:BStylesheet>(_ newValue : Stylesheet) {
        let key = Key(stylesheet: .init(Stylesheet.self), traits: traits, themes: themes)
        stylesheets[key] = AnyEquatable(newValue)
    }

    var traits : BTraits
    var themes : BThemes

    // TODO: Eventually we should clear this out on memory warnings for sheets not accessed within 10(?) min
    @CopyOnWrite private var stylesheets : [Key:AnyEquatable] = [:]

    @CopyOnWrite private var creating : [TypeIdentifier] = []

    struct Key : Hashable {
        let stylesheet : TypeIdentifier
        let traits : BTraits
        let themes : BThemes
    }
}
