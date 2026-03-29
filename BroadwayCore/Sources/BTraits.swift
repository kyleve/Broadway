//
//  File.swift
//  BroadwayCore
//
//  Created by Kyle Van Essen on 3/3/26.
//

import Foundation


public struct BTraits : Equatable, Hashable {
    
    public subscript<Value:BTraitsValue>(_ value : Value.Type) -> Value.Value {
        get {
            let id = ObjectIdentifier(Value.self)
            
            guard let value = storage[id] as? Value.Value else {
                return Value.defaultValue
            }
            
            return value
        }
        
        set {
            let id = ObjectIdentifier(Value.self)
            
            storage[id] = newValue
        }
    }
    
    private var storage : [ObjectIdentifier:AnyHashable] = [:]
}


public protocol BTraitsValue {
    
    associatedtype Value:Hashable
    
    static var defaultValue : Value { get }
}
