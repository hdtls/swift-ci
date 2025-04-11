//===----------------------------------------------------------------------===//
//
// This source file is part of the Netbot open source project
//
// Copyright (c) 2025 Junfeng Zhang and the Netbot project authors
// Licensed under Apache License v2.0
//
// See LICENSE.txt for license information
// See CONTRIBUTORS.txt for the list of Netbot project authors
//
// SPDX-License-Identifier: Apache-2.0
//
//===----------------------------------------------------------------------===//

@testable import swift_ci

#if swift(>=6.0)
  import Testing
#else
  import XCTest
#endif

#if swift(>=6.0)
  @Test func example() async throws {
    // Write your test here and use APIs like `#expect(...)` to check expected conditions.
  }
#else
  final class Swift_ciTests: XCTestCase {
    func testExample() throws {

    }
  }
#endif
