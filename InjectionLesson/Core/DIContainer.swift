//
//  DIContainer.swift
//  InjectionLesson
//
//  Created by Женя on 02.12.2021.
//

import Foundation

public protocol DIContainerProtocol: AnyObject {
    
    typealias FactoryClosure = (DIContainer) -> AnyObject
    
    func register<D, P>(_ dependency: D, as: P.Type) -> DependencyReferenceConfiguratorProtocol
    
    func register<P>(_ as: P.Type, factory: @escaping FactoryClosure) -> DependencyReferenceConfiguratorProtocol
    
    func resolve<D>() -> D
    
    func resolveWeakly<D>() -> D?
    
    /// Remove all dependencies
    func flush()
}

final public class DIContainer: DIContainerProtocol {
    
    private let dependencies: DependenciesStoreProtocol = DependenciesStore()
    
    public static var instance: DIContainerProtocol = DIContainer()
    
    private func createKey<T>(_ type: T.Type) -> String {
        return "\(T.self)"
    }
    
    public func register<D, P>(_ dependency: D, as: P.Type) -> DependencyReferenceConfiguratorProtocol {
        let key = createKey(P.self)
        return DependencyReferenceConfigurator(dependency: dependency as AnyObject, key: key, dependenciesStore: dependencies)
    }
    
    public func register<P>(_ as: P.Type, factory: @escaping FactoryClosure) -> DependencyReferenceConfiguratorProtocol {
        let key = createKey(P.self)
        return DependencyReferenceConfigurator(dependency: factory(self), key: key, dependenciesStore: dependencies)
    }
        
    public func resolve<D>() -> D {
        let key = createKey(D.self)
        
        guard let reference = dependencies.get(key: key) else {
            fatalError("Dependency \(key) not registered yet")
        }
        
        guard let someDependency = reference.dependency else {
            fatalError("Dependency \(key) is dealocated by system. \(reference)")
        }
        
        guard let dependency = someDependency as? D else {
            fatalError("Dependency \(key) cast failed to \(D.self)")
        }
        
        return dependency
    }
    
    public func resolveWeakly<D>() -> D? {
        let key = createKey(D.self)
        
        guard let reference = dependencies.get(key: key) else {
            fatalError("Dependency \(key) not registered yet")
        }
        
        // If deadlocated then return nil
        guard let someDependency = reference.dependency else {
            return nil
        }
        
        guard let dependency = someDependency as? D else {
            fatalError("Dependency \(key) cast failed to \(D.self)")
        }
        
        return dependency
    }
    
    public func flush() {
        dependencies.removeAll()
    }
}
