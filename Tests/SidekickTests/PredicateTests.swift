//
//  PredicateTests.swift
//  
//
//  Created by Vasilis Akoinoglou on 15/3/20.
//

import XCTest
@testable import Sidekick

@objcMembers
class Model: NSObject {
    let name: String
    let age: Int

    init(name: String, age: Int) {
        self.name = name
        self.age = age
        super.init()
    }
}

final class PredicateTests: XCTestCase {

    let bob   = Model(name: "Bob", age: 20)
    let alice = Model(name: "Alice", age: 23)
    let steve = Model(name: "Steve", age: 57)

    lazy var models: NSArray = [
        bob, alice, steve
    ]

    func testCompoundAnd() {
        let a = NSPredicate(format: "name == %@", "Alice")
        let b = NSPredicate(format: "age == %d", 23)
        let comp = a && b
        let result = models.filtered(using: comp) as? [Model]
        XCTAssertEqual(result, [alice])
    }

    func testTypedCompoundAnd() {
        let a = \Model.name == "Alice"
        let b = \Model.age == 23
        let comp = a && b
        let result = models.filtered(using: comp) as? [Model]
        XCTAssertEqual(result, [alice])
    }

    static var allTests = [
        ("testCompoundAnd", testCompoundAnd),
    ]
}
