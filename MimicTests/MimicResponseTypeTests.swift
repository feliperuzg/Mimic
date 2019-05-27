//
//  MimicResponseTypeTests.swift
//  MimicTests
//
//  Created by Felipe Ruz on 5/24/19.
//  Copyright © 2019 Felipe Ruz. All rights reserved.
//

@testable import Mimic
import XCTest

class MimicResponseTypeTests: XCTestCase {
    var sut: MimicResponseType!

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func testSuccessShouldMatch() {
        let response = URLResponse(
            url: URL(string: "http://localhost")!,
            mimeType: nil,
            expectedContentLength: 0,
            textEncodingName: nil
        )
        sut = .success(response, .empty)
        let compareObject = sut

        XCTAssertEqual(sut, compareObject)
    }

    func testSuccessShouldNotMatch() {
        let response = URLResponse(
            url: URL(string: "http://localhost")!,
            mimeType: nil,
            expectedContentLength: 0,
            textEncodingName: nil
        )
        sut = .success(response, .empty)
        let compareObject = MimicResponseType.success(response, .content(Data()))

        XCTAssertNotEqual(sut, compareObject)
    }

    func testSuccessAndFailureShouldNotMatch() {
        let response = URLResponse(
            url: URL(string: "http://localhost")!,
            mimeType: nil,
            expectedContentLength: 0,
            textEncodingName: nil
        )
        sut = .success(response, .empty)
        let compareObject = MimicResponseType.failure(NSError())

        XCTAssertNotEqual(sut, compareObject)
    }

    func testFailureShouldMatch() {
        sut = .failure(NSError(domain: "", code: 0, userInfo: nil))

        let compareObject = MimicResponseType.failure(NSError(domain: "", code: 0, userInfo: nil))

        XCTAssertEqual(sut, compareObject)
    }

    func testFailureShouldNotMatch() {
        sut = .failure(NSError(domain: "", code: 0, userInfo: nil))

        let compareObject = MimicResponseType.failure(NSError(domain: "", code: 1, userInfo: nil))

        XCTAssertNotEqual(sut, compareObject)
    }
}
