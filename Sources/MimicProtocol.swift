//
//  MimicProtocol.swift
//  Mimic
//
//  Created by Felipe Ruz on 5/23/19.
//  Copyright © 2019 Felipe Ruz. All rights reserved.
//

import Foundation

public class MimicProtocol: URLProtocol {
    static var mimics = [MimicObject]()
    static var registered = false

    class func mimic(_ mimic: MimicObject) -> MimicObject {
        mimics.append(mimic)
        if !registered {
            registered = URLProtocol.registerClass(MimicProtocol.self)
            URLSessionConfiguration.activateMimic()
        }
        return mimic
    }

    class func mimic(for request: URLRequest) -> MimicObject? {
        return mimics.last(where: { $0.request(request) } )
    }

    class func mimics(for request: URLRequest) -> [MimicObject] {
        return mimics.filter { $0.request(request) }
    }

    class func stopMimic(_ mimic: MimicObject) {
        if let index = mimics.lastIndex(of: mimic) {
            mimics.remove(at: index)
        }
    }

    class func stopAllMimics() {
        mimics.removeAll()
        URLProtocol.unregisterClass(MimicProtocol.self)
        URLSessionConfiguration.deactivateMimic()
        registered = false
    }

    public override class func canInit(with request: URLRequest) -> Bool {
        guard mimic(for: request) != nil else { return false }
        return true
    }

    public override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    public override func startLoading() {
        if let mimic = randomMimic(for: request) {
            DispatchQueue.global().asyncAfter(deadline: DispatchTime.now() + mimic.delay) {
                self.responseType(mimic.response(self.request))
            }
        } else {
            let error = NSError(
                domain: NSExceptionName.internalInconsistencyException.rawValue,
                code: 0,
                userInfo: [NSLocalizedDescriptionKey: "No Mimic for request"]
            )
            client?.urlProtocol(self, didFailWithError: error)
        }
    }

    public override func stopLoading() {}

    private func randomMimic(for request: URLRequest) -> MimicObject? {
        if Mimic.randomizeMimics {
            return MimicProtocol.mimics(for: request).randomElement()
        } else {
            return MimicProtocol.mimic(for: request)
        }
    }

    func responseType(_ responseType: MimicResponseType) {
        switch responseType {
        case let .success(response, content):
            switch content {
            case let .content(data):
                client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
                client?.urlProtocol(self, didLoad: data)
            case .empty:
                client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            }
            client?.urlProtocolDidFinishLoading(self)
        case let .failure(error):
            client?.urlProtocol(self, didFailWithError: error)
        }
    }
}
