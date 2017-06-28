//
//  URLBuilder.swift
//  MongoLabKit
//
//  Created by luca strazzullo on 28/06/2017.
//
//

import Foundation

public struct URLBuilder {

    // MARK: Public API

    public static func url(for baseURL: String, databaseName: String, relativeURL: String, parameters: [URLRequest.QueryStringParameter]?) -> URL? {
        let string = urlString(for: baseURL, databaseName: databaseName, relativeURL: relativeURL, parameters: parameters)

        return URL(string: string)
    }


    // MARK: Private helper methods

    private static func urlString(for baseURL: String, databaseName: String, relativeURL: String, parameters: [URLRequest.QueryStringParameter]?) -> String {
        let parametersString = parametersStringWith(parameters)

        return "\(baseURL)/\(databaseName)/\(relativeURL)\(parametersString)"
    }


    private static func parametersStringWith(_ customParameters: [URLRequest.QueryStringParameter]?) -> String {
        var parameters = Array<URLRequest.QueryStringParameter>()

        if let customParameters = customParameters {
            parameters.append(contentsOf: customParameters)
        }

        let parameterString = parameters.map(queryString).joined(separator: "&")

        return parameterString.isEmpty ? "" : "?\(parameterString)"
    }


    private static func queryString(_ parameter: URLRequest.QueryStringParameter) -> String {
        return parameter.queryString()
    }
    
}
