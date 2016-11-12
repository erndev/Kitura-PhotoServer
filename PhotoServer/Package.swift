import PackageDescription

let package = Package(
  name: "PhotoServer",
  dependencies: [
    .Package(url: "https://github.com/IBM-Swift/Kitura.git", majorVersion: 1, minor: 1),
    .Package(url: "https://github.com/IBM-Swift/HeliumLogger.git", majorVersion: 1, minor: 1),
    .Package(url: "https://github.com/IBM-Swift/Kitura-Cache", majorVersion: 1, minor: 1),
  ])
