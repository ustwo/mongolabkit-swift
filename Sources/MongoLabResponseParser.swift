//
//  MongoLabResponseParser.swift
//  SwiftMongoLabApiClient
//
//  Created by luca strazzullo on 12/03/16.
//  Copyright © 2016 ustwo. All rights reserved.
//

import Foundation

class MongoLabResponseParser {

    func parseData(data: NSData?, response: NSURLResponse?, error: NSError?) throws -> AnyObject {
        if error != nil {
            throw MongoLabError.ConnectionError
        }

        guard let httpResponse = response as? NSHTTPURLResponse else {
            throw MongoLabError.ConnectionError
        }

        if httpResponse.statusCode != 200 && httpResponse.statusCode != 201 {
            throw try MongoLabErrorParser().errorFromData(data, statusCode: httpResponse.statusCode)
        }

        guard let data = data else {
            throw MongoLabError.ParserError
        }

        guard let jsonObject = try? NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers) else {
            throw MongoLabError.ParserError
        }

        return jsonObject
    }
    
}