//
//  InjectPropertyWrapper.swift
//  InjectionLesson
//
//  Created by Женя on 02.12.2021.
//

@propertyWrapper
public class Inject<T> {
    
    public var wrappedValue: T
    
    public init() {
        wrappedValue = DIContainer.resolve()
    }
}
