//
//  Castable.swift
//  Decodable
//
//  Created by Johannes Lund on 2015-09-25.
//  Copyright © 2015 anviking. All rights reserved.
//

import Foundation

public protocol Castable: Decodable {}

extension Castable {
    
    public init(json: AnyObject) throws {
        guard let result = json as? Self else {
            let info = DecodingError.Info(object: json)
            throw DecodingError.TypeMismatch(type: json.dynamicType, expectedType: Self.self, info: info)
        }
        self = result
    }
}

extension String: Castable {}
extension Int: Castable {}
extension Double: Castable {}
extension Bool: Castable {}