//
//  MongoLabResponseParser.swift
//  MongoLabKit
//
//  Created by luca strazzullo on 12/03/16.
//  Copyright © 2016 ustwo. All rights reserved.
//

import Foundation

class MongoLabResponseParser {

    func parse(_ data: Data?, response: URLResponse?, error: Error?) throws -> AnyObject {
        if error != nil {
            throw MongoLabError.connectionError
        }

        guard let httpResponse = response as? HTTPURLResponse else {
            throw MongoLabError.connectionError
        }

        if httpResponse.statusCode != 200 && httpResponse.statusCode != 201 {
            throw try MongoLabErrorParser().errorFrom(data, statusCode: httpResponse.statusCode)
        }

        guard let data = data else {
            throw MongoLabError.parserError
        }

        guard let jsonObject = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) else {
            throw MongoLabError.parserError
        }

        return jsonObject as AnyObject
    }
    
}
