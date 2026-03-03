//
//  AnyEquatable.swift
//  BroadwayCore
//
//  Created by Kyle Van Essen on 3/3/26.
//

import Foundation


struct AnyEquatable : Equatable {
    
    let value : Any
    
    private let compare : (AnyEquatable) -> Bool
    
    init<Value:Equatable>(_ typedValue : Value) {
        
        self.value = typedValue
        
        self.compare = { other in
            guard let otherValue = other.value as? Value else {
                return false
            }
            
            return typedValue == otherValue
        }
    }
    
    static func == (lhs:AnyEquatable, rhs:AnyEquatable) -> Bool {
        lhs.compare(rhs)
    }
}
