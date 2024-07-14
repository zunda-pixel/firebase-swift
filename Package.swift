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
    .package(url: "https://github.com/zunda-pixel/swift-http-types", branch: "fix-swift-6"),
    .package(url: "https://github.com/apple/swift-testing", from: "0.10.0"),
  ],
  targets: [
    .target(
      name: "Auth",
      dependencies: [
        .target(name: "HTTPClient"),
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
    .target(
      name: "HTTPClient",
      dependencies: [
        .product(name: "HTTPTypes", package: "swift-http-types"),
        .product(name: "HTTPTypesFoundation", package: "swift-http-types"),
      ]
    ),
  ]
)
