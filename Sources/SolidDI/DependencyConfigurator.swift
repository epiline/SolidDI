//
//  DependencyConfigurator.swift
//  
//
//  Created by Женя on 20.04.2022.
//

import Foundation

final public class DependencyConfigurator {

    private let key: String

    private let factory: InitializationFactory

    private let diContainer: DIContainer

    private let factories: FactoriesStore

    private let strongDependencies: StrongDependenciesStore

    private let weakDependencies: WeakDependenciesStore

    init(
        diContainer: DIContainer,
        key: String,
        factory: @escaping InitializationFactory,
        factories: FactoriesStore,
        strongDependencies: StrongDependenciesStore,
        weakDependencies: WeakDependenciesStore
    ) {
        self.key = key
        self.factory = factory
        self.diContainer = diContainer
        self.factories = factories
        self.strongDependencies = strongDependencies
        self.weakDependencies = weakDependencies
    }

    func asSingleton() {
        strongDependencies.set(key: key, dependency: StrongDependencyReference(factory(diContainer)))
    }

    func asWeakRegenerable() {
        factories.set(key: key, factory: factory)
        weakDependencies.set(key: key, dependency: WeakDependencyReference(factory(diContainer)))
    }
}
