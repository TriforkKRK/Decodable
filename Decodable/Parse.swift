//
//  Parse.swift
//  Decodable
//
//  Created by Johannes Lund on 2015-08-13.
//  Copyright © 2015 anviking. All rights reserved.
//

import Foundation

public func parse<T>(json: AnyObject, path: [String], decode: (AnyObject throws -> T)) throws -> T {
    
    var object = json
    
    if let lastKey = path.last {
        var path = path
        path.removeLast()
        
        var currentDict = try NSDictionary(json: json)
        var currentPath: [String] = []
        
        func objectForKey(dictionary: NSDictionary, key: String) throws -> AnyObject {
            guard let result = dictionary[key] else {
                let info = DecodingError.Info(object: dictionary, rootObject: json, path: currentPath)
                throw DecodingError.MissingKey(key: key, info: info)
            }
            return result
        }
        
        for key in path {
            currentDict = try NSDictionary(json: objectForKey(currentDict, key: key))
            currentPath.append(key)
        }
        
        
        
        object = try objectForKey(currentDict, key: lastKey)
    }
    
    return try catchAndRethrow(json, path) { try decode(object) }
    
}

public func parse<T>(json: AnyObject, path: [String], decode: (AnyObject throws -> T?)) throws -> T? {
    var object = json
    if let currentDict = try? NSDictionary(json: json) {
        guard let objectForKeyPath = try currentDict.objectForKeyPath(path) else {
            return nil
        }
        object = objectForKeyPath
    }
    return try catchAndRethrow(json, path) { try decode(object) }
}


extension NSDictionary {
    func objectForKeyPath(path: [AnyObject]) throws -> AnyObject? {
        // if path is empty - return nil
        guard path.isEmpty == false else {
            return nil
        }
        
        // if path is one key long - return an object for the key (might be nil)
        if path.count == 1, let key = path.first {
            return objectForKey(key)
        }
        
        // if path contain more than one key - get an object for the first key and create remaining path by removing the first key
        var remainingPath = path
        let firstKey = remainingPath.removeFirst()
        // if there is no object for key - return nil
        guard let remainingObject = objectForKey(firstKey) else {
            return nil
        }
        
        // decode object - will throw if it is not a dictionary
        let remainingDict = try NSDictionary(json: remainingObject)
        // run recursively on remaining dictionary with remaining path
        return try remainingDict.objectForKeyPath(remainingPath)
    }
}


// MARK: - Helpers

func catchAndRethrow<T>(json: AnyObject, _ path: [String], block: Void throws -> T) throws -> T {
    do {
        return try block()
    } catch var error as DecodingError {
        error.info.path = path + error.info.path
        error.info.rootObject = json
        throw error
    } catch let error {
        throw error
    }
}