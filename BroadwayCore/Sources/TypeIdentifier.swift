//
//  TypeIdentifier.swift
//  BroadwayCore
//
//  Created by Kyle Van Essen on 3/29/26.
//

import Foundation


struct TypeIdentifier : Equatable, Hashable, CustomDebugStringConvertible {
    
    let identifier : ObjectIdentifier
    let type : Any.Type
    
    init<T>(_ type: T.Type) {
        identifier = .init(type)
        self.type = type
    }
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.identifier == rhs.identifier
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
    
    var debugDescription: String {
        "\(type)"
    }
}
