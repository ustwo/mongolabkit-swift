//
//  MongoLabURLRequest.swift
//  MongoLabKit
//
//  Created by luca strazzullo on 12/03/16.
//  Copyright © 2016 ustwo. All rights reserved.
//

import Foundation

public class MongoLabURLRequest: NSMutableURLRequest {

    public typealias RequestParameter = (parameter: String, value: String)

    public enum HTTPMethod: String {
        case POST
        case GET
        case PUT
    }

}


extension MongoLabURLRequest {

    public class func URLRequestWithConfiguration(configuration: MongoLabConfiguration, relativeURL: String, method: HTTPMethod, parameters: [RequestParameter]?, bodyData: AnyObject?) throws -> NSMutableURLRequest {
        if configuration.baseURL.isEmpty || configuration.apiKey.isEmpty {
            throw MongoLabError.RequestError
        }
        
        let URLString = URLStringForBaseURL(configuration.baseURL, relativeURL: relativeURL, parameters: requiredParametersWithConfiguration(configuration, parameters: parameters))

        let request = NSMutableURLRequest(URL: NSURL(string: URLString)!)
        request.HTTPMethod = method.rawValue
        request.HTTPBody = HTTPBodyDataForBodyObject(bodyData)
        request.timeoutInterval = 30
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")

        return request
    }


    class func HTTPBodyDataForBodyObject(bodyObject: AnyObject?) -> NSData? {
        if let bodyObject = bodyObject {
            if let jsonData = try? NSJSONSerialization.dataWithJSONObject(bodyObject, options: []) {
                return jsonData
            }
        }

        return nil
    }


    class func requiredParametersWithConfiguration(configuration: MongoLabConfiguration, parameters: [RequestParameter]?) -> [RequestParameter] {
        let requiredParameters = [RequestParameter(parameter: "apiKey", value: configuration.apiKey)]

        guard var parameters = parameters else {
            return requiredParameters
        }

        parameters.appendContentsOf(requiredParameters)

        return parameters
    }


    class func URLStringForBaseURL(baseURL: String, relativeURL: String, parameters: [RequestParameter]?) -> String {
        let parametersString = parametersStringWithCustomParameters(parameters)

        return "\(baseURL)/\(relativeURL)\(parametersString)"
    }


    class func parametersStringWithCustomParameters(customParameters: [RequestParameter]?) -> String {
        var parameters = [RequestParameter]()

        if let customParameters = customParameters {
            parameters.appendContentsOf(customParameters)
        }

        let parameterString = parameters.map(mapWithEscapedValue(mapKeyWithValue)).joinWithSeparator("&")
        return parameterString.isEmpty ? "" : "?\(parameterString)"
    }


    class private func mapWithEscapedValue(transform: ((String, value: String) -> String)) -> ((String, value: String) -> String) {
        return {
            key, value in
            return transform(key, value: escapedStringFromValue(value))
        }
    }


    class private func mapKeyWithValue(key: String, value: String) -> String {
        return "\(key)=\(value)"
    }


    class private func escapedStringFromValue(value: String) -> String {
        return value.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet()) ?? value
    }

}

