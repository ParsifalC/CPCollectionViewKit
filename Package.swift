// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CPCollectionViewKit",
    platforms: [
        .iOS(.v14)
    ],
    products: [
        .library(
            name: "CPCollectionViewKit",
            targets: ["CPCollectionViewKit"]
        )
    ],
    targets: [
        .target(
            name: "CPCollectionViewKit",
            path: "CPCollectionViewKit",
            exclude: ["Info.plist", "CPCollectionViewKit.h"],
            sources: [
                "CollectionViewLayout.swift",
                "LayoutConfiguration.swift",
                "CollectionViewCardLayout.swift",
                "CollectionViewCaterpillarLayout.swift",
                "CollectionViewCircleLayout.swift",
                "CollectionViewStageLayout.swift",
                "CollectionViewTimeMachineLayout.swift",
                "CollectionViewWheelLayout.swift",
                "CollectionViewTransitionLayout.swift",
                "CollectionViewTransitionManager.swift"
            ]
        )
    ],
    swiftLanguageVersions: [.v5]
)
