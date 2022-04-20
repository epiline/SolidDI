//
//  DependencyKeyTests.swift
//  
//
//  Created by Женя on 20.04.2022.
//

import XCTest
@testable import SolidDI

final class DependencyKeyTests: XCTestCase {

    func test_ClassKey() {
        let key = DependencyKey<ClassDummy>.create()

        XCTAssertEqual(key, "ClassDummy")
    }

    func test_OptionalClassKey() throws {
        let key = DependencyKey<ClassDummy?>.create()

        XCTAssertEqual(key, "ClassDummy")
    }

    func test_ProtocolKey() {
        let key = DependencyKey<ProtocolDummy>.create()

        XCTAssertEqual(key, "ProtocolDummy")
    }

    func test_OptionalProtocolKey() throws {
        let key = DependencyKey<ProtocolDummy?>.create()

        XCTAssertEqual(key, "ProtocolDummy")
    }
}

// MARK: Dummies

fileprivate class ClassDummy { }

fileprivate protocol ProtocolDummy { }
