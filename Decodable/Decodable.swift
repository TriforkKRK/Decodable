//
//  Decodable.swift
//  Decodable
//
//  Created by Johannes Lund on 2015-07-07.
//  Copyright © 2015 anviking. All rights reserved.
//

import Foundation

public protocol Decodable {
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

extension Array where Element: Decodable {
    public static func decode(j: AnyObject, ignoreInvalidObjects: Bool = false) throws -> [Element] {
        if ignoreInvalidObjects {
            return try decodeArray { try? Element(json: $0) }(json: j).flatMap {$0}
        } else {
            return try decodeArray(Element.init)(json: j)
        }
    }
}

extension Dictionary where Key: Decodable, Value: Decodable {
    public static func decode(j: AnyObject) throws -> Dictionary {
        return try decodeDictionary(Key.init)(elementDecodeClosure: Value.init)(json: j)
    }
    
}
