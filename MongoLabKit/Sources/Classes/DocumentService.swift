//
//  DocumentService.swift
//  MongoLabKit
//
//  Created by luca strazzullo on 24/05/16.
//
//

import Foundation

protocol DocumentServiceDelegate: AnyObject {
    func documentService(_ service: DocumentService?, willLoadDocumentsInCollection collection: Collection)
    func documentService(_ service: DocumentService?, didLoadDocuments documents: Documents, inCollection collection: Collection)

    func documentService(_ service: DocumentService?, willAddDocumentInCollection collection: Collection)
    func documentService(_ service: DocumentService?, didAddDocument document: Document, inCollection collection: Collection)

    func documentService(_ service: DocumentService?, didFailWithError error: ErrorDescribable)
}


class DocumentService {

    fileprivate let client: MongoLabClient

    fileprivate var configuration: MongoLabConfiguration

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

    func loadDocumentsFor(_ collection: Collection) {
        defer {
            delegate?.documentService(self, willLoadDocumentsInCollection: collection)
        }

        do {
            let request = try MongoLabURLRequest.urlRequestWith(configuration, relativeURL: "collections/\(collection)", method: .GET, parameters: [], bodyData: nil)

            client.perform(request) {
                [weak self] result in

                switch result {
                case let .success(response):
                    self?.parseDocumentsLoaded(response, inCollection: collection)

                case let .failure(error):
                    self?.serviceError(error)
                }
            }
        } catch let error {

            serviceError(error as? ErrorDescribable ?? MongoLabError.requestError)
        }
    }


    func addDocument(_ document: Document, inCollection collection: Collection) {
        defer {
            delegate?.documentService(self, willAddDocumentInCollection: collection)
        }

        do {
            let request = try MongoLabURLRequest.urlRequestWith(configuration, relativeURL: "collections/\(collection)", method: .POST, parameters: [], bodyData: document.payload as AnyObject?)

            client.perform(request) {
                [weak self] result in

                switch result {
                case let .success(response):
                    self?.parseDocumentAdded(response, inCollection: collection)

                case let .failure(error):
                    self?.serviceError(error)
                }
            }
        } catch let error {

            serviceError(error as? ErrorDescribable ?? MongoLabError.requestError)
        }
    }

}


extension DocumentService {

    fileprivate func serviceError(_ error: ErrorDescribable) {
        DispatchQueue.main.async {
            [weak self] in
            self?.delegate?.documentService(self, didFailWithError: error)
        }
    }

}


extension DocumentService {

    fileprivate func parseDocumentsLoaded(_ response: AnyObject, inCollection collection: Collection) {
        DispatchQueue.global().async {
            [weak self] in

            do {
                let documents = try DocumentsParser().parse(response)

                self?.documentsLoaded(documents, inCollection: collection)

            } catch let error as ErrorDescribable {
                self?.serviceError(error)
            } catch {
                self?.serviceError(MongoLabError.parserError)
            }
        }
    }


    fileprivate func documentsLoaded(_ documents: Documents, inCollection collection: Collection) {
        DispatchQueue.main.async {
            [weak self] in
            self?.delegate?.documentService(self, didLoadDocuments: documents, inCollection: collection)
        }
    }
    
}


extension DocumentService {

    fileprivate func parseDocumentAdded(_ response: AnyObject, inCollection collection: Collection) {
        DispatchQueue.global().async {
            [weak self] in

            do {
                let document = try DocumentParser().parse(response)

                self?.documentAdded(document, inCollection: collection)

            } catch let error as ErrorDescribable {
                self?.serviceError(error)
            } catch {
                self?.serviceError(MongoLabError.parserError)
            }
        }
    }


    fileprivate func documentAdded(_ document: Document, inCollection collection: Collection) {
        DispatchQueue.main.async {
            [weak self] in
            self?.delegate?.documentService(self, didAddDocument: document, inCollection: collection)
        }
    }
    
}

