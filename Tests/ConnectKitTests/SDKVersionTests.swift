import XCTest
@testable import ConnectKit

final class SDKVersionTests: XCTestCase {
    func testVersionMatchesPodspec() throws {
        // #filePath is <repo>/Tests/ConnectKitTests/SDKVersionTests.swift,
        // so the repo root is three directories up.
        let repoRoot = URL(fileURLWithPath: #filePath)
            .deletingLastPathComponent()
            .deletingLastPathComponent()
            .deletingLastPathComponent()
        let podspecPath = repoRoot.appendingPathComponent("ConnectKit.podspec")

        let podspec = try String(contentsOf: podspecPath, encoding: .utf8)
        let regex = try NSRegularExpression(
            pattern: "spec\\.version\\s*=\\s*\"(\\d+\\.\\d+\\.\\d+)\"")
        let range = NSRange(podspec.startIndex..., in: podspec)
        let match = regex.firstMatch(in: podspec, options: [], range: range)

        XCTAssertNotNil(match, "spec.version not found in ConnectKit.podspec")
        if let match = match {
            let version = (podspec as NSString).substring(with: match.range(at: 1))
            XCTAssertEqual(
                MonoSDKVersion.version, version,
                "MonoSDKVersion.version must match spec.version in ConnectKit.podspec")
        }
    }

    func testVersionIsPlainSemver() {
        let predicate = NSPredicate(
            format: "SELF MATCHES %@", "^\\d+\\.\\d+\\.\\d+$")
        XCTAssertTrue(
            predicate.evaluate(with: MonoSDKVersion.version),
            "sdk version must be plain MAJOR.MINOR.PATCH semver")
    }

    static var allTests = [
        ("testVersionMatchesPodspec", testVersionMatchesPodspec),
        ("testVersionIsPlainSemver", testVersionIsPlainSemver),
    ]
}
