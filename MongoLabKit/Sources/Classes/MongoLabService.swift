//
//  MongoLabService.swift
//  MongoLabKit
//
//  Created by luca strazzullo on 23/02/2017.
//
//

import Foundation

class MongoLabService<DataType>: Service<DataType> {

    // MARK: Instance properties

    internal var configuration: MongoLabConfiguration


    // MARK: Object life cycle

    required init(client: MongoLabClient, configuration: MongoLabConfiguration, delegate: ServiceDelegate) {
        self.configuration = configuration
        super.init(client: client)

        self.delegate = delegate
    }


    required init(configuration: MongoLabConfiguration, delegate: ServiceDelegate) {
        self.configuration = configuration
        super.init(client: MongoLabClient())

        self.delegate = delegate
    }

}
