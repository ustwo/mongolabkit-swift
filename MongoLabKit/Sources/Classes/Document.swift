//
//  Document.swift
//  MongoLabKit
//
//  Created by luca strazzullo on 24/05/16.
//
//

import Foundation

public struct Document {

    var id: String?

    var payload: [String: AnyObject]


    init(id: String, payload: [String: AnyObject]) {
        self.id = id
        self.payload = payload
    }


    init(payload: [String: AnyObject]) {
        self.payload = payload
    }

}
