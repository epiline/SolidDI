//
//  SingletonRegister.swift
//
//
//  Created by Женя on 20.04.2022.
//

import Foundation

final internal class SingletonRegister: DependenciesRegisterResolvable {
    
    let dependencies = DependencyReferencesStore()
    
    func isExist(key: String) -> Bool {
        return dependencies.get(key: key) != nil
    }
    
    func resolve<D>(by key: String, diContainer: DIContainer) -> D {
        if let reference = dependencies.get(key: key) {
            return resolveDependency(by: key, reference: reference)
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
}
