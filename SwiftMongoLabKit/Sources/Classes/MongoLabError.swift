//
//  MongoLabError.swift
//  SwiftMongoLabApiClient
//
//  Created by luca strazzullo on 12/03/16.
//  Copyright © 2016 ustwo. All rights reserved.
//

import Foundation

public enum MongoLabError: ErrorDescribable {
    case ConnectionError
    case RequestError
    case ParserError
    case ServerError(statusCode: Int, message: String?)


    public func description() -> String {
        switch self {
        case .ConnectionError:
            return "Unable to connect to server."
        case .RequestError:
            return "Unable to create a request to the database. baseURL and apiKey MUST be not empty in the configuration."
        case .ParserError:
            return "Something went wrong. Please try again."
        case let .ServerError(statusCode, message):
            return "Server error - status code: \(statusCode), message: \(message)"
        }
    }
}