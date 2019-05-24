//
//  ResponseType.swift
//  Mimic
//
//  Created by Felipe Ruz on 5/24/19.
//  Copyright © 2019 Felipe Ruz. All rights reserved.
//

public enum MimicResponseType : Equatable {
    case success(URLResponse, MimicContent)
    case failure(NSError)
    
    public static func == (lhs: MimicResponseType, rhs: MimicResponseType) -> Bool {
        switch (lhs, rhs) {
        case let (.failure(lhsError), .failure(rhsError)):
            return lhsError == rhsError
        case let (.success(lhsResponse, lhsContent), .success(rhsResponse, rhsContent)):
            return lhsResponse == rhsResponse && lhsContent == rhsContent
        default:
            return false
        }
    }
}
