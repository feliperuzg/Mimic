//
//  Mimic.swift
//  Mimic
//
//  Created by Felipe Ruz on 5/23/19.
//  Copyright © 2019 Felipe Ruz. All rights reserved.
//

import Foundation

public typealias MimicRequest = (URLRequest) -> Bool
public typealias MimicResponse = (URLRequest) -> MimicResponseType

public final class Mimic {
    public static var randomizeMimics = false

    @discardableResult
    public class func mimic(
        request: @escaping MimicRequest,
        delay: TimeInterval = 0,
        response: @escaping MimicResponse
    ) -> MimicObject {
        return MimicProtocol.mimic(
            MimicObject(
                request: request,
                delay: delay,
                response: response
            )
        )
    }

    public class func stopMimic(_ mimic: MimicObject) {
        MimicProtocol.stopMimic(mimic)
    }

    public class func stopAllMimics() {
        MimicProtocol.stopAllMimics()
    }

    // It's called by default when adding a new mimic Object
    // Call it only when neccessary
    public class func start() {
        URLSessionConfiguration.activateMimic()
    }
}

public func request(with method: MimicHTTPMethod, url: String, wildCard: Bool = false) -> (_ request: URLRequest) -> Bool {
    return { (request: URLRequest) in
        guard
            let requestMethod = request.httpMethod,
            requestMethod == method.description,
            let requestUrl = request.url?.absoluteString
        else {
            return false
        }
        if wildCard {
            return compare(wildCardUrl: url, with: requestUrl)
        } else {
            return url == requestUrl
        }
    }
}

private func compare(wildCardUrl: String, with url: String) -> Bool {
    guard
        let wildUrlComponents = URLComponents(string: wildCardUrl),
        let urlComponents = URLComponents(string: url),
        wildUrlComponents.host == urlComponents.host,
        wildUrlComponents.scheme == urlComponents.scheme
    else {
        return false
    }
    let validPath = compare(wildPath: wildUrlComponents.path, with: urlComponents.path)
    let validQuery = compare(wildQuery: wildUrlComponents.queryItems, with: urlComponents.queryItems)
    return validPath && validQuery
}

private func compare(wildPath: String, with path: String) -> Bool {
    if wildPath != path, !wildPath.contains("@wild") { return false }
    let wildPaths = wildPath.components(separatedBy: "/")
    let paths = path.components(separatedBy: "/")
    if wildPaths.count != paths.count { return false }
    for (wildPathItem, pathItem)
        in zip(wildPaths, paths)
        where wildPathItem != pathItem && wildPathItem != "@wild" {
        return false
    }
    return true
}

private func compare(wildQuery: [URLQueryItem]?, with query: [URLQueryItem]?) -> Bool {
    if wildQuery == nil, query == nil { return true }
    guard
        let wildQuery = wildQuery,
        let query = query,
        wildQuery.count == query.count
    else {
        return false
    }

    for (wildItem, item) in zip(wildQuery, query) {
        if wildItem.name != item.name {
            return false
        }
        if wildItem.value != item.value, wildItem.value != "@wild" {
            return false
        }
    }
    return true
}

public func response(
    with json: Any,
    status: Int = 200,
    headers: [String: String] = [:]
) -> (_ request: URLRequest) -> MimicResponseType {
    return { (request: URLRequest) in
        do {
            let data = try JSONSerialization.data(
                withJSONObject: json,
                options: JSONSerialization.WritingOptions()
            )
            var responseHeaders = headers
            if responseHeaders["Content-Type"] == nil {
                responseHeaders["Content-Type"] = "application/json; charset=utf-8"
            }
            if
                let url = request.url,
                let response = HTTPURLResponse(
                    url: url,
                    statusCode: status,
                    httpVersion: nil,
                    headerFields: responseHeaders
                ) {
                return MimicResponseType.success(response, .content(data))
            } else {
                return MimicResponseType.failure(NSError(
                    domain: NSExceptionName.internalInconsistencyException.rawValue,
                    code: 0,
                    userInfo: [NSLocalizedDescriptionKey: "Failed to create MimicResponse"]
                ))
            }
        } catch {
            return MimicResponseType.failure(error as NSError)
        }
    }
}

public func rawResponse(
    with file: Any,
    status: Int = 200,
    headers: [String: String] = [:]
) -> (_ request: URLRequest) -> MimicResponseType {
    return { (request: URLRequest) in
        var responseHeaders = headers
        if responseHeaders["Content-Type"] == nil {
            responseHeaders["Content-Type"] = "application/json; charset=utf-8"
        }
        if
            let url = request.url,
            let response = HTTPURLResponse(
                url: url,
                statusCode: status,
                httpVersion: nil,
                headerFields: responseHeaders
            ),
            let data = file as? Data
        {
            return MimicResponseType.success(response, .content(data))
        } else {
            return MimicResponseType.failure(NSError(
                domain: NSExceptionName.internalInconsistencyException.rawValue,
                code: 0,
                userInfo: [NSLocalizedDescriptionKey: "Failed to create MimicResponse"]
            ))
        }
    }
}

