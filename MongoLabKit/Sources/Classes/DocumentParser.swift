//
//  DocumentParser.swift
//  MongoLabKit
//
//  Created by luca strazzullo on 24/05/16.
//
//

import Foundation

class DocumentParser {

    private struct Keys {
        static let id = "_id"
        static let oid = "$oid"
    }


    func parseJSON(JSON: AnyObject?) throws -> Document {
        guard let data = JSON as? [String: AnyObject] else {
            throw MongoLabError.ParserError
        }

        let id = try parseId(data)

        return Document(id: id, payload: data)
    }


    private func parseId(JSON: AnyObject) throws -> String {
        guard let data = JSON as? [String: AnyObject] else {
            throw MongoLabError.ParserError
        }

        guard let id = data[Keys.id] as? [String: AnyObject] else {
            throw MongoLabError.ParserError
        }

        guard let oid = id[Keys.oid] as? String else {
            throw MongoLabError.ParserError
        }

        return oid
    }

}

