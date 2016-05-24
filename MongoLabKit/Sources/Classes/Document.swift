//
//  Document.swift
//  MongoLabKit
//
//  Created by luca strazzullo on 24/05/16.
//
//

import Foundation

typealias Documents = [Document]


public struct Document {

    var id: String

    var payload: [String: AnyObject]

}

