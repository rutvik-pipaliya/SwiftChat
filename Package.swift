// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "SwiftChat",
    platforms: [
        .iOS(.v15),
        .macOS(.v12),
        .tvOS(.v15),
        .watchOS(.v8)
    ],
    products: [
        .library(
            name: "SwiftChat",
            targets: ["SwiftChat"]
        ),
    ],
    dependencies: [
        .package(
            url: "https://github.com/supabase/supabase-swift.git",
            from: "2.0.0"
        )
    ],
    targets: [
        .target(
            name: "SwiftChat",
            dependencies: [
                .product(name: "Supabase", package: "supabase-swift")
            ]
        ),

    ]
)
