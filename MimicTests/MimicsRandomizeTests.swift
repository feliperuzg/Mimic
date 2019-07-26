//
//  MimicTests.swift
//  MimicTests
//
//  Created by Felipe Ruz on 5/23/19.
//  Copyright © 2019 Felipe Ruz. All rights reserved.
//

@testable import Mimic
import XCTest

class MimicsRandomizeTests: XCTestCase {
    var exp: XCTestExpectation!
    var oneReceived: Bool!
    var twoReceived: Bool!

    override func setUp() {
        super.setUp()
        oneReceived = false
        twoReceived = false
    }

    override func tearDown() {
        Mimic.stopAllMimics()
        exp = nil
        oneReceived = nil
        twoReceived = nil
        super.tearDown()
    }

    func testRandomizeMimics() {
        let url = "http://localhost/randomize"
        Mimic.randomizeMimics = true
        Mimic.mimic(
            request: request(with: .get, url: url),
            response: response(with: ["message": "one"])
        )
        Mimic.mimic(
            request: request(with: .get, url: url),
            response: response(with: ["message": "two"])
        )

        exp = expectation(description: "testRandomizeMimics")
        exp.expectedFulfillmentCount = 2

        executeRequest(url: url, method: .get, headers: nil) { one, two in
            XCTAssertTrue(one)
            XCTAssertTrue(two)
        }

        wait(for: [exp], timeout: 10)
    }

    private func executeRequest(
        url: String,
        method: MimicHTTPMethod,
        headers: [String: String]?,
        completionHandler: @escaping (Bool, Bool) -> Void
    ) {
        makeRequest(url: url, method: method, headers: headers) { [weak self] jsonDict in
            let value = jsonDict["message"]
            print(jsonDict)
            if value == "one", let one = self?.oneReceived, !one {
                self?.oneReceived = true
                self?.exp.fulfill()
            }
            if value == "two", let two = self?.twoReceived, !two {
                self?.twoReceived = true
                self?.exp.fulfill()
            }
            if let one = self?.oneReceived, let two = self?.twoReceived, !one || !two {
                self?.executeRequest(
                    url: url,
                    method: method,
                    headers: headers,
                    completionHandler: completionHandler
                )
            }
        }
    }

    private func makeRequest(
        url: String,
        method: MimicHTTPMethod,
        headers: [String: String]?,
        completionHandler: @escaping ([String: String]) -> Void
    ) {
        guard let url = URL(string: url) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = method.description
        request.allHTTPHeaderFields = headers
        let task = URLSession.shared.dataTask(with: request) { data, _, _ in
            guard
                let data = data,
                let json = try? JSONSerialization.jsonObject(with: data, options: [.allowFragments]),
                let jsonDict = json as? [String: String]
            else {
                XCTFail("Failed to create JSON from data")
                return
            }
            completionHandler(jsonDict)
        }
        task.resume()
    }
}
