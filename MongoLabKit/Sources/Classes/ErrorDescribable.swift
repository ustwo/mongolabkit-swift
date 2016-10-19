//
//  ErrorDescribable.swift
//  MongoLabKit
//
//  Created by luca strazzullo on 22/01/16.
//  Copyright © 2016 ustwo. All rights reserved.
//

import Foundation

public protocol ErrorDescribable: Error {
    func description() -> String
}
