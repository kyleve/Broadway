//
//  File.swift
//  BroadwayCore
//
//  Created by Kyle Van Essen on 3/3/26.
//

import Foundation


extension BTraits {
    
    public var accessibility : BAccessibility {
        get { self[BAccessibility.self] }
        set { self[BAccessibility.self] = newValue }
    }
}


extension BAccessibility : BTraitsValue {
    
    public static var defaultValue: Self {
        .init()
    }
}


public struct BTraits : Equatable, Hashable {
    
    public subscript<Value:BTraitsValue>(_ value : Value.Type) -> Value {
        get {
            let id = TypeIdentifier(Value.self)
            
            guard let value = storage[id], let value = value.base as? Value else {
                return Value.defaultValue
            }
            
            return value
        }
        
        set {
            let id = TypeIdentifier(Value.self)
            
            storage[id] = AnyHashable(newValue)
        }
    }
    
    private var storage : [TypeIdentifier:AnyHashable] = [:]
}


public protocol BTraitsValue : Hashable {
        
    static var defaultValue : Self { get }
}
