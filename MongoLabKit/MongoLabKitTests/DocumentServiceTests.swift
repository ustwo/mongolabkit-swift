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

        let response = [["_id": ["$oid": "5743ab370a00b27cd1d10c92"]]]
        let mockResult = MongoLabClient.Result.success(response: response as AnyObject)

        loadDocumentsWithMongoLab(mockResult: mockResult, configuration: mockConfiguration) {
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

        let response = [["$oid": "5743ab370a00b27cd1d10c92"]]
        let mockResult = MongoLabClient.Result.success(response: response as AnyObject)

        loadDocumentsWithMongoLab(mockResult: mockResult, configuration: mockConfiguration) {
            result in

            switch result {
            case .Success:
                XCTFail()

            case let .Failure(error):
                XCTAssertEqual(error.description(), MongoLabError.parserError.description())
            }
        }
    }


    func testLoadDocumentsWithConfigurationError() {
        let mockConfiguration = MongoLabConfiguration(baseURL: "", apiKey: "")

        let response = [["$oid": "5743ab370a00b27cd1d10c92"]]
        let mockResult = MongoLabClient.Result.success(response: response as AnyObject)

        loadDocumentsWithMongoLab(mockResult: mockResult, configuration: mockConfiguration) {
            result in

            switch result {
            case .Success:
                XCTFail()

            case let .Failure(error):
                XCTAssertEqual(error.description(), MongoLabError.requestError.description())
            }
        }
    }


    // MARK: - Private helper methods

    private func loadDocumentsWithMongoLab(mockResult: MongoLabClient.Result, configuration: MongoLabConfiguration, completion: @escaping MockDocumentServiceDelegate.Completion) {
        let asynchronousExpectation = expectation(description: "asynchronous")

        let mockClient = MockMongoLabClient(result: mockResult)

        let mockDelegate = MockDocumentServiceDelegate() {
            result in
            asynchronousExpectation.fulfill()

            completion(result)
        }

        loadDocumentsWith(client: mockClient, configuration: configuration, delegate: mockDelegate)
        
        waitForExpectations(timeout: 10, handler: nil)
    }


    private func loadDocumentsWith(client: MongoLabClient, configuration: MongoLabConfiguration, delegate: DocumentServiceDelegate) {
        service = DocumentService(client: client, configuration: configuration, delegate: delegate)
        service?.loadDocumentsFor("collection")
    }


    // MARK: - Mocked client

    private class MockMongoLabClient: MongoLabClient {

        var result: MongoLabClient.Result

        init (result: MongoLabClient.Result) {
            self.result = result
        }

        override func perform(_ request: URLRequest, completion: @escaping MongoLabClient.Completion) {
            completion(result)
        }

    }


    // MARK: - Mocked delegate

    class MockDocumentServiceDelegate: DocumentServiceDelegate {

        enum Result {
            case Success(response: Documents)
            case Failure(error: ErrorDescribable)
        }

        typealias Completion = (_ result: Result) -> ()


        let completion: Completion


        func documentService(_ service: DocumentService?, willLoadDocumentsInCollection collection: Collection) {}


        func documentService(_ service: DocumentService?, didLoadDocuments documents: Documents, inCollection collection: Collection) {
            completion(Result.Success(response: documents))
        }


        func documentService(_ service: DocumentService?, willAddDocumentInCollection collection: Collection) {}


        func documentService(_ service: DocumentService?, didAddDocument document: Document, inCollection collection: Collection) {}


        func documentService(_ service: DocumentService?, didFailWithError error: ErrorDescribable) {
            completion(Result.Failure(error: error))
        }


        init(completion: @escaping Completion) {
            self.completion = completion
        }
        
    }
    
}

