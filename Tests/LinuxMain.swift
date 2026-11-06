import XCTest

import connect_iosTests

var tests = [XCTestCaseEntry]()
tests += connect_iosTests.allTests()
tests += SDKVersionTests.allTests()
XCTMain(tests)
