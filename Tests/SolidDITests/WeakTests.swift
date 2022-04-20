//
//  WeakTests.swift
//  
//
//  Created by Женя on 20.04.2022.
//

import XCTest
@testable import SolidDI

final class WeakTests: XCTestCase {

    fileprivate var di: DIContainer!

    override func setUp() {
        di = DIContainer()
    }

    override func tearDown() {
        di = nil
    }
    
    func test_WeakDependency() {
        var computer: ComputerDummyProtocol? = ComputerDummy(ram: nil)

        // Регистрируем зависимость как слабую
        di.register(ComputerDummyProtocol.self) { [computer] _ in
            return computer as AnyObject
        }
        .asWeak()

        // Симулируем работу ARC
        computer = nil

        // Резолвим зависимость из контейнера
        let anotherComputer: ComputerDummyProtocol = di.resolve()

        // Проверяем ссылки старого и нового объекта
        //
        // Если ссылки не совпадают, значит `регенерация` мертвого объекта прошла успешно
        //
        // `ARC` удалил прошлый объект, а `DIContainer` создал новый по заданой конфигурации
        XCTAssertFalse(computer === anotherComputer, "Regeneration failed. Weak reference still dead.")
    }
    
    func test_WeakPropertyWrapperResolvation() {
        di.register(RAMDummy.self) { _ in
            RAMDummy()
        }
        .asWeak()
        
        @Resolve(container: di) var ram: RAMDummy?
        
        XCTAssertNotNil(ram)
    }
    
    func test_WeakCascadeResolvation() {
        di.register(RAMDummy.self) { _ in
            RAMDummy()
        }
        .asWeak()

        di.register(ComputerDummyProtocol.self) { di in
            ComputerDummy(ram: di.resolve())
        }
        .asWeak()

        let computer: ComputerDummyProtocol? = di.resolve()
        let ram: RAMDummy? = di.resolve()

        XCTAssertNotNil(ram)
        XCTAssertNotNil(computer?.ram)
    }
}

// MARK: Dummies

fileprivate protocol ComputerDummyProtocol: AnyObject {

    var ram: RAMDummy? { get }
}

fileprivate class ComputerDummy: ComputerDummyProtocol {

    let ram: RAMDummy?

    init(ram: RAMDummy?) {
        self.ram = ram
    }
}

fileprivate class RAMDummy { }
