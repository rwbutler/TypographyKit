// swift-tools-version:5.1
import PackageDescription

let package = Package(
    name: "TypographyKit",
    platforms: [
        .iOS("8.2")
    ],
    products: [
        .library(
            name: "TypographyKit",
            targets: ["TypographyKit"]
        )
    ],
    targets: [
        .target(
            name: "TypographyKit",
            path: "TypographyKit/Classes"
        )
    ]
)
