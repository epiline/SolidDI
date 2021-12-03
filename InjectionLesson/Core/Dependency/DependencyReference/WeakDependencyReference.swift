//
//  WeakDependencyReference.swift
//  InjectionLesson
//
//  Created by Женя on 03.12.2021.
//

import Foundation

final public class WeakDependencyReference: DependencyReferenceProtocol {
    
    private weak var weakReferenceDependency: AnyObject?
    
    public var dependency: AnyObject? {
        return weakReferenceDependency
    }
    
    public init(_ dependency: AnyObject) {
        self.weakReferenceDependency = dependency
    }
}
