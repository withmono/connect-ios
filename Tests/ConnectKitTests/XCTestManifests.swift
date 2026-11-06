import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(ConnectKitTests.allTests),
        testCase(SDKVersionTests.allTests),
    ]
}
#endif
