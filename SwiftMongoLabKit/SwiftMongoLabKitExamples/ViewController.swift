//
//  ViewController.swift
//  SwiftMongoLabKitExamples
//
//  Created by luca strazzullo on 20/05/16.
//
//

import UIKit

class ViewController: UIViewController {

    private var service: CollectionService?


    override func viewDidLoad() {
        super.viewDidLoad()

        let client = MongoLabClient()

        let configuration = MongoLabConfiguration(baseURL: "", apiKey: "")

        service = CollectionService(client: client, configuration: configuration, delegate: self)
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

