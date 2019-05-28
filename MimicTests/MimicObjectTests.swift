//
//  MimicObjectTests.swift
//  MimicTests
//
//  Created by Felipe Ruz on 5/24/19.
//  Copyright © 2019 Felipe Ruz. All rights reserved.
//

@testable import Mimic
import XCTest

class MimicObjectTests: XCTestCase {
    var sut: MimicObject!

    override func tearDown() {
        Mimic.stopAllMimics()
        sut = nil
        super.tearDown()
    }

    func testCanInit() {
        sut = MimicObject(
            request: request(with: .get, url: "http://localhost"),
            delay: 2,
            response: response(with: [:])
        )
        XCTAssertNotNil(sut)
        XCTAssertEqual(sut.delay, 2)
    }

    func testCanInitWithoutDelay() {
        sut = MimicObject(
            request: request(with: .get, url: "http://localhost"),
            response: response(with: [:])
        )

        XCTAssertNotNil(sut)
        XCTAssertEqual(sut.delay, 0)
    }

    func testComparison() {
        sut = MimicObject(
            request: request(with: .get, url: "http://localhost"),
            response: response(with: [:])
        )

        let compareObject = sut

        XCTAssertEqual(sut, compareObject)
    }

    func testComparsionShouldFail() {
        sut = MimicObject(
            request: request(with: .get, url: "http://localhost"),
            response: response(with: [:])
        )

        let compareObject = MimicObject(
            request: request(with: .get, url: "http://localhost"),
            response: response(with: [:])
        )

        XCTAssertNotEqual(sut, compareObject)
    }
}
