//
//  MimicURL.swift
//  Mimic
//
//  Created by Felipe Ruz on 5/23/19.
//  Copyright © 2019 Felipe Ruz. All rights reserved.
//

import Foundation

extension URLSessionConfiguration {
    private static var swizzled = false

    class func activateMimic() {
        swizzleURLSessionConfiguration(to: true)
    }

    class func deactivateMimic() {
        swizzleURLSessionConfiguration(to: false)
    }

    private class func swizzleURLSessionConfiguration(to mimic: Bool) {
        guard mimic != swizzled else { return }
        let defaultSelector = #selector(getter: `default`)
        let defaultMimicSelector = #selector(mimicDefaultSessionConfiguration)
        let ephemeralSelector = #selector(getter: ephemeral)
        let ephemeralMimicSelector = #selector(mimicEphemeralSessionConfiguration)

        if mimic {
            URLSessionConfiguration.exchange(defaultSelector, with: defaultMimicSelector)
            URLSessionConfiguration.exchange(ephemeralSelector, with: ephemeralMimicSelector)
        } else {
            URLSessionConfiguration.exchange(defaultMimicSelector, with: defaultSelector)
            URLSessionConfiguration.exchange(ephemeralMimicSelector, with: ephemeralSelector)
        }
        swizzled = mimic
    }

    private func registerClass(_ protocolClass: Swift.AnyClass) {
        guard let protocols = self.protocolClasses else {
            fatalError("Failed to retrieve current protocol classes for \(protocolClass)")
        }
        protocolClasses = [protocolClass] + protocols
    }

    @objc
    private class func mimicDefaultSessionConfiguration() -> URLSessionConfiguration {
        let configuration = mimicDefaultSessionConfiguration()
        configuration.registerClass(MimicProtocol.self)
        return configuration
    }

    @objc
    private class func mimicEphemeralSessionConfiguration() -> URLSessionConfiguration {
        let configuration = mimicEphemeralSessionConfiguration()
        configuration.registerClass(MimicProtocol.self)
        return configuration
    }

    private class func exchange(_ selector: Selector, with replacementSelector: Selector) {
        guard
            let method = class_getClassMethod(self, selector),
            let replacementMethod = class_getClassMethod(self, replacementSelector)
        else {
            fatalError(
                """
                Failed to retrieve method \(selector.description)
                and/or \(replacementSelector.description)
                """
            )
        }
        method_exchangeImplementations(method, replacementMethod)
    }
}
