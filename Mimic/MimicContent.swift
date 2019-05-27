//
//  MimicContent.swift
//  Mimic
//
//  Created by Felipe Ruz on 5/24/19.
//  Copyright © 2019 Felipe Ruz. All rights reserved.
//

public enum MimicContent: ExpressibleByNilLiteral, Equatable {
    public init(nilLiteral _: ()) {
        self = .empty
    }

    case content(Data)
    case empty
}
