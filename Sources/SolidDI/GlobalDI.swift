public struct GlobalDI {
    
    static let container = DIContainer()
}

public class DIContainer {

    private let factories = FactoriesStore()

    private let strongDependencies = StrongDependenciesStore()

    private let weakDependencies = WeakDependenciesStore()

    public func register<P>(_ as: P.Type, factory: @escaping InitializationFactory) -> DependencyConfigurator {
        return .init(
            diContainer: self,
            key: DependencyKey<P>.create(),
            factory: factory,
            factories: factories,
            strongDependencies: strongDependencies,
            weakDependencies: weakDependencies
        )
    }

    public func resolve<D>() -> D {
        let key = DependencyKey<D>.create()

        if let strongReference = strongDependencies.get(key: key) {
            return strongResolvation(key: key, reference: strongReference)
        } else if let weakReference = weakDependencies.get(key: key) {
            return weakResolvation(key: key, reference: weakReference)
        } else if let factory = factories.get(key: key) {
            return factoryResolvation(key: key, factory: factory)
        } else {
            print("-------")
            print(strongDependencies.dependencies)
            print(weakDependencies.dependencies)
            print(factories.factories)
            fatalError("Dependency \(key) not registered yet")
        }
    }

    private func strongResolvation<D>(key: String, reference: DependencyReferenceProtocol) -> D {
        guard let someDependency = reference.dependency else {
            fatalError("Dependency \(key) is dealocated by system. \(reference)")
        }

        guard let dependency = someDependency as? D else {
            fatalError("Dependency \(key) cast failed to \(D.self)")
        }

        return dependency
    }

    private func weakResolvation<D>(key: String, reference: DependencyReferenceProtocol) -> D {
        // If deadlocated then return nil
        guard let someDependency = reference.dependency else {
            guard let factory = factories.get(key: key) else {
                fatalError("Dependency \(key) not registered yet")
            }

            return factoryResolvation(key: key, factory: factory)
        }

        guard let dependency = someDependency as? D else {
            fatalError("Dependency \(key) cast failed to \(D.self)")
        }

        return dependency
    }

    private func factoryResolvation<D>(key: String, factory: InitializationFactory) -> D {
        let someDependency = factory(self)

        weakDependencies.set(key: key, dependency: WeakDependencyReference(someDependency))

        guard let dependency = someDependency as? D else {
            fatalError("Dependency \(key) cast failed to \(D.self)")
        }

        return dependency
    }
}

final class FactoriesStore {

    var factories: [String: InitializationFactory] = [:]

    public func get(key: String) -> InitializationFactory? {
        return factories[key]
    }

    public func set(key: String, factory: @escaping InitializationFactory) {
        factories[key] = factory
    }
}

final public class StrongDependenciesStore {

    var dependencies: [String: DependencyReferenceProtocol] = [:]

    public func get(key: String) -> DependencyReferenceProtocol? {
        return dependencies[key]
    }

    public func set(key: String, dependency: DependencyReferenceProtocol) {
        dependencies[key] = dependency
    }
}

final public class WeakDependenciesStore {

    var dependencies: [String: DependencyReferenceProtocol] = [:]

    public func get(key: String) -> DependencyReferenceProtocol? {
        return dependencies[key]
    }

    public func set(key: String, dependency: DependencyReferenceProtocol) {
        dependencies[key] = dependency
    }
}
