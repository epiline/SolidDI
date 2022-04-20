//
//  LazySingletonRegister.swift
//  
//
//  Created by Женя on 20.04.2022.
//

import Foundation

final internal class LazySingletonRegister: DependenciesRegisterResolvable {
    
    let configurations = ConfigurationsStore()
    
    let dependencies = DependencyReferencesStore()
    
    func isExist(key: String) -> Bool {
        return dependencies.get(key: key) != nil || configurations.get(key: key) != nil
    }
    
    func resolve<D>(by key: String, diContainer: DIContainer) -> D {
        if let reference = dependencies.get(key: key) {
            return resolveDependency(
                by: key,
                reference: reference
            )
        } else if let configuration = configurations.get(key: key) {
            return configurateDependency(
                by: key,
                diContainer: diContainer,
                configuration: configuration
            )
        } else {
            fatalError("Dependency \(key) \(D.self) not found")
        }
    }
    
    private func resolveDependency<D>(by key: String, reference: DependencyReferenceProtocol) -> D {
        guard let someDependency = reference.dependency else {
            fatalError("Dependency \(key) is dealocated by system. \(reference)")
        }

        guard let dependency = someDependency as? D else {
            fatalError("Dependency \(key) cast failed to \(D.self)")
        }

        return dependency
    }
    
    private func configurateDependency<D>(
        by key: String,
        diContainer: DIContainer,
        configuration: DependencyConfiguration
    ) -> D {
        guard let dependency = configuration(diContainer) as? D else {
            fatalError("Dependency \(key) cast failed to \(D.self)")
        }
        
        return dependency
    }
}
