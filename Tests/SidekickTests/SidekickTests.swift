import XCTest
@testable import Sidekick

final class SidekickTests: XCTestCase {

    func testCastMap() {
        let list: [Any] = [1, "a", 3.14, "b", Date()]
        XCTAssertEqual(list.castMap(String.self), list.compactMap({ $0 as? String }))
    }

    func testCompacted() {
        let list: [String?] = ["a", nil, "b", nil]
        XCTAssertEqual(list.compacted(), list.compactMap({ $0 }))
    }

    static var allTests = [
        ("testCastMap", testCastMap),
        ("testCompacted", testCompacted),
    ]
}
