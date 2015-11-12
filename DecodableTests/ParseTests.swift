//
//  ParseTests.swift
//  Decodable
//
//  Created by Daniel Garbień on 06/11/15.
//  Copyright © 2015 anviking. All rights reserved.
//

import XCTest
@testable import Decodable

class ParseTests: XCTestCase {
    
    func testObjectForKeyPathWithSingleKey() {
        // given
        let key = "key"
        let value = "value"
        let dict: NSDictionary = [key: value]
        // when
        let objectForKeyPath = try? dict.objectForKeyPath([key])
        // then
        XCTAssertEqual(objectForKeyPath as? String, value)
    }
    
    func testObjectForKeyPathWithEmptyPath() {
        // given
        let key = "key"
        let value = "value"
        let dict: NSDictionary = [key: value]
        // when
        let objectForKeyPath = try! dict.objectForKeyPath([])
        // then
        XCTAssertNil(objectForKeyPath)
    }
    
    func testObjectForKeyPathWithMultipleKeys() {
        // given
        let key1 = "key"
        let key2 = "key"
        let value = "value"
        let dict: NSDictionary = [key1: [key2: value]]
        // when
        let objectForKeyPath = try? dict.objectForKeyPath([key1,key2])
        // then
        XCTAssertEqual(objectForKeyPath as? String, value)
    }
    
    func testObjectForKeyPathWithEmptyNSDictionary() {
        // given
        let key = "key"
        let dict: NSDictionary = [:]
        // when
        let objectForKeyPath = try! dict.objectForKeyPath([key])
        // then
        XCTAssertNil(objectForKeyPath)
    }
}
