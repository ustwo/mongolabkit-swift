//
//  CollectionService.swift
//  SwiftMongoLabKit
//
//  Created by luca strazzullo on 20/05/16.
//
//

import Foundation

protocol CollectionServiceDelegate: AnyObject {
    func collectionServiceWillLoadCollection(service: CollectionService?)
    func collectionService(service: CollectionService?, didLoadCollections collections: Collections)
    func collectionService(service: CollectionService?, didFailWithError error: ErrorDescribable)
}


class CollectionService {

    private var client: MongoLabClient

    weak var delegate: CollectionServiceDelegate?


    required init(client: MongoLabClient, delegate: CollectionServiceDelegate) {
        self.client = client
        self.delegate = delegate
    }

}


extension CollectionService {

    func loadCollectionsWithConfiguration(configuration: MongoLabConfiguration) {
        defer {
            delegate?.collectionServiceWillLoadCollection(self)
        }

        do {
            let request = try MongoLabURLRequest.URLRequestWithConfiguration(configuration, relativeURL: "collections", method: .GET, parameters: [], bodyData: nil)

            client.performRequest(request) {
                [weak self] result in

                switch result {
                case let .Success(response):
                    self?.parseCollectionsLoadedResponse(response)

                case let .Failure(error):
                    self?.serviceError(error)
                }
            }
        } catch let error {

            serviceError(error as? ErrorDescribable ?? MongoLabError.RequestError)
        }
    }

}


extension CollectionService {

    private func parseCollectionsLoadedResponse(response: AnyObject) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            [weak self] in

            do {
                let collections = try CollectionParser().parseJSON(response)

                self?.collectionsLoaded(collections)

            } catch let error as ErrorDescribable {
                self?.serviceError(error)
            } catch {
                self?.serviceError(MongoLabError.ParserError)
            }
        }
    }


    private func collectionsLoaded(collections: Collections) {
        dispatch_async(dispatch_get_main_queue()) {
            [weak self] in
            self?.delegate?.collectionService(self, didLoadCollections: collections)
        }
    }
    
    
    private func serviceError(error: ErrorDescribable) {
        dispatch_async(dispatch_get_main_queue()) {
            [weak self] in
            self?.delegate?.collectionService(self, didFailWithError: error)
        }
    }
    
}

