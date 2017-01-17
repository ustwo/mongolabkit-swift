//
//  DocumentsService.swift
//  MongoLabKit
//
//  Created by luca strazzullo on 24/05/16.
//
//

import Foundation

class DocumentsService: Service<Documents> {

    // MARK: Instance properties

    private var configuration: MongoLabConfiguration


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


    // MARK: Public APIs

    public func loadDocuments(for collection: Collection) {
        delegate?.serviceWillLoad(self)

        do {
            let request = try MongoLabURLRequest.urlRequestWith(configuration, relativeURL: "collections/\(collection)", method: .GET, parameters: [], bodyData: nil)

            perform(request: request, with: DocumentsParser.parse)

        } catch let error {
            delegate?.service(self, didFailWith: error as? ErrorDescribable ?? MongoLabError.requestError)
        }
    }

}
