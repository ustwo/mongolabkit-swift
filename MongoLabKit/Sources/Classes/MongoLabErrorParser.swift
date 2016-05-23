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


    func errorFromData(data: NSData?, statusCode: Int) throws -> MongoLabError {
        guard let data = data, jsonObject = try? NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers) as? [String: AnyObject] else {
            throw MongoLabError.ServerError(statusCode: statusCode, message: nil)
        }

        guard let message = jsonObject![Keys.message] as? String else {
            throw MongoLabError.ServerError(statusCode: statusCode, message: nil)
        }

        return MongoLabError.ServerError(statusCode: statusCode, message: message)
    }

}

