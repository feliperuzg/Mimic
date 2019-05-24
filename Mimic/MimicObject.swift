//
//  MimicStub.swift
//  Mimic
//
//  Created by Felipe Ruz on 5/23/19.
//  Copyright © 2019 Felipe Ruz. All rights reserved.
//

import Foundation

public struct MimicObject: Equatable {
    let request: Request
    let status: Int
    let delay: TimeInterval
    let response: Response
    let uuid: UUID
    
    init(
        request: @escaping Request,
        status: Int,
        delay: TimeInterval = 0,
        response: @escaping Response
        ) {
        self.request = request
        self.status = status
        self.delay = delay
        self.response = response
        uuid = UUID()
    }
    
    public static func == (lhs: MimicObject, rhs: MimicObject) -> Bool {
        return lhs.uuid == rhs.uuid
    }
}
