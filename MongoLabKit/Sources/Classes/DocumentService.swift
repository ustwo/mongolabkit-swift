//
//  DocumentService.swift
//  MongoLabKit
//
//  Created by luca strazzullo on 17/01/2017.
//
//

import Foundation

class DocumentService: MongoLabService<Document> {

    // MARK: Public APIs

    public func addDocument(_ document: Document, inCollection collection: Collection) {
        delegate?.serviceWillLoad(self)

        do {
            let request = try MongoLabURLRequest.urlRequestWith(configuration, relativeURL: "collections/\(collection)", method: .POST, parameters: [], bodyData: document.payload as AnyObject?)

            perform(request: request, with: DocumentParser.parse)

        } catch let error {
            delegate?.service(self, didFailWith: error as? ErrorDescribable ?? MongoLabError.requestError)
        }
    }
    
}
