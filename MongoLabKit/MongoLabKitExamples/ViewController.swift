//
//  ViewController.swift
//  MongoLabKitExamples
//
//  Created by luca strazzullo on 20/05/16.
//
//

import UIKit

class ViewController: UIViewController {

    private let configuration = MongoLabConfiguration(baseURL: "", apiKey: "")

    private let client = MongoLabClient()

    private var collectionService: CollectionService?

    private var documentService: DocumentService?

}


// ------------------
// Custom requests
// ------------------

extension ViewController {

    private func performRequest(request: NSMutableURLRequest) {
        client.performRequest(request) {
            result in

            switch result {
            case let .Success(response):
                print("Success \(response)")

            case let .Failure(error):
                print("Error \(error)")

            }
        }
    }


    @IBAction func insertDocument() {
        do {
            let body: [String: AnyObject] = ["UUID": NSUUID().UUIDString, "active": true]

            let request = try MongoLabURLRequest.URLRequestWithConfiguration(configuration, relativeURL: "collections/randoms", method: .POST, parameters: [], bodyData: body)

            performRequest(request)

        } catch let error {
            print("Error \((error as? ErrorDescribable ?? MongoLabError.RequestError).description())")
        }
    }


    @IBAction func listDocuments() {
        do {
            let param = MongoLabURLRequest.RequestParameter(parameter: "q", value: "{\"active\": true}")

            let request = try MongoLabURLRequest.URLRequestWithConfiguration(configuration, relativeURL: "collections/randoms", method: .GET, parameters: [param], bodyData: nil)

            performRequest(request)

        } catch let error {
            print("Error \((error as? ErrorDescribable ?? MongoLabError.RequestError).description())")
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

    func collectionServiceWillLoadCollection(service: CollectionService?) {
        print("Loading Collections")
    }


    func collectionService(service: CollectionService?, didLoadCollections collections: Collections) {
        print("Collections loaded: \(collections)")
    }


    func collectionService(service: CollectionService?, didFailWithError error: ErrorDescribable) {
        print("Error: \(error.description())")
    }
    
}


// ------------------
// Document Service
// ------------------

extension ViewController {

    @IBAction func listDocumentsWithService() {
        documentService = DocumentService(configuration: configuration, delegate: self)
        documentService?.loadDocumentsForCollection(Collection("randoms"))
    }

}


extension ViewController: DocumentServiceDelegate {

    func documentService(service: DocumentService?, willLoadDocumentsInCollection collection: Collection) {
        print("Loading Documents in collection: \(collection)")
    }


    func documentService(service: DocumentService?, didLoadDocuments documents: Documents, inCollection collection: Collection) {
        print("Documents loaded: \(documents) in collection: \(collection)")
    }


    func documentService(service: DocumentService?, didFailWithError error: ErrorDescribable) {
        print("Error: \(error.description())")
    }
    
}

