// swift-tools-version:4.2
import PackageDescription

let package = Package(
    name: "Paginator",
    products: [
        .library(name: "Paginator", targets: ["Paginator"]),
    ],
    dependencies: [
        .package(url: "https://github.com/vapor/fluent.git", from: "3.2.0"),
        .package(url: "https://github.com/vapor/vapor.git", from: "3.3.0"),
        .package(url: "https://github.com/vapor/sql.git", from: "2.3.2"),
    ],
    targets: [
        .target(name: "Paginator", dependencies: ["Fluent", "SQL", "Vapor"]),
        .testTarget(name: "PaginatorTests", dependencies: ["Paginator"]),
    ]
)
