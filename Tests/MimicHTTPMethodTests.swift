//
//  MimicHTTPMethodTests.swift
//  MimicTests
//
//  Created by Felipe Ruz on 5/24/19.
//  Copyright © 2019 Felipe Ruz. All rights reserved.
//

@testable import Mimic
import XCTest

class MimicHTTPMethodTests: XCTestCase {
    var sut: MimicHTTPMethod!

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func testDescriptionProperty() {
        sut = .get

        XCTAssertEqual(sut.description, "GET")

        sut = .post

        XCTAssertEqual(sut.description, "POST")

        sut = .put

        XCTAssertEqual(sut.description, "PUT")

        sut = .delete

        XCTAssertEqual(sut.description, "DELETE")
    }
}
