//
//  CopyOnWrite.swift
//  BroadwayCore
//
//  Created by Kyle Van Essen on 3/3/26.
//

import Foundation


@propertyWrapper
public struct CopyOnWrite<Value> {
    
    public init(wrappedValue : Value) {
        box = .init(value: wrappedValue)
    }
    
    public var wrappedValue : Value {
        get {
            _unsafeUnderlyingValue
        }
        
        set {
            if !isKnownUniquelyReferenced(&box) {
                box = .init(value: newValue)
            } else {
                box.value = newValue
            }
        }
    }
    
    public var _unsafeUnderlyingValue : Value {
        get { box.value }
        set { box.value = newValue }
    }
    
    private var box : Box
    
    fileprivate class Box {
        
        var value : Value
        
        init(value: Value) {
            self.value = value
        }
    }
}


extension CopyOnWrite : Equatable where Value:Equatable {}


extension CopyOnWrite.Box : Equatable where Value:Equatable {
    
    static func == (lhs:CopyOnWrite.Box, rhs:CopyOnWrite.Box) -> Bool {
        lhs === rhs || lhs.value == rhs.value
    }
    
}
