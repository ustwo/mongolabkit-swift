//
//  MongoLabURLRequest.swift
//  MongoLabKit
//
//  Created by luca strazzullo on 12/03/16.
//  Copyright © 2016 ustwo. All rights reserved.
//

import Foundation

public struct MongoLabURLRequest {

    // MARK: Public class methods

    static func urlRequestWith(_ configuration: Configuration, relativeURL: String, method: URLRequest.HTTPMethod, parameters: [URLRequest.QueryStringParameter]?, bodyData: AnyObject?) throws -> URLRequest {
        try configuration.validate()

        let url = URLBuilder.url(for: configuration.baseURL, databaseName: configuration.databaseName, relativeURL: relativeURL, parameters: requiredParametersWith(configuration, parameters: parameters))

        var request = URLRequest(url: url!)
        request.httpMethod = method.rawValue
        request.httpBody = HTTPBodyDataFor(bodyData)
        request.timeoutInterval = 30
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")

        return request
    }


    // MARK: Private helper methods

    private static func HTTPBodyDataFor(_ bodyObject: AnyObject?) -> Data? {
        if let bodyObject = bodyObject {
            if let jsonData = try? JSONSerialization.data(withJSONObject: bodyObject, options: []) {
                return jsonData
            }
        }

        return nil
    }


    private static func requiredParametersWith(_ configuration: Configuration, parameters: [URLRequest.QueryStringParameter]?) -> [URLRequest.QueryStringParameter] {
        let requiredParameters = [URLRequest.QueryStringParameter(key: "apiKey", value: configuration.apiKey)]

        guard var parameters = parameters else {
            return requiredParameters
        }

        parameters.append(contentsOf: requiredParameters)

        return parameters
    }

}
