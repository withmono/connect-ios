import XCTest
@testable import connect_ios

final class ConnectKitTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(connect_ios().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
