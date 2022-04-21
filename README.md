# SolidDI
Simple solution for DIC

# Dependecy registration

### Single dependency

```swift

diContainer
    .register(XMLDecodable.self) { _ in
        return XMLDecoder()
    }
    .asSingleton()

```

### Lazy single dependency

```swift

diContainer
    .register(ErrorLoggable.self) { _ in
        return LocalErrorLogger()
    }
    .asLazySingleton()

```

### Weak dependency

```swift

diContainer
    .register(XMLValidator.self) { _ in
        return XMLValidator()
    }
    .asWeak()

```

# Dependency resolvation

### Local DI container

```swift

let diContainer = DIContainer()

diContainer
    .register(XMLDecodable.self) { _ in
        return XMLDecoder()
    }
    .asLazySingleton()

let decoder1: XMLDecodable = diContainer.resolve()
// or
@Resolve(container: diContainer) var decoder2: XMLDecodable

```

### Global DI container

```swift

GlobalDI
    .container
    .register(XMLDecodable.self) { _ in
        return XMLDecoder()
    }
    .asLazySingleton()

let decoder1: XMLDecodable = GlobalDI.container.resolve()
// or
@Resolve var decoder2: XMLDecodable

```

# Registration/Resolvation graph

<img width="1134" alt="Снимок экрана 2022-04-21 в 02 36 09" src="https://user-images.githubusercontent.com/30548311/164341581-b3434d4d-5b3a-43a1-accf-df9dbc21ca37.png">

# Swift Package Manager
                                                       
[Swift Package Manager](https://swift.org/package-manager/) is a tool for 
managing the distribution of Swift code. It’s integrated with the Swift build
system to automate the process of downloading, compiling, and linking
dependencies on all platforms.

<img width="854" alt="Снимок экрана 2022-04-21 в 03 06 48" src="https://user-images.githubusercontent.com/30548311/164344209-25610e67-7d3c-4606-8e42-64acee0cd5c9.png">

