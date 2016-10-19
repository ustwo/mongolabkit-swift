//
//  DocumentParser.swift
//  MongoLabKit
//
//  Created by luca strazzullo on 24/05/16.
//
//

import Foundation

class DocumentParser {

    fileprivate struct Keys {
        static let id = "_id"
        static let oid = "$oid"
    }


    func parse(_ JSON: AnyObject?) throws -> Document {
        guard let data = JSON as? [String: AnyObject] else {
            throw MongoLabError.parserError
        }

        let id = try parse(id: data as AnyObject)

        return Document(id: id, payload: data)
    }


    fileprivate func parse(id JSON: AnyObject) throws -> String {
        guard let data = JSON as? [String: AnyObject] else {
            throw MongoLabError.parserError
        }

        guard let id = data[Keys.id] as? [String: AnyObject] else {
            throw MongoLabError.parserError
        }

        guard let oid = id[Keys.oid] as? String else {
            throw MongoLabError.parserError
        }

        return oid
    }

}

