//
//  DocumentParser.swift
//  MongoLabKit
//
//  Created by luca strazzullo on 24/05/16.
//
//

import Foundation

struct DocumentParser {

    private struct Keys {
        static let id = "_id"
        static let oid = "$oid"
    }


    static func parse(_ JSON: Any?) throws -> Document {
        guard let data = JSON as? [String: AnyObject] else {
            throw MongoLabError.parserError
        }

        let id = try parse(id: data as AnyObject)

        return Document(id: id, payload: data)
    }


    private static func parse(id JSON: AnyObject) throws -> String {
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

