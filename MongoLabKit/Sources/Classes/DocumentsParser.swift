//
//  DocumentParser.swift
//  MongoLabKit
//
//  Created by luca strazzullo on 24/05/16.
//
//

import Foundation

class DocumentsParser {

    func parseJSON(JSON: AnyObject?) throws -> Documents {
        guard let items = JSON as? [AnyObject] else {
            throw MongoLabError.ParserError
        }

        return try items.map(DocumentParser().parseJSON)
    }
    
}

