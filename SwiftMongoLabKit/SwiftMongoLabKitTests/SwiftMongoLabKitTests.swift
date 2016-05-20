//
//  SwiftMongoLabKitTests.swift
//  SwiftMongoLabKitTests
//
//  Created by luca strazzullo on 18/05/16.
//
//

import XCTest
@testable import SwiftMongoLabKit

class SwiftMongoLabKit_iOSTests: XCTestCase {

    func testLoadCollectionsWithEmptyConfiguration() {
        let expectation = expectationWithDescription("asynchronous")

        let client = MongoLabClient()

        let delegate = CollectionServiceDelegateWithCompletion() {
            result in
            expectation.fulfill()

            switch result {
            case .Success:
                XCTFail()

            case let .Failure(error):
                XCTAssertEqual(error.description(), MongoLabError.RequestError.description())
            }
        }

        let configuration = MongoLabConfiguration(baseURL: "", apiKey: "")

        let service = CollectionService(client: client, delegate: delegate)

        service.loadCollectionsWithConfiguration(configuration)

        waitForExpectationsWithTimeout(10, handler: nil)
    }
    
}


class CollectionServiceDelegateWithCompletion: CollectionServiceDelegate {

    enum Result {
        case Success(response: AnyObject)
        case Failure(error: ErrorDescribable)
    }

    typealias Completion = (result: Result) -> ()

    private let completion: Completion


    func collectionServiceWillLoadCollection(service: CollectionService?) {

    }


    func collectionService(service: CollectionService?, didLoadCollections collections: Collections) {
        completion(result: Result.Success(response: collections))
    }


    func collectionService(service: CollectionService?, didFailWithError error: ErrorDescribable) {
        completion(result: Result.Failure(error: error))
    }


    init(completion: Completion) {
        self.completion = completion
    }

}

