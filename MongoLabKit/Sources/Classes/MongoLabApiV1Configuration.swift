//
//  MongoLabApiV1Configuration.swift
//  MongoLabKit
//
//  Created by luca strazzullo on 17/05/16.
//  Copyright © 2016 ustwo. All rights reserved.
//

import Foundation

public struct MongoLabApiV1Configuration: Configuration {

    let baseURL: String
    let databaseName: String
    let apiKey: String


    init(databaseName: String, apiKey: String) {
        self.baseURL = "https://api.mongolab.com/api/1/databases"
        self.databaseName = databaseName
        self.apiKey = apiKey
    }
}
