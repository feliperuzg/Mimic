//
//  Mimic.swift
//  Mimic
//
//  Created by Felipe Ruz on 5/23/19.
//  Copyright © 2019 Felipe Ruz. All rights reserved.
//

import Foundation

public final class Mimic {
}

public typealias Request = (URLRequest) -> (Bool)
public typealias Response = (URLRequest) -> (ResponseType)

public enum ResponseType : Equatable {
    case success(URLResponse, Content)
    case failure(NSError)
}

public enum Content: ExpressibleByNilLiteral, Equatable {
    public init(nilLiteral: ()) {
        self = .empty
    }
    case content(Data)
    case empty
}


public func request(with method: MimicHTTPMethod, url: String) -> (_ request: URLRequest) -> Bool {
    return { (request: URLRequest) in
        guard
            let requestMethod = request.httpMethod,
            requestMethod == method.description
            else {
            return false
        }
        return true
    }
}

public func response(
    with json: Any,
    status: Int = 200,
    headers: [String:String]? = nil
    ) -> (_ request: URLRequest) -> ResponseType {
    return { (request: URLRequest) in
        do {
            let data = try JSONSerialization.data(
                withJSONObject: json,
                options: JSONSerialization.WritingOptions()
            )
            var headers = [String: String]()
            if headers["Content-Type"] == nil {
                headers["Content-Type"] = "application/json; charset=utf-8"
            }
            if let response = HTTPURLResponse(
                url: request.url!,
                statusCode: status,
                httpVersion: nil,
                headerFields: headers
                ) {
                return ResponseType.success(response, .content(data))
            } else {
                return ResponseType.failure(NSError(
                    domain: NSExceptionName.internalInconsistencyException.rawValue,
                    code: 0,
                    userInfo: [NSLocalizedDescriptionKey: "Failed to construct response for stub."]
                    ))
            }
        } catch {
            return ResponseType.failure(error as NSError)
        }
    }
}


