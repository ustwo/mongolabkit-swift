//
//  DocumentParser.swift
//  MongoLabKit
//
//  Created by luca strazzullo on 24/05/16.
//
//

import Foundation

struct DocumentsParser {

    static func parse(_ JSON: Any?) throws -> Documents {
        guard let items = JSON as? [AnyObject] else {
            throw MongoLabError.parserError
        }

        return try items.map(DocumentParser.parse)
    }
    
}

