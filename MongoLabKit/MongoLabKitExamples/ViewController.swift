//
//  ViewController.swift
//  MongoLabKitExamples
//
//  Created by luca strazzullo on 20/05/16.
//
//

import UIKit

class ViewController: UIViewController {

    fileprivate let configuration = MongoLabConfiguration(baseURL: "", apiKey: "")

    fileprivate let client = MongoLabClient()

    fileprivate var collectionService: CollectionService?

    fileprivate var documentService: DocumentService?

}


// ------------------
// Custom requests
// ------------------

extension ViewController {

    fileprivate func perform(_ request: URLRequest) {
        client.perform(request) {
            result in

            switch result {
            case let .success(response):
                print("Success \(response)")

            case let .failure(error):
                print("Error \(error)")

            }
        }
    }


    @IBAction func listCollections() {
        do {
            let request = try MongoLabURLRequest.urlRequestWith(configuration, relativeURL: "collections", method: .GET, parameters: [], bodyData: nil)

            perform(request)

        } catch let error {
            print("Error \((error as? ErrorDescribable ?? MongoLabError.requestError).description())")
        }
    }


    @IBAction func insertDocument() {
        do {
            let body: [String: AnyObject] = ["UUID": UUID().uuidString as AnyObject, "active": true as AnyObject]

            let request = try MongoLabURLRequest.urlRequestWith(configuration, relativeURL: "collections/randoms", method: .POST, parameters: [], bodyData: body as AnyObject)

            perform(request)

        } catch let error {
            print("Error \((error as? ErrorDescribable ?? MongoLabError.requestError).description())")
        }
    }


    @IBAction func listDocuments() {
        do {
            let param = MongoLabURLRequest.RequestParameter(parameter: "q", value: "{\"active\": true}")

            let request = try MongoLabURLRequest.urlRequestWith(configuration, relativeURL: "collections/randoms", method: .GET, parameters: [param], bodyData: nil)

            perform(request)

        } catch let error {
            print("Error \((error as? ErrorDescribable ?? MongoLabError.requestError).description())")
        }
    }

}


// ------------------
// Collection Service
// ------------------

extension ViewController {

    @IBAction func listCollectionsWithService() {
        collectionService = CollectionService(configuration: configuration, delegate: self)
        collectionService?.loadCollections()
    }

}


extension ViewController: CollectionServiceDelegate {

    func collectionServiceWillLoadCollection(_ service: CollectionService?) {
        print("Loading Collections")
    }


    func collectionService(_ service: CollectionService?, didLoadCollections collections: Collections) {
        print("Collections loaded: \(collections)")
    }


    func collectionService(_ service: CollectionService?, didFailWithError error: ErrorDescribable) {
        print("Error: \(error.description())")
    }
    
}


// ------------------
// Document Service
// ------------------

extension ViewController {

    @IBAction func listDocumentsWithService() {
        documentService = DocumentService(configuration: configuration, delegate: self)
        documentService?.loadDocumentsFor(Collection("randoms"))
    }


    @IBAction func addDocumentWithService() {
        let document = Document(id: UUID().uuidString, payload: ["active": true as AnyObject])

        documentService = DocumentService(configuration: configuration, delegate: self)
        documentService?.addDocument(document, inCollection: Collection("randoms"))
    }

}


extension ViewController: DocumentServiceDelegate {

    func documentService(_ service: DocumentService?, willLoadDocumentsInCollection collection: Collection) {
        print("Loading Documents in collection: \(collection)")
    }


    func documentService(_ service: DocumentService?, didLoadDocuments documents: Documents, inCollection collection: Collection) {
        print("Documents loaded: \(documents) in collection: \(collection)")
    }


    func documentService(_ service: DocumentService?, willAddDocumentInCollection collection: Collection) {
        print("Adding Document in collection: \(collection)")
    }


    func documentService(_ service: DocumentService?, didAddDocument document: Document, inCollection collection: Collection) {
        print("Document added: \(document) in collection: \(collection)")
    }


    func documentService(_ service: DocumentService?, didFailWithError error: ErrorDescribable) {
        print("Error: \(error.description())")
    }
    
}

