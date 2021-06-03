// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ConnectKit",
    platforms: [
        .iOS(.v9)
    ],
    products: [
        .library(name: "ConnectIOS", targets: ["ConnectIOS"]),
        .library(name: "ConnectKit", targets: ["ConnectKit"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "ConnectIOS",
            dependencies: []),
        .target(
            name: "ConnectKit",
            dependencies: [])
    ]
)
/*
let package = Package(
    name: "ConnectKit",
    platforms: [
        .iOS(.v9)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(name: "ConnectIOS", targets: ["ConnectIOS"]),
        .library(name: "ConnectKit", targets: ["ConnectKit"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(name: "ConnectIOS", dependencies: []),
        .target(name: "ConnectKit", dependencies: []),
        .testTarget(name: "ConnectKitTests", dependencies: ["ConnectKit"]),
        .testTarget(name: "ConnectIOSTests", dependencies: ["ConnectIOS"]),
    ]
)
*/
