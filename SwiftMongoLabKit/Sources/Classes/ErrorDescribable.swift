//
//  ErrorDescribable.swift
//  SwiftMongoLabApiClient
//
//  Created by luca strazzullo on 22/01/16.
//  Copyright © 2016 ustwo. All rights reserved.
//

import Foundation

public protocol ErrorDescribable: ErrorType {
    func description() -> String
}