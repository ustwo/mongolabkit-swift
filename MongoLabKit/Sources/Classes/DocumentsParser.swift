//
//  DocumentParser.swift
//  MongoLabKit
//
//  Created by luca strazzullo on 24/05/16.
//
//

import Foundation

class DocumentsParser {

    func parse(_ JSON: AnyObject?) throws -> Documents {
        guard let items = JSON as? [AnyObject] else {
            throw MongoLabError.parserError
        }

        return try items.map(DocumentParser().parse)
    }
    
}

