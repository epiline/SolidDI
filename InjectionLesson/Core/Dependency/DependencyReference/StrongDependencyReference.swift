//
//  StrongDependencyReference.swift
//  InjectionLesson
//
//  Created by Женя on 03.12.2021.
//

import Foundation

final public class StrongDependencyReference: DependencyReferenceProtocol {
    
    private var strongReferenceDependency: AnyObject?
    
    public var dependency: AnyObject? {
        return strongReferenceDependency
    }
    
    public init(_ dependency: AnyObject) {
        self.strongReferenceDependency = dependency
    }
}
