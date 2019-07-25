//
//  MimicProtocolTests.swift
//  MimicTests
//
//  Created by Felipe Ruz on 5/24/19.
//  Copyright © 2019 Felipe Ruz. All rights reserved.
//

@testable import Mimic
import XCTest

class MimicProtocolTests: XCTestCase {
    override func tearDown() {
        MimicProtocol.stopAllMimics()
        super.tearDown()
    }

    func testCanAddNewMimic() {
        let object = MimicObject(
            request: request(with: .get, url: "http://localhost"),
            response: response(with: [:])
        )

        XCTAssertTrue(MimicProtocol.mimics.isEmpty)

        _ = MimicProtocol.mimic(object)

        XCTAssertEqual(MimicProtocol.mimics.count, 1)
    }

    func testCanDeleteSingleMimic() {
        let object = MimicProtocol.mimic(
            MimicObject(
                request: request(with: .get, url: "http://localhost"),
                response: response(with: [:])
            )
        )

        XCTAssertEqual(MimicProtocol.mimics.count, 1)

        MimicProtocol.stopMimic(object)

        XCTAssertTrue(MimicProtocol.mimics.isEmpty)
    }

    func testCanRemoveAllMimics() {
        XCTAssertTrue(MimicProtocol.mimics.isEmpty)

        _ = MimicProtocol.mimic(
            MimicObject(
                request: request(with: .get, url: "http://localhost"),
                response: response(with: [:])
            )
        )

        XCTAssertEqual(MimicProtocol.mimics.count, 1)

        _ = MimicProtocol.mimic(
            MimicObject(
                request: request(with: .post, url: "http://localhost"),
                response: response(with: [:])
            )
        )

        XCTAssertEqual(MimicProtocol.mimics.count, 2)

        MimicProtocol.stopAllMimics()

        XCTAssertTrue(MimicProtocol.mimics.isEmpty)
    }

    func testGetMimic() {
        let object = MimicProtocol.mimic(
            MimicObject(
                request: request(with: .get, url: "http://localhost"),
                response: response(with: [:])
            )
        )

        XCTAssertEqual(MimicProtocol.mimics.count, 1)

        let urlRequest = URLRequest(url: URL(string: "http://localhost")!)

        let compareObject = MimicProtocol.mimic(for: urlRequest)

        XCTAssertEqual(object, compareObject)
    }

    func testGetMultipleMimics() {
        let mimic1 = MimicProtocol.mimic(
            MimicObject(
                request: request(with: .get, url: "http://localhost"),
                response: response(with: [:])
            )
        )

        let mimic2 = MimicProtocol.mimic(
            MimicObject(
                request: request(with: .get, url: "http://localhost"),
                response: response(with: [:])
            )
        )

        XCTAssertEqual(MimicProtocol.mimics.count, 2)

        let urlRequest = URLRequest(url: URL(string: "http://localhost")!)

        let compareObject = MimicProtocol.mimics(for: urlRequest)

        XCTAssertEqual([mimic1, mimic2], compareObject)
    }

    func testGetMimicShouldFail() {
        let object = MimicProtocol.mimic(
            MimicObject(
                request: request(with: .get, url: "http://localhost"),
                response: response(with: [:])
            )
        )

        XCTAssertEqual(MimicProtocol.mimics.count, 1)

        var urlRequest = URLRequest(url: URL(string: "http://localhost")!)
        urlRequest.httpMethod = "POST"

        let compareObject = MimicProtocol.mimic(for: urlRequest)

        XCTAssertNotEqual(object, compareObject)
        XCTAssertNil(compareObject)
    }

    func testCanInit() {
        let urlRequest = URLRequest(url: URL(string: "http://localhost")!)

        XCTAssertFalse(MimicProtocol.canInit(with: urlRequest))

        _ = MimicProtocol.mimic(
            MimicObject(
                request: request(with: .get, url: "http://localhost"),
                response: response(with: [:])
            )
        )

        XCTAssertTrue(MimicProtocol.canInit(with: urlRequest))
    }
}
