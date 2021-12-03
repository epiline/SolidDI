//
//  DependecyReferenceConfigurator.swift
//  InjectionLesson
//
//  Created by Женя on 03.12.2021.
//

import Foundation

public protocol DependencyReferenceConfiguratorProtocol: AnyObject {
    
    init(dependency: AnyObject, key: String, dependenciesStore: DependenciesStoreProtocol)
    
    func asWeak()
    
    func asStrong()
}

public final class DependencyReferenceConfigurator: DependencyReferenceConfiguratorProtocol {
    
    private let dependency: AnyObject
    
    private let key: String
    
    private let dependenciesStore: DependenciesStoreProtocol
    
    public init(dependency: AnyObject, key: String, dependenciesStore: DependenciesStoreProtocol) {
        self.dependency = dependency
        self.key = key
        self.dependenciesStore = dependenciesStore
    }
    
    public func asWeak() {
        dependenciesStore.set(key: key, dependency: WeakDependencyReference(dependency))
    }
    
    public func asStrong() {
        dependenciesStore.set(key: key, dependency: StrongDependencyReference(dependency))
    }
}
