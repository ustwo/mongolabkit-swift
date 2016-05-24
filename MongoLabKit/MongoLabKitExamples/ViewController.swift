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

    private var service: CollectionService?

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

    @IBAction func listCollections() {
        service = CollectionService(configuration: configuration, delegate: self)
        service?.loadCollections()
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

