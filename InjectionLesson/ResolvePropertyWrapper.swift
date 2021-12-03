//
//  ResolvePropertyWrapper.swift
//  Injection
//
//  Created by Женя on 02.12.2021.
//

@propertyWrapper
public final class Resolve<T> {
    
    public var wrappedValue: T
    
    public init() {
        wrappedValue = DIContainer.instance.resolve()
    }
}

@propertyWrapper
public final class ResolveWeakly<T> {
    
    public var wrappedValue: T?
    
    public init() {
        wrappedValue = DIContainer.instance.resolveWeakly()
    }
}
