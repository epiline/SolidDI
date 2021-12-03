//
//  DependenciesStore.swift
//  InjectionLesson
//
//  Created by Женя on 03.12.2021.
//

import Foundation

public protocol DependenciesStoreProtocol: AnyObject {
 
    func get(key: String) -> DependencyReferenceProtocol?
    
    func set(key: String, dependency: DependencyReferenceProtocol)
    
    func removeAll()
}

final public class DependenciesStore: DependenciesStoreProtocol {
    
    private var dependencies: [String: DependencyReferenceProtocol] = [:]
    
    public func get(key: String) -> DependencyReferenceProtocol? {
        print(dependencies)
        return dependencies[key]
    }
    
    public func set(key: String, dependency: DependencyReferenceProtocol) {
        print(dependencies)
        dependencies[key] = dependency
    }
    
    public func removeAll() {
        dependencies.removeAll()
    }
}
