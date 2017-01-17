//
//  MongoLabKitTests.swift
//  MongoLabKitTests
//
//  Created by luca strazzullo on 18/05/16.
//
//

import XCTest
@testable import MongoLabKit

class MongoLabKit_CollectionsService_iOSTests: XCTestCase {

    private var service: CollectionsService?


    func testLoadCollections() {
        let mockConfiguration = MongoLabConfiguration(baseURL: "fakeURL", apiKey: "fakeApiKey")

        let response = ["Collection 1", "Collection 2"]
        let mockResult = MongoLabClient.Result.success(response: response as AnyObject)

        loadCollectionsWithMongoLab(mockResult: mockResult, configuration: mockConfiguration) {
            result in

            switch result {
            case let .success(response):
                XCTAssertEqual(response, Collections(arrayLiteral: Collection("Collection 1"), Collection("Collection 2")))

            case let .failure(error):
                XCTFail(error.description())
                
            }
        }
    }


    func testLoadCollectionsWithParsingError() {
        let mockConfiguration = MongoLabConfiguration(baseURL: "fakeURL", apiKey: "fakeApiKey")

        let response = ["collections": ["Collection 1", "Collection 2"]]
        let mockResult = MongoLabClient.Result.success(response: response as AnyObject)

        loadCollectionsWithMongoLab(mockResult: mockResult, configuration: mockConfiguration) {
            result in

            switch result {
            case .success:
                XCTFail()

            case let .failure(error):
                XCTAssertEqual(error.description(), MongoLabError.parserError.description())
            }
        }
    }


    func testLoadCollectionsWithConfigurationError() {
        let mockConfiguration = MongoLabConfiguration(baseURL: "", apiKey: "")

        let response = ["Collection 1", "Collection 2"]
        let mockResult = MongoLabClient.Result.success(response: response as AnyObject)

        loadCollectionsWithMongoLab(mockResult: mockResult, configuration: mockConfiguration) {
            result in

            switch result {
            case .success:
                XCTFail()

            case let .failure(error):
                XCTAssertEqual(error.description(), MongoLabError.requestError.description())
            }
        }
    }


    // MARK: - Private helper methods

    private func loadCollectionsWithMongoLab(mockResult: MongoLabClient.Result, configuration: MongoLabConfiguration, completion: @escaping MockCollectionServiceDelegate.Completion) {
        let asynchronousExpectation = expectation(description: "asynchronous")

        let mockClient = MockMongoLabClient(result: mockResult)

        let mockDelegate = MockCollectionServiceDelegate() {
            result in
            asynchronousExpectation.fulfill()

            completion(result)
        }

        loadCollectionsWith(client: mockClient, configuration: configuration, delegate: mockDelegate)

        waitForExpectations(timeout: 10, handler: nil)
    }


    private func loadCollectionsWith(client: MongoLabClient, configuration: MongoLabConfiguration, delegate: ServiceDelegate) {
        service = CollectionsService(client: client, configuration: configuration, delegate: delegate)
        service?.loadCollections()
    }


    // MARK: - Mocked client

    private class MockMongoLabClient: MongoLabClient {

        var result: MongoLabClient.Result

        init (result: MongoLabClient.Result) {
            self.result = result
        }

        override func perform(_ request: URLRequest, completion: @escaping MongoLabClient.Completion) -> URLSessionTask {
            completion(result)

            return URLSessionTask()
        }

    }


    // MARK: - Mocked delegate

    class MockCollectionServiceDelegate: ServiceDelegate {

        enum Result {
            case success(response: Collections)
            case failure(error: ErrorDescribable)
        }

        typealias Completion = (_ result: Result) -> ()


        let completion: Completion


        func serviceWillLoad<DataType>(_ service: Service<DataType>) {}


        func service<DataType>(_ service: Service<DataType>, didLoad data: DataType) {
            if let collections = data as? Collections {
                completion(Result.success(response: collections))
            }
        }


        func service<DataType>(_ service: Service<DataType>, didFailWith error: ErrorDescribable) {
            completion(Result.failure(error: error))
        }


        init(completion: @escaping Completion) {
            self.completion = completion
        }
        
    }
    
}

