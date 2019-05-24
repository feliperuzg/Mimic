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
    
    class func mimic(_ mimic: MimicObject) -> MimicObject {
        mimics.append(mimic)
        URLProtocol.registerClass(MimicProtocol.self)
        return mimic
    }
    
    class func mimic(for request: URLRequest) -> MimicObject? {
        for mimic in mimics {
            if mimic.request(request) {
                return mimic
            }
        }
        return nil
    }
    
    open class func stopMimic(_ mimic: MimicObject) {
        if let index = mimics.index(of: mimic) {
            mimics.remove(at: index)
        }
    }
    
    open class func stopAllMimics() {
        mimics.removeAll()
    }
    
    
    open override class func canInit(with request: URLRequest) -> Bool {
        guard (mimic(for: request) != nil) else { return false }
        return true
    }
    
    override open class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override open func startLoading() {
        if let mimic = MimicProtocol.mimic(for: request) {
            DispatchQueue.global().asyncAfter(deadline: DispatchTime.now() + mimic.delay) {
                self.responseType(mimic.response(self.request))
            }
        } else {
            let error = NSError(
                domain: NSExceptionName.internalInconsistencyException.rawValue,
                code: 0,
                userInfo: [NSLocalizedDescriptionKey: "Handling request without a matching stub."]
            )
            client?.urlProtocol(self, didFailWithError: error)
        }
    }
    
    override open func stopLoading() {
//        self.enableDownloading = false
//        self.operationQueue.cancelAllOperations()
    }
    
    public func responseType(_ responseType: ResponseType) {
        switch responseType {
        case .success(let response, let content):
            switch content {
                case .content(let data):
                    client?.urlProtocol(self, didLoad: data)
                case .empty:
                    client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            }
            client?.urlProtocolDidFinishLoading(self)
        case .failure(let error):
            client?.urlProtocol(self, didFailWithError: error)
        }
    }
}
