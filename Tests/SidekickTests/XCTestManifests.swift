import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(SidekickTests.allTests),
        testCase(PredicateTests.allTests),
    ]
}
#endif
