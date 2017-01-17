//
//  ViewController.swift
//  MongoLabKitExamples
//
//  Created by luca strazzullo on 20/05/16.
//
//

import UIKit

class ViewController: UIViewController {

    // MARK: Instance properties

    private let configuration = MongoLabConfiguration(baseURL: "", apiKey: "")
    private let client = MongoLabClient()
    private var collectionsService: CollectionsService?
    private var documentsService: DocumentsService?
    private var documentService: DocumentService?


    // MARK: UI Callbacks

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


    @IBAction func listCollectionsWithService() {
        collectionsService = CollectionsService(configuration: configuration, delegate: self)
        collectionsService?.loadCollections()
    }


    @IBAction func listDocumentsWithService() {
        documentsService = DocumentsService(configuration: configuration, delegate: self)
        documentsService?.loadDocuments(for: Collection("randoms"))
    }


    @IBAction func addDocumentWithService() {
        let document = Document(id: UUID().uuidString, payload: ["active": true as AnyObject])

        documentService = DocumentService(configuration: configuration, delegate: self)
        documentService?.addDocument(document, inCollection: Collection("randoms"))
    }


    // MARK: Private helper methods

    private func perform(_ request: URLRequest) {
        let _ = client.perform(request) {
            result in

            switch result {
            case let .success(response):
                print("Success \(response)")

            case let .failure(error):
                print("Error \(error)")

            }
        }
    }

}


extension ViewController: ServiceDelegate {

    func serviceWillLoad<DataType>(_ service: Service<DataType>) {
        print("Loading")
    }


    func service<DataType>(_ service: Service<DataType>, didLoad data: DataType) {
        print("Collections loaded: \(data)")
    }


    func service<DataType>(_ service: Service<DataType>, didFailWith error: ErrorDescribable) {
        print("Error: \(error.description())")
    }
    
}
