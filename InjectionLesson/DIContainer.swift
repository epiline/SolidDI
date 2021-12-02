//
//  DIContainer.swift
//  InjectionLesson
//
//  Created by Женя on 02.12.2021.
//

public class DIContainer {
    
    private var dependencies: [String: AnyObject] = [:]
    
    private static var instance = DIContainer()
    
    public static func register<T>(_ dependency: T) {
        let key = createKey(T.self)
        instance.dependencies[key] = dependency as AnyObject
    }
    
    public static func resolve<T>() -> T {
        let key = createKey(T.self)
        guard let someDependency = instance.dependencies[key] else {
            fatalError("Dependency \(key) not registered yet")
        }
        
        guard let dependency = someDependency as? T else {
            fatalError("Dependency \(key) cast failed to \(T.self)")
        }
        
        return dependency
    }
    
    private static func createKey<T>(_ kk: T) -> String {
        return "\(T.self)"
    }
}
