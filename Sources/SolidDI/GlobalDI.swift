public final class GlobalDI {
    
    static let container = DIContainer()
}

public final class DIContainer {
    
    private let weakRegister = WeakRegister()
    
    private let singletonRegister = SingletonRegister()
    
    private let lazySingletonRegister = LazySingletonRegister()

    public func register<P>(
        _ as: P.Type,
        dependencyConfigurator: @escaping DependencyConfiguration
    ) -> RegistrationConfigurator {
        return .init(
            diContainer: self,
            key: DependencyKey<P>.create(),
            dependencyConfigurator: dependencyConfigurator,
            singletonRegister: singletonRegister,
            weakRegister: weakRegister,
            lazySingletonRegister: lazySingletonRegister
        )
    }

    public func resolve<D>() -> D {
        let key = DependencyKey<D>.create()
        
        let registers: [DependenciesRegisterResolvable] = [
            singletonRegister,
            weakRegister,
            lazySingletonRegister
        ]
        
        for register in registers where register.isExist(key: key) {
            return register.resolve(
                by: key,
                diContainer: self
            )
        }
        
        fatalError()
    }
}
