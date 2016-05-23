//
//  MongoLabKitTests.swift
//  MongoLabKitTests
//
//  Created by luca strazzullo on 18/05/16.
//
//

import XCTest
@testable import MongoLabKit

class MongoLabKit_iOSTests: XCTestCase {

    private var service: CollectionService?


    func testLoadCollections() {
        let mockConfiguration = MongoLabConfiguration(baseURL: "fakeURL", apiKey: "fakeApiKey")

        let mockResult = MongoLabClient.Result.Success(response: ["Collection 1", "Collection 2"])

        loadCollectionsWithMongoLabResult(mockResult, configuration: mockConfiguration) {
            result in

            switch result {
            case let .Success(response):
                guard let response = response as? [String] else {
                    XCTFail()

                    return
                }

                XCTAssertEqual(response, Collections(arrayLiteral: Collection("Collection 1"), Collection("Collection 2")))

            case let .Failure(error):
                XCTFail(error.description())
                
            }
        }
    }


    func testLoadCollectionsWithParsingError() {
        let mockConfiguration = MongoLabConfiguration(baseURL: "fakeURL", apiKey: "fakeApiKey")

        let mockResult = MongoLabClient.Result.Success(response: ["collections": ["Collection 1", "Collection 2"]])

        loadCollectionsWithMongoLabResult(mockResult, configuration: mockConfiguration) {
            result in

            switch result {
            case .Success:
                XCTFail()

            case let .Failure(error):
                XCTAssertEqual(error.description(), MongoLabError.ParserError.description())
            }
        }
    }


    func testLoadCollectionsWithConfigurationError() {
        let mockConfiguration = MongoLabConfiguration(baseURL: "", apiKey: "")

        let mockResult = MongoLabClient.Result.Success(response: ["Collection 1", "Collection 2"])

        loadCollectionsWithMongoLabResult(mockResult, configuration: mockConfiguration) {
            result in

            switch result {
            case .Success:
                XCTFail()

            case let .Failure(error):
                XCTAssertEqual(error.description(), MongoLabError.RequestError.description())
            }
        }
    }


    // MARK: - Private helper methods

    private func loadCollectionsWithMongoLabResult(mockResult: MongoLabClient.Result, configuration: MongoLabConfiguration, completion: MongoLabClient.Completion) {
        let expectation = expectationWithDescription("asynchronous")

        let mockClient = MockMongoLabClient(result: mockResult)

        let mockDelegate = MockCollectionServiceDelegate() {
            result in
            expectation.fulfill()

            completion(result: result)
        }

        loadCollectionsWithClient(mockClient, configuration: configuration, delegate: mockDelegate)
        
        waitForExpectationsWithTimeout(10, handler: nil)
    }


    private func loadCollectionsWithClient(client: MongoLabClient, configuration: MongoLabConfiguration, delegate: CollectionServiceDelegate) {
        service = CollectionService(client: client, configuration: configuration, delegate: delegate)
        service?.loadCollections()
    }


    // MARK: - Mocked client

    private class MockMongoLabClient: MongoLabClient {

        var result: MongoLabClient.Result

        init (result: MongoLabClient.Result) {
            self.result = result
        }

        override func performRequest(request: NSMutableURLRequest, completion: MongoLabClient.Completion) {
            completion(result: result)
        }

    }


    // MARK: - Mocked delegate

    class MockCollectionServiceDelegate: CollectionServiceDelegate {

        private let completion: MongoLabClient.Completion


        func collectionServiceWillLoadCollection(service: CollectionService?) {}


        func collectionService(service: CollectionService?, didLoadCollections collections: Collections) {
            completion(result: MongoLabClient.Result.Success(response: collections))
        }


        func collectionService(service: CollectionService?, didFailWithError error: ErrorDescribable) {
            completion(result: MongoLabClient.Result.Failure(error: error))
        }


        init(completion: MongoLabClient.Completion) {
            self.completion = completion
        }
        
    }
    
}

