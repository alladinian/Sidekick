//
//  PredicateTests.swift
//  
//
//  Created by Vasilis Akoinoglou on 15/3/20.
//

import XCTest
@testable import Sidekick

@objcMembers
fileprivate class Model: NSObject {
    let name: String
    let age: Int

    init(name: String, age: Int) {
        self.name = name
        self.age = age
        super.init()
    }
}

final class PredicateTests: XCTestCase {

    let models: NSArray = [
        Model(name: "Bob", age: 20),
        Model(name: "Alice", age: 23),
        Model(name: "Steve", age: 57)
    ]

    func testCompoundAnd() {
        let a = NSPredicate(format: "name == %@", "Alice")
        let b = NSPredicate(format: "age == %d", 23)
        let comp = a && b
        let result = models.filtered(using: comp) as? [Model]
        XCTAssertNotNil(result?.first)
        XCTAssertEqual(result?.first, (models as? [Model])?[1])
    }

    static var allTests = [
        ("testCompoundAnd", testCompoundAnd),
    ]
}
