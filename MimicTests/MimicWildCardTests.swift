//
//  MimicWildCardTests.swift
//  MimicTests
//
//  Created by Felipe Ruz on 7/26/19.
//  Copyright © 2019 Felipe Ruz. All rights reserved.
//

@testable import Mimic
import XCTest

class MimicWildCardTests: XCTestCase {
    override func tearDown() {
        Mimic.stopAllMimics()
        super.tearDown()
    }

    func testWildCardPath() {
        let url = "http://example.com/path1/path2/path3"
        let wildUrl = "http://example.com/@wild/path2/path3"

        Mimic.mimic(
            request: request(with: .get, url: wildUrl, wildCard: true),
            response: response(with: ["message": "wildcard"], status: 200, headers: nil)
        )

        let exp = expectation(description: "testWildCardPath")

        makeRequest(url: url, method: .get, headers: nil) { jsonDict in
            exp.fulfill()
            XCTAssertEqual(jsonDict["message"], "wildcard")
        }

        wait(for: [exp], timeout: 5)
    }

    func testMultipleWildCardPaths() {
        let url = "http://example.com/path1/path2/path3"
        let wildUrl = "http://example.com/@wild/path2/@wild"

        Mimic.mimic(
            request: request(with: .get, url: wildUrl, wildCard: true),
            response: response(with: ["message": "wildcard"], status: 200, headers: nil)
        )

        let exp = expectation(description: "testMultipleWildCardPaths")

        makeRequest(url: url, method: .get, headers: nil) { jsonDict in
            exp.fulfill()
            XCTAssertEqual(jsonDict["message"], "wildcard")
        }

        wait(for: [exp], timeout: 5)
    }

    func testWildCardQuery() {
        let url = "http://example.com/path?item1=value1&item2=value2&item3=value3"
        let wildUrl = "http://example.com/path?item1=@wild&item2=value2&item3=value3"

        Mimic.mimic(
            request: request(with: .get, url: wildUrl, wildCard: true),
            response: response(with: ["message": "wildcard"], status: 200, headers: nil)
        )

        let exp = expectation(description: "testWildCardQuery")

        makeRequest(url: url, method: .get, headers: nil) { jsonDict in
            exp.fulfill()
            XCTAssertEqual(jsonDict["message"], "wildcard")
        }

        wait(for: [exp], timeout: 5)
    }

    func testMultipleWildCardQuerys() {
        let url = "http://example.com/path?item1=value1&item2=value2&item3=value3"
        let wildUrl = "http://example.com/path?item1=@wild&item2=value2&item3=@wild"

        Mimic.mimic(
            request: request(with: .get, url: wildUrl, wildCard: true),
            response: response(with: ["message": "wildcard"], status: 200, headers: nil)
        )

        let exp = expectation(description: "testMultipleWildCardQuerys")

        makeRequest(url: url, method: .get, headers: nil) { jsonDict in
            exp.fulfill()
            XCTAssertEqual(jsonDict["message"], "wildcard")
        }

        wait(for: [exp], timeout: 5)
    }

    func testWildCardPathAndQuery() {
        let url = "http://example.com/path1/path2?item1=value1&item2=value2"
        let wildUrl = "http://example.com/path1/@wild?item1=@wild&item2=value2"

        Mimic.mimic(
            request: request(with: .get, url: wildUrl, wildCard: true),
            response: response(with: ["message": "wildcard"], status: 200, headers: nil)
        )

        let exp = expectation(description: "testWildCardPathAndQuery")

        makeRequest(url: url, method: .get, headers: nil) { jsonDict in
            exp.fulfill()
            XCTAssertEqual(jsonDict["message"], "wildcard")
        }

        wait(for: [exp], timeout: 5)
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
