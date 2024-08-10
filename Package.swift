// swift-tools-version: 6.0

import PackageDescription

let package = Package(
  name: "firebase-swift",
  platforms: [
    .macOS(.v14),
    .iOS(.v17),
  ],
  products: [
    .library(
      name: "Auth",
      targets: ["Auth"]
    )
  ],
  dependencies: [
    .package(url: "https://github.com/apple/swift-http-types", from: "1.3.0"),
    .package(url: "https://github.com/swiftlang/swift-testing", from: "0.11.0"),
    .package(url: "https://github.com/zunda-pixel/http-client", from: "0.1.3"),
  ],
  targets: [
    .target(
      name: "Auth",
      dependencies: [
        .product(name: "HTTPClient", package: "http-client"),
        .product(name: "HTTPTypes", package: "swift-http-types"),
        .product(name: "HTTPTypesFoundation", package: "swift-http-types"),
      ]
    ),
    .testTarget(
      name: "AuthTests",
      dependencies: [
        .target(name: "Auth"),
        .product(name: "Testing", package: "swift-testing"),
      ]
    ),
  ]
)
