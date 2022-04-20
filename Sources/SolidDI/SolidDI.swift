public struct SolidDI { }

public class DIContainer {

    private let factories = FactoriesStore()

    private let strongDependencies = StrongDependenciesStore()

    private let weakDependencies = WeakDependenciesStore()

    public func register<P>(_ as: P.Type, factory: @escaping InitializationFactory) -> Last {
        let key = DependencyKey<P>.create()

        return Last(
            key: key,
            factory: factory,
            diContainer: self,
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

public class Last {

    private let key: String

    private let factory: InitializationFactory

    private let diContainer: DIContainer

    private let factories: FactoriesStore

    private let strongDependencies: StrongDependenciesStore

    private let weakDependencies: WeakDependenciesStore

    init(
        key: String,
        factory: @escaping InitializationFactory,
        diContainer: DIContainer,
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
