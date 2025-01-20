// swift-tools-version:5.1
import PackageDescription

let package = Package(
    name: "TypographyKit",
    platforms: [
        .iOS(.v11)
    ],
    products: [
        .library(
            name: "TypographyKit",
            targets: ["TypographyKit"]
        )
    ],
    dependencies: [
        .package(
            url: "https://github.com/rwbutler/LetterCase",
            from: "2.0.0"
        )
    ],
    targets: [
        .target(
            name: "TypographyKit",
            dependencies: ["LetterCase"],
            path: "TypographyKit/Classes"
        )
    ]
)
