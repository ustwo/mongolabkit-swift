//
//  FileCollectionParser.swift
//  MongoLabKit
//
//  Created by luca strazzullo on 20/05/16.
//
//

import Foundation

struct CollectionParser {

    static func parse(_ JSON: Any?) throws -> Collections {
        guard let items = JSON as? [String] else {
            throw MongoLabError.parserError
        }

        return items
    }
    
}

