// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AlamofireNetworkLogger",
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "AlamofireNetworkLogger",
            targets: ["AlamofireNetworkLogger"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/Alamofire/Alamofire", .upToNextMajor(from: "5.6.2")),
    ],
    targets: [
        .target(
            name: "AlamofireNetworkLogger",
            dependencies: [
                .product(name: "Alamofire", package: "Alamofire")
            ]
        ),
    ]
)
