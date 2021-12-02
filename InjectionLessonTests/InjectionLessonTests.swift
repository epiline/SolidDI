//
//  InjectionLessonTests.swift
//  InjectionLessonTests
//
//  Created by Женя on 02.12.2021.
//

import XCTest
@testable import InjectionLesson

protocol MockServiceProtocol: AnyObject { }
class MockService: MockServiceProtocol { }

class InjectionLessonTests: XCTestCase {

    func basicFlow() throws {
        DIContainer.register(MockService() as MockServiceProtocol)
        
        @Inject var mockService: MockServiceProtocol
        
        XCTAssertTrue(mockService is MockService)
    }
}
