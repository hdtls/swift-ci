// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.
//===----------------------------------------------------------------------===//
//
// This source file is part of the SwiftCI open source project
//
// Copyright (c) 2026 Junfeng Zhang and the SwiftCI project authors
// Licensed under Apache License v2.0
//
// See LICENSE.txt for license information
// See CONTRIBUTORS.txt for the list of SwiftCI project authors
//
// SPDX-License-Identifier: Apache-2.0
//
//===----------------------------------------------------------------------===//

import PackageDescription

let package = Package(
  name: "TestPackage",
  products: [
    // Products define the executables and libraries a package produces, making them visible to other packages.
    .library(
      name: "TestPackage",
      targets: ["TestPackage"]
    )
  ],
  targets: [
    // Targets are the basic building blocks of a package, defining a module or a test suite.
    // Targets can depend on other targets in this package and products from dependencies.
    .target(
      name: "TestPackage"
    ),
    .testTarget(
      name: "TestPackageTests",
      dependencies: ["TestPackage"]
    ),
  ]
)
