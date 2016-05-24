//
//  DocumentService.swift
//  MongoLabKit
//
//  Created by luca strazzullo on 24/05/16.
//
//

import Foundation

protocol DocumentServiceDelegate: AnyObject {
    func documentService(service: DocumentService?, willLoadDocumentsInCollection collection: Collection)
    func documentService(service: DocumentService?, didLoadDocuments documents: Documents, inCollection collection: Collection)

    func documentService(service: DocumentService?, willAddDocumentInCollection collection: Collection)
    func documentService(service: DocumentService?, didAddDocument document: Document, inCollection collection: Collection)

    func documentService(service: DocumentService?, didFailWithError error: ErrorDescribable)
}


class DocumentService {

    private let client: MongoLabClient

    private var configuration: MongoLabConfiguration

    weak var delegate: DocumentServiceDelegate?


    required init(client: MongoLabClient, configuration: MongoLabConfiguration, delegate: DocumentServiceDelegate) {
        self.client = client
        self.configuration = configuration
        self.delegate = delegate
    }


    required init(configuration: MongoLabConfiguration, delegate: DocumentServiceDelegate) {
        self.client = MongoLabClient()
        self.configuration = configuration
        self.delegate = delegate
    }

}


extension DocumentService {

    func loadDocumentsForCollection(collection: Collection) {
        defer {
            delegate?.documentService(self, willLoadDocumentsInCollection: collection)
        }

        do {
            let request = try MongoLabURLRequest.URLRequestWithConfiguration(configuration, relativeURL: "collections/\(collection)", method: .GET, parameters: [], bodyData: nil)

            client.performRequest(request) {
                [weak self] result in

                switch result {
                case let .Success(response):
                    self?.parseDocumentsLoadedResponse(response, inCollection: collection)

                case let .Failure(error):
                    self?.serviceError(error)
                }
            }
        } catch let error {

            serviceError(error as? ErrorDescribable ?? MongoLabError.RequestError)
        }
    }


    func addDocument(document: Document, inCollection collection: Collection) {
        defer {
            delegate?.documentService(self, willAddDocumentInCollection: collection)
        }

        do {
            let request = try MongoLabURLRequest.URLRequestWithConfiguration(configuration, relativeURL: "collections/\(collection)", method: .POST, parameters: [], bodyData: document.payload)

            client.performRequest(request) {
                [weak self] result in

                switch result {
                case let .Success(response):
                    self?.parseDocumentAddedResponse(response, inCollection: collection)

                case let .Failure(error):
                    self?.serviceError(error)
                }
            }
        } catch let error {

            serviceError(error as? ErrorDescribable ?? MongoLabError.RequestError)
        }
    }

}


extension DocumentService {

    private func serviceError(error: ErrorDescribable) {
        dispatch_async(dispatch_get_main_queue()) {
            [weak self] in
            self?.delegate?.documentService(self, didFailWithError: error)
        }
    }

}


extension DocumentService {

    private func parseDocumentsLoadedResponse(response: AnyObject, inCollection collection: Collection) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            [weak self] in

            do {
                let documents = try DocumentsParser().parseJSON(response)

                self?.documentsLoaded(documents, inCollection: collection)

            } catch let error as ErrorDescribable {
                self?.serviceError(error)
            } catch {
                self?.serviceError(MongoLabError.ParserError)
            }
        }
    }


    private func documentsLoaded(documents: Documents, inCollection collection: Collection) {
        dispatch_async(dispatch_get_main_queue()) {
            [weak self] in
            self?.delegate?.documentService(self, didLoadDocuments: documents, inCollection: collection)
        }
    }
    
}


extension DocumentService {

    private func parseDocumentAddedResponse(response: AnyObject, inCollection collection: Collection) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            [weak self] in

            do {
                let document = try DocumentParser().parseJSON(response)

                self?.documentAdded(document, inCollection: collection)

            } catch let error as ErrorDescribable {
                self?.serviceError(error)
            } catch {
                self?.serviceError(MongoLabError.ParserError)
            }
        }
    }


    private func documentAdded(document: Document, inCollection collection: Collection) {
        dispatch_async(dispatch_get_main_queue()) {
            [weak self] in
            self?.delegate?.documentService(self, didAddDocument: document, inCollection: collection)
        }
    }
    
}

