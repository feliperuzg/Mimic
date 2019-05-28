//
//  MimicURLConfigurationTests.swift
//  MimicTests
//
//  Created by Felipe Ruz on 5/24/19.
//  Copyright © 2019 Felipe Ruz. All rights reserved.
//

@testable import Mimic
import XCTest

class MimicURLConfigurationTests: XCTestCase {
    override func setUp() {
        super.setUp()
        // FIXME: For some reason this need to be called twice to activate
        URLSessionConfiguration.activateMimic()
    }

    func testCanSwizzle() {
        URLSessionConfiguration.activateMimic()

        guard
            let defaultProtocols = URLSessionConfiguration.default.protocolClasses,
            let ephemeralProtocols = URLSessionConfiguration.ephemeral.protocolClasses
        else {
            fatalError("Failed to load protocols")
        }

        let defaultNames = defaultProtocols.map({ "\($0)" })
        let ephemeralNames = ephemeralProtocols.map({ "\($0)" })

        XCTAssertEqual(defaultNames.first, "MimicProtocol")
        XCTAssertEqual(ephemeralNames.first, "MimicProtocol")

        URLSessionConfiguration.deactivateMimic()

        guard
            let postDefaultProtocols = URLSessionConfiguration.default.protocolClasses,
            let postEphemeralProtocols = URLSessionConfiguration.ephemeral.protocolClasses
        else {
            fatalError("Failed to load protocols")
        }

        let postDefaultNames = postDefaultProtocols.map({ "\($0)" })
        let postEphemeralNames = postEphemeralProtocols.map({ "\($0)" })

        XCTAssertEqual(postDefaultNames.first, "_NSURLHTTPProtocol")
        XCTAssertFalse(postDefaultNames.contains("MimicProtocol"))
        XCTAssertEqual(postEphemeralNames.first, "_NSURLHTTPProtocol")
        XCTAssertFalse(postEphemeralNames.contains("MimicProtocol"))
    }
}
