//
//  CollectionService.swift
//  MongoLabKit
//
//  Created by luca strazzullo on 20/05/16.
//
//

import Foundation

protocol CollectionServiceDelegate: AnyObject {
    func collectionServiceWillLoadCollection(_ service: CollectionService?)
    func collectionService(_ service: CollectionService?, didLoadCollections collections: Collections)
    func collectionService(_ service: CollectionService?, didFailWithError error: ErrorDescribable)
}


class CollectionService {

    fileprivate let client: MongoLabClient

    fileprivate var configuration: MongoLabConfiguration

    weak var delegate: CollectionServiceDelegate?


    required init(client: MongoLabClient, configuration: MongoLabConfiguration, delegate: CollectionServiceDelegate) {
        self.client = client
        self.configuration = configuration
        self.delegate = delegate
    }


    required init(configuration: MongoLabConfiguration, delegate: CollectionServiceDelegate) {
        self.client = MongoLabClient()
        self.configuration = configuration
        self.delegate = delegate
    }

}


extension CollectionService {

    func loadCollections() {
        defer {
            delegate?.collectionServiceWillLoadCollection(self)
        }

        do {
            let request = try MongoLabURLRequest.urlRequestWith(configuration, relativeURL: "collections", method: .GET, parameters: [], bodyData: nil)

            client.perform(request) {
                [weak self] result in

                switch result {
                case let .success(response):
                    self?.parse(collectionsLoaded: response)

                case let .failure(error):
                    self?.serviceError(error)
                }
            }
        } catch let error {

            serviceError(error as? ErrorDescribable ?? MongoLabError.requestError)
        }
    }
    
}


extension CollectionService {

    fileprivate func parse(collectionsLoaded response: AnyObject) {
        DispatchQueue.global().async {
            [weak self] in

            do {
                let collections = try CollectionParser().parse(response)

                self?.collectionsLoaded(collections)

            } catch let error as ErrorDescribable {
                self?.serviceError(error)
            } catch {
                self?.serviceError(MongoLabError.parserError)
            }
        }
    }


    fileprivate func collectionsLoaded(_ collections: Collections) {
        DispatchQueue.main.async {
            [weak self] in
            self?.delegate?.collectionService(self, didLoadCollections: collections)
        }
    }
    
    
    fileprivate func serviceError(_ error: ErrorDescribable) {
        DispatchQueue.main.async {
            [weak self] in
            self?.delegate?.collectionService(self, didFailWithError: error)
        }
    }
    
}

