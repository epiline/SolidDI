//
//  ResolveWrapper.swift
//  
//
//  Created by Женя on 20.04.2022.
//

import Foundation

@propertyWrapper
public final class Resolve<T> {
    
    public var wrappedValue: T
    
    public init() {
        wrappedValue = GlobalDI.container.resolve()
    }
    
    internal init(container: DIContainer) {
        wrappedValue = container.resolve()
    }
}
