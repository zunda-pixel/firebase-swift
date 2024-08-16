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
    ),
    .library(
      name: "RemoteConfig",
      targets: ["RemoteConfig"]
    ),
    .library(
      name: "Firestore",
      targets: ["Firestore"]
    )
  ],
  dependencies: [
    .package(url: "https://github.com/apple/swift-http-types", from: "1.3.0"),
    .package(url: "https://github.com/swiftlang/swift-testing", from: "0.12.0"),
    .package(url: "https://github.com/zunda-pixel/http-client", from: "0.2.0"),
  ],
  targets: [
    .target(
      name: "Auth",
      dependencies: [
        .product(name: "HTTPClient", package: "http-client"),
        .product(name: "HTTPTypes", package: "swift-http-types"),
      ]
    ),
    .testTarget(
      name: "AuthTests",
      dependencies: [
        .target(name: "Auth"),
        .product(name: "HTTPClientFoundation", package: "http-client"),
        .product(name: "Testing", package: "swift-testing"),
      ]
    ),
    .target(
      name: "RemoteConfig",
      dependencies: [
        .product(name: "HTTPClient", package: "http-client"),
        .product(name: "HTTPTypes", package: "swift-http-types"),
      ],
      exclude: [
        "README.md",
      ]
    ),
    .testTarget(
      name: "RemoteConfigTests",
      dependencies: [
        .target(name: "RemoteConfig"),
        .product(name: "HTTPClientFoundation", package: "http-client"),
        .product(name: "Testing", package: "swift-testing"),
      ]
    ),
    .target(
      name: "Firestore",
      dependencies: [
        .product(name: "HTTPClient", package: "http-client"),
        .product(name: "HTTPTypes", package: "swift-http-types"),
      ]
    ),
    .testTarget(
      name: "FirestoreTests",
      dependencies: [
        .target(name: "Firestore"),
        .product(name: "HTTPClientFoundation", package: "http-client"),
        .product(name: "Testing", package: "swift-testing"),
      ]
    ),
  ]
)
