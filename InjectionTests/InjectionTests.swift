//
//  InjectionLessonTests.swift
//  InjectionLessonTests
//
//  Created by Женя on 02.12.2021.
//

import XCTest
@testable import InjectionLesson

// MARK: Mocks

protocol MockServiceProtocol: AnyObject { }
class MockService: MockServiceProtocol { }

class AnotherMockService { }

protocol ContainerMockServiceProtocol: AnyObject {
    
    var mockService: MockServiceProtocol { get }
    
    var anotherService: AnotherMockService { get }
    
    init(mockService: MockServiceProtocol, anotherService: AnotherMockService)
}

class ContainerMockService: ContainerMockServiceProtocol {
    
    var mockService: MockServiceProtocol
    
    var anotherService: AnotherMockService

    required init(mockService: MockServiceProtocol, anotherService: AnotherMockService) {
        self.mockService = mockService
        self.anotherService = anotherService
    }
}

// MARK: Tests

class InjectionLessonTests: XCTestCase {

    func testResolve() throws {
        DIContainer.instance.flush()
        
        // Register object under protocol
        
        DIContainer.instance.register(MockService(), as: MockServiceProtocol.self).asStrong()

        @Resolve var resolvedMockService: MockServiceProtocol
        
        XCTAssertTrue(resolvedMockService is MockService)
        
        // Register object
        
        DIContainer.instance.register(AnotherMockService(), as: AnotherMockService.self).asStrong()
        
        @Resolve var resolvedAnotherMockService: AnotherMockService
    }
    
    func testResolveWithFactory() {
        DIContainer.instance.flush()
        
        DIContainer.instance.register(MockService(), as: MockServiceProtocol.self).asStrong()
        DIContainer.instance.register(AnotherMockService(), as: AnotherMockService.self).asStrong()
        
        DIContainer.instance.register(ContainerMockServiceProtocol.self) { container in
            return ContainerMockService(mockService: container.resolve(), anotherService: container.resolve())
        }.asStrong()

        @Resolve var containerMockService: ContainerMockServiceProtocol

        XCTAssertTrue(containerMockService is ContainerMockService)
        XCTAssertTrue(containerMockService.mockService is MockService)
    }
    
    func testWeakDependencyDealocation() {
        DIContainer.instance.flush()
        
        // Register object under protocol
        
        DIContainer.instance.register(MockService(), as: MockServiceProtocol.self).asWeak()

        @ResolveWeakly var resolvedMockService: MockServiceProtocol?
        
        XCTAssertTrue(resolvedMockService == nil)
        
        // Register object
        
        DIContainer.instance.register(AnotherMockService(), as: AnotherMockService.self).asWeak()
        
        @ResolveWeakly var resolvedAnotherMockService: AnotherMockService?
        
        XCTAssertTrue(resolvedAnotherMockService == nil)
    }
    
    func testWeakDependencyNotDealocated() {
        DIContainer.instance.flush()
        
        // Register object under protocol
        
        let mockService: MockServiceProtocol = MockService()
        DIContainer.instance.register(mockService, as: MockServiceProtocol.self).asWeak()

        @ResolveWeakly var resolvedMockService: MockServiceProtocol?
        
        XCTAssertTrue(resolvedMockService != nil)
        
        // Register object
        
        let anotherMockService = AnotherMockService()
        DIContainer.instance.register(anotherMockService, as: AnotherMockService.self).asWeak()
        
        @ResolveWeakly var resolvedAnotherMockService: AnotherMockService?
        
        XCTAssertTrue(resolvedAnotherMockService != nil)
    }
    
    func testWeakDependencyLifeCycle() {
        DIContainer.instance.flush()
        
        var mockService: MockServiceProtocol? = MockService()
        DIContainer.instance.register(mockService, as: MockServiceProtocol.self).asWeak()
        
        @ResolveWeakly var resolvedMockService1: MockServiceProtocol?
        
        XCTAssertTrue(resolvedMockService1 != nil)
        
        mockService = nil
        resolvedMockService1 = nil
        
        @ResolveWeakly var resolvedMockService2: MockServiceProtocol?
        
        XCTAssertTrue(resolvedMockService2 == nil)
    }
}
