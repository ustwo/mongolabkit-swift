//
//  Configuration.swift
//  MongoLabKit
//
//  Created by luca strazzullo on 28/06/2017.
//
//

import Foundation

protocol Configuration {
    var baseURL: String { get }
    var databaseName: String { get }
    var apiKey: String { get }
}


extension Configuration {

    func validate() throws {
        if baseURL.isEmpty || databaseName.isEmpty || apiKey.isEmpty {
            throw RequestError.configuration
        }
    }
}
