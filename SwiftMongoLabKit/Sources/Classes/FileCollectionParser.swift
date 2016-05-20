//
//  FileCollectionParser.swift
//  SwiftMongoLabKit
//
//  Created by luca strazzullo on 20/05/16.
//
//

import Foundation

class CollectionParser {

    func parseJSON(JSON: AnyObject?) throws -> Collections {
        guard let items = JSON as? [String] else {
            throw MongoLabError.ParserError
        }

        return items
    }
    
}

