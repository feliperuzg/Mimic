//
//  MimicObject.swift
//  Mimic
//
//  Created by Felipe Ruz on 5/23/19.
//  Copyright © 2019 Felipe Ruz. All rights reserved.
//

import Foundation

public struct MimicObject: Equatable {
    let request: MimicRequest
    let delay: TimeInterval
    let response: MimicResponse
    let uuid: UUID

    init(
        request: @escaping MimicRequest,
        delay: TimeInterval = 0,
        response: @escaping MimicResponse
    ) {
        self.request = request
        self.delay = delay
        self.response = response
        uuid = UUID()
    }

    public static func == (lhs: MimicObject, rhs: MimicObject) -> Bool {
        return lhs.uuid == rhs.uuid
    }
}
