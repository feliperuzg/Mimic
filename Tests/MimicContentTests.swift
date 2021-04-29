//
//  MimicContentTests.swift
//  MimicTests
//
//  Created by Felipe Ruz on 5/24/19.
//  Copyright © 2019 Felipe Ruz. All rights reserved.
//

@testable import Mimic
import XCTest

class MimicContentTests: XCTestCase {
    var sut: MimicContent!

    func testDefaultInitializer() {
        sut = MimicContent(nilLiteral: ())

        XCTAssertEqual(sut, MimicContent.empty)
    }

    func testInitializeWithData() {
        sut = MimicContent.content(Data())

        let compareObject = MimicContent.content("data".data(using: .utf8)!)

        XCTAssertNotEqual(sut, compareObject)
    }

    func testCasesAreDifferent() {
        sut = MimicContent.empty

        let compareObject = MimicContent.content(Data())

        XCTAssertNotEqual(sut, compareObject)
    }
}
