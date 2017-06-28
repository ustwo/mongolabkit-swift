//
//  RequestError.swift
//  MongoLabKit
//
//  Created by luca strazzullo on 28/06/2017.
//
//

import Foundation

public enum RequestError: ErrorDescribable {

    case configuration


    public func description() -> String {
        switch self {
        case .configuration:
            return "Configuration parameters MUST not be empty."
        }
    }
}
