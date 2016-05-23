//
//  MongoLabClient.swift
//  MongoLabKit
//
//  Created by luca strazzullo on 12/03/16.
//  Copyright © 2016 ustwo. All rights reserved.
//

import Foundation

public class MongoLabClient {

    enum Result {
        case Success(response: AnyObject)
        case Failure(error: ErrorDescribable)
    }

    typealias Completion = (result: Result) -> ()

    static let sharedClient = MongoLabClient()

}


extension MongoLabClient {

    func performRequest(request: NSMutableURLRequest, completion: Completion) {
        dataTaskWithRequest(request, completion: completion).resume()
    }


    func parseData(data: NSData?, response: NSURLResponse?, error: NSError?, completion: Completion) {
        do {
            callCompletion(completion, withResult: Result.Success(response: try MongoLabResponseParser().parseData(data, response: response, error: error)))

        } catch let error as ErrorDescribable {
            callCompletion(completion, withResult: Result.Failure(error: error))
        } catch {
            callCompletion(completion, withResult: Result.Failure(error: MongoLabError.ParserError))
        }
    }

}


extension MongoLabClient {

    private func dataTaskWithRequest(request: NSMutableURLRequest, completion: Completion) -> NSURLSessionTask {
        let dataTask = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            [weak self] (data: NSData?, response: NSURLResponse?, error: NSError?) in

            self?.parseData(data, response: response, error: error, completion: completion)
        }

        return dataTask
    }


    private func callCompletion(completion: Completion, withResult result: Result) {
        dispatch_async(dispatch_get_main_queue()) {
            completion(result: result)
        }
    }

}

