//
//  MimicURL.swift
//  Mimic
//
//  Created by Felipe Ruz on 5/23/19.
//  Copyright © 2019 Felipe Ruz. All rights reserved.
//

extension URLSessionConfiguration {
    public class func swizzleURLSessionConfiguration() {
        guard
            let defaultURLSessionConfiguration = class_getClassMethod(
                URLSessionConfiguration.self,
                #selector(getter: URLSessionConfiguration.default)
            ),
            let mimicdefaultURLSessionConfiguration = class_getClassMethod(
                URLSessionConfiguration.self,
                #selector(URLSessionConfiguration.mimicDefaultSessionConfiguration)
            ) else {
            fatalError("Failed to exchange URLSessionConfiguration.default")
        }
        method_exchangeImplementations(
            defaultURLSessionConfiguration,
            mimicdefaultURLSessionConfiguration
        )

        guard
            let ephemeralSessionConfiguration = class_getClassMethod(
                URLSessionConfiguration.self,
                #selector(getter: URLSessionConfiguration.ephemeral)
            ),
            let mimicEphemeralSessionConfiguration = class_getClassMethod(
                URLSessionConfiguration.self,
                #selector(URLSessionConfiguration.mimicEphemeralSessionConfiguration)
            ) else {
            fatalError("Failed to exchange URLSessionConfiguration.ephemeral")
        }
        method_exchangeImplementations(
            ephemeralSessionConfiguration,
            mimicEphemeralSessionConfiguration
        )
    }

    @objc
    class func mimicDefaultSessionConfiguration() -> URLSessionConfiguration {
        let configuration = mimicDefaultSessionConfiguration()
        configuration.protocolClasses = [MimicProtocol.self] as [AnyClass] + configuration.protocolClasses!
        return configuration
    }

    @objc
    class func mimicEphemeralSessionConfiguration() -> URLSessionConfiguration {
        let configuration = mimicEphemeralSessionConfiguration()
        configuration.protocolClasses = [MimicProtocol.self] as [AnyClass] + configuration.protocolClasses!
        return configuration
    }
}
