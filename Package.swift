// swift-tools-version: 6.4

import PackageDescription

let package = Package(
    name: "swift-set-algebra",
    platforms: [
        .macOS(.v27),
        .iOS(.v27),
        .tvOS(.v27),
        .watchOS(.v27),
        .visionOS(.v27),
    ],
    products: [

        .library(
            name: "Set Algebra",
            targets: ["Set Algebra"]
        ),

        .library(
            name: "Set Algebra Test Support",
            targets: ["Set Algebra Test Support"]
        ),
    ],
    dependencies: [

        .package(
            url: "https://github.com/swift-atoms/swift-set.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-molecules/swift-builder.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-atoms/swift-iterator.git",
            branch: "main"
        ),

        .package(
            url: "https://github.com/swift-atoms/swift-algebra.git",
            branch: "main"
        ),
    ],
    targets: [

        .target(
            name: "Set Algebra",
            dependencies: [
                .product(name: "Set", package: "swift-set"),
                .product(name: "Builder", package: "swift-builder"),
                .product(name: "Iterator", package: "swift-iterator"),
                .product(name: "Algebra", package: "swift-algebra"),
            ]
        ),

        .target(
            name: "Set Algebra Test Support",
            dependencies: [
                "Set Algebra",

                .product(name: "Iterator", package: "swift-iterator"),
                .product(name: "Set Test Support", package: "swift-set"),
            ],
            path: "Tests/Support"
        ),

        .testTarget(
            name: "Set Algebra Tests",
            dependencies: [
                "Set Algebra",
                "Set Algebra Test Support",
            ],
            path: "Tests/Set Algebra Tests"
        ),
    ],
    swiftLanguageModes: [.v6]
)

for target in package.targets where ![.system, .binary, .plugin, .macro].contains(target.type) {
    let ecosystem: [SwiftSetting] = [
        .strictMemorySafety(),
        .enableUpcomingFeature("ExistentialAny"),
        .enableUpcomingFeature("InternalImportsByDefault"),
        .enableUpcomingFeature("MemberImportVisibility"),
        .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
        .enableExperimentalFeature("Lifetimes"),
        .enableUpcomingFeature("InferIsolatedConformances"),
    ]

    let package: [SwiftSetting] = []

    target.swiftSettings = (target.swiftSettings ?? []) + ecosystem + package
}
