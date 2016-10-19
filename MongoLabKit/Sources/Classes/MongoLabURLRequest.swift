//
//  MongoLabURLRequest.swift
//  MongoLabKit
//
//  Created by luca strazzullo on 12/03/16.
//  Copyright © 2016 ustwo. All rights reserved.
//

import Foundation

open class MongoLabURLRequest: NSMutableURLRequest {

    public typealias RequestParameter = (parameter: String, value: String)

    public enum HTTPMethod: String {
        case POST
        case GET
        case PUT
    }

}


extension MongoLabURLRequest {

    public class func urlRequestWith(_ configuration: MongoLabConfiguration, relativeURL: String, method: HTTPMethod, parameters: [RequestParameter]?, bodyData: AnyObject?) throws -> URLRequest {
        if configuration.baseURL.isEmpty || configuration.apiKey.isEmpty {
            throw MongoLabError.requestError
        }
        
        let url = urlString(for: configuration.baseURL, relativeURL: relativeURL, parameters: requiredParametersWith(configuration, parameters: parameters))

        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = method.rawValue
        request.httpBody = HTTPBodyDataFor(bodyData)
        request.timeoutInterval = 30
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")

        return request
    }


    class func HTTPBodyDataFor(_ bodyObject: AnyObject?) -> Data? {
        if let bodyObject = bodyObject {
            if let jsonData = try? JSONSerialization.data(withJSONObject: bodyObject, options: []) {
                return jsonData
            }
        }

        return nil
    }


    class func requiredParametersWith(_ configuration: MongoLabConfiguration, parameters: [RequestParameter]?) -> [RequestParameter] {
        let requiredParameters = [RequestParameter(parameter: "apiKey", value: configuration.apiKey)]

        guard var parameters = parameters else {
            return requiredParameters
        }

        parameters.append(contentsOf: requiredParameters)

        return parameters
    }


    class func urlString(for baseURL: String, relativeURL: String, parameters: [RequestParameter]?) -> String {
        let parametersString = parametersStringWith(parameters)

        return "\(baseURL)/\(relativeURL)\(parametersString)"
    }


    class func parametersStringWith(_ customParameters: [RequestParameter]?) -> String {
        var parameters = [RequestParameter]()

        if let customParameters = customParameters {
            parameters.append(contentsOf: customParameters)
        }

        let parameterString = parameters.map(mapWithEscapedValue(mapKeyWithValue)).joined(separator: "&")
        return parameterString.isEmpty ? "" : "?\(parameterString)"
    }


    class fileprivate func mapWithEscapedValue(_ transform: @escaping ((String, _ value: String) -> String)) -> ((String, _ value: String) -> String) {
        return {
            key, value in
            return transform(key, escapedStringFrom(value))
        }
    }


    class fileprivate func mapKeyWithValue(_ key: String, value: String) -> String {
        return "\(key)=\(value)"
    }


    class fileprivate func escapedStringFrom(_ value: String) -> String {
        return value.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? value
    }

}

