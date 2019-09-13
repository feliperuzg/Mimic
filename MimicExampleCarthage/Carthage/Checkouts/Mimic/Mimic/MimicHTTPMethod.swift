//
//  MimicHTTPMethod.swift
//  Mimic
//
//  Created by Felipe Ruz on 5/23/19.
//  Copyright © 2019 Felipe Ruz. All rights reserved.
//

public enum MimicHTTPMethod: CustomStringConvertible {
    case get
    case post
    case put
    case delete

    public var description: String {
        switch self {
        case .get:
            return "GET"
        case .post:
            return "POST"
        case .put:
            return "PUT"
        case .delete:
            return "DELETE"
        }
    }
}
