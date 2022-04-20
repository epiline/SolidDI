//
//  RegistrationConfigurator.swift
//  
//
//  Created by Женя on 20.04.2022.
//

import Foundation

final public class RegistrationConfigurator {

    private let key: String

    private let dependencyConfigurator: DependencyConfiguration

    private let diContainer: DIContainer

    private let singletonRegister: SingletonRegister

    private let weakRegister: WeakRegister
    
    private let lazySingletonRegister: LazySingletonRegister

    init(
        diContainer: DIContainer,
        key: String,
        dependencyConfigurator: @escaping DependencyConfiguration,
        singletonRegister: SingletonRegister,
        weakRegister: WeakRegister,
        lazySingletonRegister: LazySingletonRegister
    ) {
        self.key = key
        self.dependencyConfigurator = dependencyConfigurator
        self.diContainer = diContainer
        self.singletonRegister = singletonRegister
        self.weakRegister = weakRegister
        self.lazySingletonRegister = lazySingletonRegister
    }

    func asSingleton() {
        singletonRegister.dependencies.set(
            key: key,
            dependency: StrongReference(dependencyConfigurator(diContainer))
        )
    }
    
    func asLazySingleton() {
        lazySingletonRegister.configurations.set(
            key: key,
            dependencyConfigurator: dependencyConfigurator
        )
    }

    func asWeak() {
        weakRegister.configurations.set(
            key: key,
            dependencyConfigurator: dependencyConfigurator
        )
        weakRegister.references.set(
            key: key,
            dependency: WeakReference(dependencyConfigurator(diContainer))
        )
    }
}
