//
//  DocumentsService.swift
//  MongoLabKit
//
//  Created by luca strazzullo on 24/05/16.
//
//

import Foundation

class DocumentsService: MongoLabService<Documents> {

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
