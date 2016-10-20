//
//  MongoLabClient.swift
//  MongoLabKit
//
//  Created by luca strazzullo on 12/03/16.
//  Copyright © 2016 ustwo. All rights reserved.
//

import Foundation

open class MongoLabClient {

    enum Result {
        case success(response: AnyObject)
        case failure(error: ErrorDescribable)
    }

    typealias Completion = (_ result: Result) -> ()

    static let sharedClient = MongoLabClient()


    // MARK: - Public methods
    // NOTE: - Not in the extension because is not possible to override a method in extensions yet.

    func perform(_ request: URLRequest, completion: @escaping Completion) {
        dataTask(with: request, completion: completion).resume()
    }

}


extension MongoLabClient {

    func parse(_ data: Data?, response: URLResponse?, error: Error?, completion: @escaping Completion) {
        do {
            call(completion, withResult: Result.success(response: try MongoLabResponseParser().parse(data, response: response, error: error)))

        } catch let error as ErrorDescribable {
            call(completion, withResult: Result.failure(error: error))
        } catch {
            call(completion, withResult: Result.failure(error: MongoLabError.parserError))
        }
    }

}


extension MongoLabClient {

    fileprivate func dataTask(with request: URLRequest, completion: @escaping Completion) -> URLSessionTask {
        let dataTask = URLSession.shared.dataTask(with: request) {
            [weak self] data, response, error in

            self?.parse(data, response: response, error: error, completion: completion)

            return
        }

        return dataTask
    }


    fileprivate func call(_ completion: @escaping Completion, withResult result: Result) {
        DispatchQueue.main.async {
            completion(result)
        }
    }

}

