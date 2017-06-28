//
//  CollectionsService.swift
//  MongoLabKit
//
//  Created by luca strazzullo on 20/05/16.
//
//

import Foundation

class CollectionsService: MongoLabService<Collections> {

    // MARK: Public APIs

    public func loadCollections() {
        delegate?.serviceWillLoad(self)

        do {
            let request = try MongoLabURLRequest.urlRequestWith(configuration, relativeURL: "collections", method: .GET, parameters: [], bodyData: nil)

            perform(request: request, with: CollectionParser.parse)

        } catch let error {
            delegate?.service(self, didFailWith: error as? ErrorDescribable ?? MongoLabError.requestError)
        }
    }

}
