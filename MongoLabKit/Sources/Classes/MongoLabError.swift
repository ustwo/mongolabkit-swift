//
//  MongoLabError.swift
//  MongoLabKit
//
//  Created by luca strazzullo on 12/03/16.
//  Copyright © 2016 ustwo. All rights reserved.
//

import Foundation

public enum MongoLabError: ErrorDescribable {
    case generic
    case connectionError
    case requestError
    case parserError
    case serverError(statusCode: Int, message: String?)


    public func description() -> String {
        switch self {
        case .generic:
            return "Generic error."
        case .connectionError:
            return "Unable to connect to server."
        case .requestError:
            return "Unable to create a request to the database."
        case .parserError:
            return "Something went wrong. Please try again."
        case let .serverError(statusCode, message):
            return "Server error - status code: \(statusCode), message: \(String(describing: message))"
        }
    }
}
