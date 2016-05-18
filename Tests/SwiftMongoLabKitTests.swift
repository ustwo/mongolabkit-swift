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

    private let configuration = MongoLabConfiguration(baseURL: "", apiKey: "")


    func testLoadCollections() {
        precondition(!configuration.baseURL.isEmpty && !configuration.apiKey.isEmpty, "Configure your own mongolab database")

        let expectation = expectationWithDescription("asynchronous")

        let request = MongoLabURLRequest.URLRequestWithConfiguration(configuration, relativeURL: "collections", method: .GET, parameters: [], bodyData: nil)

        let client = MongoLabClient()

        client.performRequest(request) {
            result in
            expectation.fulfill()

            switch result {
            case let .Success(response):
                XCTAssertNotNil(response)

            case let .Failure(error):
                XCTFail(error.description())
            }
        }

        waitForExpectationsWithTimeout(10, handler: nil)
    }
    
}
