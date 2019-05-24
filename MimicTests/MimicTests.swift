//
//  MimicTests.swift
//  MimicTests
//
//  Created by Felipe Ruz on 5/23/19.
//  Copyright © 2019 Felipe Ruz. All rights reserved.
//

import XCTest
@testable import Mimic

class MimicTests: XCTestCase {
    
    override func tearDown() {
        Mimic.stopAllMimics()
        super.tearDown()
    }
    
    func testGetRequest() {
        let url = "http://localhost/get"
        Mimic.mimic(
            request: request(with: .get, url: url),
            response: response(with: ["message": "testGetRequest"])
        )
        
        let exp = expectation(description: "testGetRequest")
        
        makeRequest(url: url, method: .get, headers: nil) { (data, response, error) in
            exp.fulfill()
            XCTAssertNil(error)
            XCTAssertEqual(response?.url?.absoluteString, url)
            
            let headers = (response as? HTTPURLResponse)?.allHeaderFields
            XCTAssertEqual(headers?.count, 1)
            XCTAssertEqual(
                headers?["Content-Type"] as? String,
                "application/json; charset=utf-8"
            )
            guard
                let data = data,
                let json = try? JSONSerialization.jsonObject(with: data, options: [.allowFragments]),
            let jsonDict = json as? [String: String]
                else {
                    XCTFail("Failed to create JSON from data")
                    return
            }
            XCTAssertEqual(jsonDict["message"], "testGetRequest")
        }
        
        wait(for: [exp], timeout: 5)
    }
    
    func testPostRequest() {
        let url = "http://localhost/post"
        Mimic.mimic(
            request: request(with: .post, url: url),
            response: response(with: ["message": "testPostRequest"])
        )
        
        let exp = expectation(description: "testPostRequest")
        
        makeRequest(
        url: url,
        method: .post,
        headers: nil
        ) { (data, response, error) in
            exp.fulfill()
            XCTAssertNil(error)
            XCTAssertEqual(response?.url?.absoluteString, url)
            
            let headers = (response as? HTTPURLResponse)?.allHeaderFields
            XCTAssertEqual(headers?.count, 1)
            XCTAssertEqual(
                headers?["Content-Type"] as? String,
                "application/json; charset=utf-8"
            )
            
            guard
                let data = data,
                let json = try? JSONSerialization.jsonObject(with: data, options: [.allowFragments]),
                let jsonDict = json as? [String: String]
                else {
                    XCTFail("Failed to create JSON from data")
                    return
            }
            XCTAssertEqual(jsonDict["message"], "testPostRequest")
        }
        
        wait(for: [exp], timeout: 5)
    }
    
    func testDeleteRequest() {
        let url = "http://localhost/delete"
        Mimic.mimic(
            request: request(with: .delete, url: url),
            response: response(with: ["message": "testDeleteRequest"])
        )
        
        let exp = expectation(description: "testDeleteRequest")
        
        makeRequest(
            url: url,
            method: .delete,
            headers: nil
        ) { (data, response, error) in
            exp.fulfill()
            XCTAssertNil(error)
            XCTAssertEqual(response?.url?.absoluteString, url)
            
            let headers = (response as? HTTPURLResponse)?.allHeaderFields
            XCTAssertEqual(headers?.count, 1)
            XCTAssertEqual(
                headers?["Content-Type"] as? String,
                "application/json; charset=utf-8"
            )
            
            guard
                let data = data,
                let json = try? JSONSerialization.jsonObject(with: data, options: [.allowFragments]),
                let jsonDict = json as? [String: String]
                else {
                    XCTFail("Failed to create JSON from data")
                    return
            }
            XCTAssertEqual(jsonDict["message"], "testDeleteRequest")
        }
        
        wait(for: [exp], timeout: 5)
    }
    
    func testPutRequest() {
        let url = "http://localhost/put"
        Mimic.mimic(
            request: request(with: .put, url: url),
            response: response(with: ["message": "testPutRequest"])
        )
        
        let exp = expectation(description: "testPutRequest")
        
        makeRequest(
            url: url,
            method: .put,
            headers: nil
        ) { (data, response, error) in
            exp.fulfill()
            XCTAssertNil(error)
            XCTAssertEqual(response?.url?.absoluteString, url)
            
            let headers = (response as? HTTPURLResponse)?.allHeaderFields
            XCTAssertEqual(headers?.count, 1)
            XCTAssertEqual(
                headers?["Content-Type"] as? String,
                "application/json; charset=utf-8"
            )
            
            guard
                let data = data,
                let json = try? JSONSerialization.jsonObject(with: data, options: [.allowFragments]),
                let jsonDict = json as? [String: String]
                else {
                    XCTFail("Failed to create JSON from data")
                    return
            }
            XCTAssertEqual(jsonDict["message"], "testPutRequest")
        }
        
        wait(for: [exp], timeout: 5)
    }
    
    private func makeRequest(
        url: String,
        method: MimicHTTPMethod,
        headers: [String: String]?,
        completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void
        ) {
        guard let url = URL(string: url) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = method.description
        request.allHTTPHeaderFields = headers
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            completionHandler(data, response, error)
        }
        task.resume()
    }
}
