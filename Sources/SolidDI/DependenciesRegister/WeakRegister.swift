//
//  WeakDependenciesRegister.swift
//
//
//  Created by Женя on 20.04.2022.
//

import Foundation

final internal class WeakRegister: DependenciesRegisterResolvable {
    
    let references = DependencyReferencesStore()
    
    let configurations = ConfigurationsStore()
    
    func isExist(key: String) -> Bool {
        return references.get(key: key) != nil
    }
    
    func resolve<D>(by key: String, diContainer: DIContainer) -> D {
        // Если объект со слабой ссылкой уничтожился, то создаем новый по заданой конфигурации
        let configurate: () -> D = { [self] in
            let newEntity: D = self.configurateNewEntity(by: key, diContainer: diContainer)
            let reference = WeakReference(newEntity as AnyObject)
            self.references.set(key: key, dependency: reference)
            
            return newEntity
        }
        
        guard let reference = references.get(key: key) else {
            return configurate()
        }
        
        guard let dependency: D = resolveDependency(by: key, reference: reference) else {
            return configurate()
        }
        
        return dependency
    }
    
    private func resolveDependency<D>(by key: String, reference: DependencyReferenceProtocol) -> D? {
        guard let someDependency = reference.dependency else {
            // Dependency is dealocated by system.
            return nil
        }

        guard let dependency = someDependency as? D else {
            fatalError("Dependency \(key) cast failed to \(D.self)")
        }

        return dependency
    }
    
    private func configurateNewEntity<D>(
        by key: String,
        diContainer: DIContainer
    ) -> D {
        guard let configuration = configurations.get(key: key) else {
            fatalError("Configuration \(key) \(D.self) not found")
        }
        
        guard let dependency = configuration(diContainer) as? D else {
            fatalError("Dependency \(key) cast failed to \(D.self)")
        }
        
        return dependency
    }
}
