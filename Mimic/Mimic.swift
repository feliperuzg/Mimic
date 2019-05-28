//
//  Mimic.swift
//  Mimic
//
//  Created by Felipe Ruz on 5/23/19.
//  Copyright © 2019 Felipe Ruz. All rights reserved.
//

public typealias MimicRequest = (URLRequest) -> Bool
public typealias MimicResponse = (URLRequest) -> MimicResponseType

public final class Mimic {
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
}

public func request(with method: MimicHTTPMethod, url: String) -> (_ request: URLRequest) -> Bool {
    return { (request: URLRequest) in
        guard
            let requestMethod = request.httpMethod,
            requestMethod == method.description,
            let requestUrl = request.url?.absoluteString,
            requestUrl == url
        else {
            return false
        }
        return true
    }
}

public func response(
    with json: Any,
    status: Int = 200,
    headers: [String: String]? = nil
) -> (_ request: URLRequest) -> MimicResponseType {
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
            if
                let url = request.url,
                let response = HTTPURLResponse(
                    url: url,
                    statusCode: status,
                    httpVersion: nil,
                    headerFields: headers
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
