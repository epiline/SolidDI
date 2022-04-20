//
//  SingletonTests.swift
//  
//
//  Created by Женя on 20.04.2022.
//

import XCTest
@testable import SolidDI

final class SingletonTests: XCTestCase {

    fileprivate var di: DIContainer!

    override func setUp() {
        di = DIContainer()
    }

    override func tearDown() {
        di = nil
    }
    
    func test_SingletonDependencyManualResolvation() {
        // Ставим сильную ссылку на объект
        var computer: ComputerDummyProtocol? = ComputerDummy(ram: nil)

        // Регистрируем объект как синглтон
        di.register(ComputerDummyProtocol?.self) { [computer] _ in
            return computer!
        }
        .asSingleton()

        // Уничтожаем объект
        computer = nil

        // Получаем объект по интерфейсу из `DIContainer'а`
        let anotherComputer: ComputerDummyProtocol? = di.resolve()

        // Класс не должен быть уничтожен, так как захвачен `DIContainer'ом`
        //
        // Теперь `DIContainer` управляет жизненным циклом объекта
        XCTAssertNotNil(anotherComputer)
    }
    
    func test_SingletonPropertyWrapperResolvation() {
        di.register(RAMDummy.self) { _ in
            RAMDummy()
        }
        .asSingleton()
        
        @Resolve(container: di) var ram: RAMDummy?
        
        XCTAssertNotNil(ram)
    }
    
    func test_SingleCascadeResolvation() {
        di.register(RAMDummy.self) { _ in
            RAMDummy()
        }
        .asSingleton()

        di.register(ComputerDummyProtocol.self) { di in
            ComputerDummy(ram: di.resolve())
        }
        .asSingleton()

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
