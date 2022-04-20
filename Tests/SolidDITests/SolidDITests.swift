import XCTest
@testable import SolidDI

final class SolidDITests: XCTestCase {

    fileprivate var di: DIContainer!

    override func setUp() {
        di = DIContainer()
    }

    override func tearDown() {
        di = nil
    }

    func test_ClassKey() {
        let key = DependencyKey<ComputerMock>.create()

        XCTAssertEqual(key, "ComputerMock")
    }

    func test_OptionalClassKey() throws {
        let key = DependencyKey<ComputerMock?>.create()

        XCTAssertEqual(key, "ComputerMock")
    }

    func test_ProtocolKey() {
        let key = DependencyKey<ComputerProtocolMock>.create()

        XCTAssertEqual(key, "ComputerProtocolMock")
    }

    func test_OptionalProtocolKey() throws {
        let key = DependencyKey<ComputerProtocolMock?>.create()

        XCTAssertEqual(key, "ComputerProtocolMock")
    }

    func testSingletonDependency() {
        // Ставим сильную ссылку на объект
        var computer: ComputerProtocolMock? = ComputerMock(ram: nil)

        // Регистрируем объект как синглтон
        di.register(ComputerProtocolMock?.self) { [computer] _ in
            return computer!
        }
        .asSingleton()

        // Уничтожаем объект
        computer = nil

        // Получаем объект по интерфейсу из `DIContainer'а`
        let anotherComputer: ComputerProtocolMock? = di.resolve()

        // Класс не должен быть уничтожен, так как захвачен `DIContainer'ом`
        //
        // Теперь `DIContainer` управляет жизненным циклом объекта
        XCTAssertNotNil(anotherComputer)
    }

    func testRegenerableDependency() {
        var computer: ComputerProtocolMock? = ComputerMock(ram: nil)

        // Регистрируем зависимость как слабую
        di.register(ComputerProtocolMock.self) { [computer] _ in
            return computer as AnyObject
        }
        .asWeakRegenerable()

        // Симулируем работу ARC
        computer = nil

        // Резолвим зависимость из контейнера
        let anotherComputer: ComputerProtocolMock = di.resolve()

        // Проверяем ссылки старого и нового объекта
        //
        // Если ссылки не совпадают, значит `регенерация` мертвого объекта прошла успешно
        //
        // `ARC` удалил прошлый объект, а `DIContainer` создал новый по заданой конфигурации
        XCTAssertFalse(computer === anotherComputer, "Regeneration failed. Weak reference still dead.")
    }

    func testCascadeRegenerable() {
        di.register(RAM.self) { _ in
            RAM()
        }.asWeakRegenerable()

        di.register(ComputerProtocolMock.self) { di in
            ComputerMock(ram: di.resolve())
        }.asWeakRegenerable()

        let computer: ComputerProtocolMock = di.resolve()
        let ram: RAM = di.resolve()

        XCTAssertNotNil(computer.ram)
        XCTAssertNotNil(ram)
    }
}

fileprivate protocol ComputerProtocolMock: AnyObject {

    var ram: RAM? { get }
}

fileprivate class ComputerMock: ComputerProtocolMock {

    let ram: RAM?

    init(ram: RAM?) {
        self.ram = ram
    }
}

fileprivate class RAM { }
