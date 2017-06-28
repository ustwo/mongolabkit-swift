//
//  URLRequestExtensions.swift
//  MongoLabKit
//
//  Created by luca strazzullo on 28/06/2017.
//
//

import Foundation

extension URLRequest {

    public enum HTTPMethod: String {
        case POST
        case GET
        case PUT
    }


    public struct QueryStringParameter {

        let key: String
        let value: String


        init(key: String, value: String) {
            self.key = key
            self.value = value
        }


        // MARK: Public API

        public func queryString() -> String {
            return "\(key)=\(URLRequest.QueryStringParameter.escapedStringFrom(value))"
        }


        // MARK: Private helper methods

        private static func escapedStringFrom(_ value: String) -> String {
            return value.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? value
        }
    }
}
