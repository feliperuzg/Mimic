//
//  ResponseType.swift
//  Mimic
//
//  Created by Felipe Ruz on 5/24/19.
//  Copyright © 2019 Felipe Ruz. All rights reserved.
//

public enum MimicResponseType: Equatable {
    case success(URLResponse, MimicContent)
    case failure(NSError)
}
