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
        guard let data = data, let httpResponse = response as? HTTPURLResponse, error == nil else {
            throw MongoLabError.connectionError
        }

        guard let jsonObject = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) else {
            throw MongoLabError.parserError
        }

        guard httpResponse.statusCode == 200 || httpResponse.statusCode == 201 else {
            throw try MongoLabErrorParser().errorFrom(data, statusCode: httpResponse.statusCode)
        }

        return jsonObject as AnyObject
    }
    
}
