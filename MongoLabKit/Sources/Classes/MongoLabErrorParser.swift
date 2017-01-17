//
//  MongoLabErrorParser.swift
//  MongoLabKit
//
//  Created by luca strazzullo on 12/03/16.
//  Copyright © 2016 ustwo. All rights reserved.
//

import Foundation

class MongoLabErrorParser {

    private struct Keys {
        static let message = "message"
    }


    func errorFrom(_ data: Data?, statusCode: Int) throws -> MongoLabError {
        guard let data = data, let jsonObject = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String: AnyObject] else {
            throw MongoLabError.serverError(statusCode: statusCode, message: nil)
        }

        guard let message = jsonObject![Keys.message] as? String else {
            throw MongoLabError.serverError(statusCode: statusCode, message: nil)
        }

        return MongoLabError.serverError(statusCode: statusCode, message: message)
    }

}

