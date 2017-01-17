//
//  MongoLabClient.swift
//  MongoLabKit
//
//  Created by luca strazzullo on 12/03/16.
//  Copyright © 2016 ustwo. All rights reserved.
//

import Foundation

open class MongoLabClient {

    // MARK: Typealiases

    typealias Completion = (_ result: Result) -> ()


    // MARK: Types

    enum Result {
        case success(response: AnyObject)
        case failure(error: ErrorDescribable)
    }


    // MARK: Static properties

    static let sharedClient = MongoLabClient()


    // MARK: Public APIs

    func perform(_ request: URLRequest, completion: @escaping Completion) -> URLSessionTask {
        let session = dataTask(with: request, completion: completion)
        session.resume()

        return session
    }


    // MARK: Private helper methods

    private func dataTask(with request: URLRequest, completion: @escaping Completion) -> URLSessionTask {
        let dataTask = URLSession.shared.dataTask(with: request) {
            [weak self] data, response, error in

            self?.parse(data, response: response, error: error, completion: completion)

            return
        }

        return dataTask
    }


    private func parse(_ data: Data?, response: URLResponse?, error: Error?, completion: @escaping Completion) {
        do {
            call(completion, withResult: Result.success(response: try MongoLabResponseParser().parse(data, response: response, error: error)))
        } catch let error as ErrorDescribable {
            call(completion, withResult: Result.failure(error: error))
        } catch {
            call(completion, withResult: Result.failure(error: MongoLabError.parserError))
        }
    }


    private func call(_ completion: @escaping Completion, withResult result: Result) {
        DispatchQueue.main.async {
            completion(result)
        }
    }

}
