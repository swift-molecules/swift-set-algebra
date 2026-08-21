// swift-tools-version: 6.4

import PackageDescription

let package = Package(
    name: "swift-set-algebra-primitives",
    platforms: [
        .macOS(.v27),
        .iOS(.v27),
        .tvOS(.v27),
        .watchOS(.v27),
        .visionOS(.v27),
    ],
    products: [

        .library(
            name: "Set Algebra Primitives",
            targets: ["Set Algebra Primitives"]
        ),

        .library(
            name: "Set Algebra Primitives Test Support",
            targets: ["Set Algebra Primitives Test Support"]
        ),
    ],
    dependencies: [

        .package(
            url: "https://github.com/swift-primitives/swift-set-primitives.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-primitives/swift-builder-primitives.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-primitives/swift-iterator-primitives.git",
            branch: "main"
        ),

        .package(
            url: "https://github.com/swift-primitives/swift-algebra-primitives.git",
            branch: "main"
        ),
    ],
    targets: [

        .target(
            name: "Set Algebra Primitives",
            dependencies: [
                .product(name: "Set Protocol Primitives", package: "swift-set-primitives"),
                .product(name: "Builder Primitives", package: "swift-builder-primitives"),
                .product(name: "Iterable", package: "swift-iterator-primitives"),
                .product(name: "Algebra Lattice Primitives", package: "swift-algebra-primitives"),
            ]
        ),

        .target(
            name: "Set Algebra Primitives Test Support",
            dependencies: [
                "Set Algebra Primitives",

                .product(
                    name: "Iterator Primitives Test Support",
                    package: "swift-iterator-primitives"
                ),
            ],
            path: "Tests/Support"
        ),

        .testTarget(
            name: "Set Algebra Primitives Tests",
            dependencies: [
                "Set Algebra Primitives",
                "Set Algebra Primitives Test Support",
            ],
            path: "Tests/Set Algebra Primitives Tests"
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
