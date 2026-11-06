import XCTest
@testable import ConnectKit

final class ConnectKitTests: XCTestCase {
    func testSDKVersionIsExposed() {
        // The build-time constant must exist and be non-empty.
        XCTAssertFalse(MonoSDKVersion.version.isEmpty)
    }

    static var allTests = [
        ("testSDKVersionIsExposed", testSDKVersionIsExposed),
    ]
}
