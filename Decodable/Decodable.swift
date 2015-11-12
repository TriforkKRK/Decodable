//
//  Decodable.swift
//  Decodable
//
//  Created by Johannes Lund on 2015-07-07.
//  Copyright © 2015 anviking. All rights reserved.
//

import Foundation

public protocol JSONInitiable {
    init(json: AnyObject) throws
}

extension NSDictionary {
    convenience init(json: AnyObject) throws {
        guard let result = json as? NSDictionary else {
            let info = DecodingError.Info(object: json)
            throw DecodingError.TypeMismatch(type: json.dynamicType, expectedType: NSDictionary.self, info: info)
        }
        self.init(dictionary: result)
    }
}

extension Array where Element: JSONInitiable {
    init(json: AnyObject) throws {
        self =  try decodeArray(Element.init)(json: json)
    }
}

extension Dictionary where Key: JSONInitiable, Value: JSONInitiable {
    init(json: AnyObject) throws {
        self = try decodeDictionary(Key.init)(elementDecodeClosure: Value.init)(json: json)
    }
}
