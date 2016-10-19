//
//  FileCollectionParser.swift
//  MongoLabKit
//
//  Created by luca strazzullo on 20/05/16.
//
//

import Foundation

class CollectionParser {

    func parse(_ JSON: AnyObject?) throws -> Collections {
        guard let items = JSON as? [String] else {
            throw MongoLabError.parserError
        }

        return items
    }
    
}

