//
//  MongoLabKitTests.swift
//  MongoLabKitTests
//
//  Created by luca strazzullo on 18/05/16.
//
//

import XCTest
@testable import MongoLabKit

class MongoLabKit_DocumentService_iOSTests: XCTestCase {

    private var service: DocumentService?


    func testLoadDocuments() {
        let mockConfiguration = MongoLabConfiguration(baseURL: "fakeURL", apiKey: "fakeApiKey")

        let mockResult = MongoLabClient.Result.Success(response: [["_id": ["$oid": "5743ab370a00b27cd1d10c92"]]])

        loadDocumentsWithMongoLabResult(mockResult, configuration: mockConfiguration) {
            result in

            switch result {
            case let .Success(response):
                XCTAssertEqual(response.first?.id, "5743ab370a00b27cd1d10c92")

            case let .Failure(error):
                XCTFail(error.description())
                
            }
        }
    }


    func testLoadDocumentsWithParsingError() {
        let mockConfiguration = MongoLabConfiguration(baseURL: "fakeURL", apiKey: "fakeApiKey")

        let mockResult = MongoLabClient.Result.Success(response: [["$oid": "5743ab370a00b27cd1d10c92"]])

        loadDocumentsWithMongoLabResult(mockResult, configuration: mockConfiguration) {
            result in

            switch result {
            case .Success:
                XCTFail()

            case let .Failure(error):
                XCTAssertEqual(error.description(), MongoLabError.ParserError.description())
            }
        }
    }


    func testLoadDocumentsWithConfigurationError() {
        let mockConfiguration = MongoLabConfiguration(baseURL: "", apiKey: "")

        let mockResult = MongoLabClient.Result.Success(response: [["$oid": "5743ab370a00b27cd1d10c92"]])

        loadDocumentsWithMongoLabResult(mockResult, configuration: mockConfiguration) {
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

    private func loadDocumentsWithMongoLabResult(mockResult: MongoLabClient.Result, configuration: MongoLabConfiguration, completion: MockDocumentServiceDelegate.Completion) {
        let expectation = expectationWithDescription("asynchronous")

        let mockClient = MockMongoLabClient(result: mockResult)

        let mockDelegate = MockDocumentServiceDelegate() {
            result in
            expectation.fulfill()

            completion(result: result)
        }

        loadDocumentsWithClient(mockClient, configuration: configuration, delegate: mockDelegate)
        
        waitForExpectationsWithTimeout(10, handler: nil)
    }


    private func loadDocumentsWithClient(client: MongoLabClient, configuration: MongoLabConfiguration, delegate: DocumentServiceDelegate) {
        service = DocumentService(client: client, configuration: configuration, delegate: delegate)
        service?.loadDocumentsForCollection("collection")
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

    class MockDocumentServiceDelegate: DocumentServiceDelegate {

        enum Result {
            case Success(response: Documents)
            case Failure(error: ErrorDescribable)
        }

        typealias Completion = (result: Result) -> ()


        let completion: Completion


        func documentService(service: DocumentService?, willLoadDocumentsInCollection collection: Collection) {}


        func documentService(service: DocumentService?, didLoadDocuments documents: Documents, inCollection collection: Collection) {
            completion(result: Result.Success(response: documents))
        }


        func documentService(service: DocumentService?, willAddDocumentInCollection collection: Collection) {}


        func documentService(service: DocumentService?, didAddDocument document: Document, inCollection collection: Collection) {}


        func documentService(service: DocumentService?, didFailWithError error: ErrorDescribable) {
            completion(result: Result.Failure(error: error))
        }


        init(completion: Completion) {
            self.completion = completion
        }
        
    }
    
}

