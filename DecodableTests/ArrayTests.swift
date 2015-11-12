//
//  ArrayTests.swift
//  Decodable
//
//  Created by Johannes Lund on 2015-07-19.
//  Copyright © 2015 anviking. All rights reserved.
//

import XCTest
@testable import Decodable

class DecodableArrayTests: XCTestCase {
    
    func testDecodeAnyDecodableArraySuccess() {
        // given
        let key = "key"
        let value: NSArray = ["value1", "value2", "value3"]
        let dictionary: NSDictionary = [key: value]
        // when
        let result = try! dictionary => key as Array<String>
        // then
        XCTAssertEqual(result, value)
    }
    
    func testDecodeOptionalDecodableArraySuccess() {
        // given
        let key = "key"
        let value: NSArray = ["value1", "value2", NSNull(), "value3"]
        let dictionary: NSDictionary = [key: value]
        // when
        let result = try! dictionary => key as [String?]
        // then
        XCTAssertEqual(result.count, 4)
        XCTAssertEqual(result[0], "value1")
        XCTAssertEqual(result[1], "value2")
        XCTAssertEqual(result[2], nil)
        XCTAssertEqual(result[3], "value3")
    }
    
    func testDecodeOptionalDecodableArrayFailure() {
        // given
        let key = "key"
        let value: NSArray = ["value1", "value2", 0x8BADF00D, "value3"]
        let dictionary: NSDictionary = [key: value]
        // when
        do {
            try dictionary => key as [String?]
            XCTFail("should throw")
        } catch DecodingError.TypeMismatch {
            // Yay
        } catch {
            XCTFail("should not throw \(error)")
        }
    }
    
    func testDecodeNestedDecodableArraySuccess() {
        // given
        let key = "key"
        let value: NSArray = ["value1", "value2", "value3"]
        let dictionary: NSDictionary = [key: [key: value]]
        // when
        let result = try! dictionary => key => key as Array<String>
        // then
        XCTAssertEqual(result, value)
    }
    
    func testDecodeAnyDecodableOptionalArraySuccess() {
        // given
        let key = "key"
        let value = ["value"]
        let dictionary: NSDictionary = [key: value]
        // when
        let string = try! dictionary => key as [String]?
        // then
        XCTAssertEqual(string!, value)
    }
    
    func testDecodeAnyDecodableNestedOptionalArraySuccess() {
        // given
        let key = "key"
        let value = ["value"]
        let dictionary: NSDictionary = [key: [key: value]]
        // when
        let string = try! dictionary => key => key as [String]?
        // then
        XCTAssertEqual(string!, value)
    }
    
    func testDecodeAnyDecodableOptionalArrayNilSuccess() {
        // given
        let key = "key"
        let dictionary: NSDictionary = [key: NSNull()]
        // when
        let string = try! dictionary => key as [String]?
        // then
        XCTAssertNil(string)
    }
    
    func testDecodeAnyDecodableOptionalArrayMissingKeySuccess() {
        // given
        let key = "key"
        let dictionary = NSDictionary()
        // when
        do {
            try dictionary => key as [String]?
        } catch {
            XCTFail()
        }
    }
    
    
    // MARK: =>?
    
    func testDecodeSafeArraySuccess() {
        // given
        let key = "key"
        let value = ["A", "B", "C"]
        let dictionary: NSDictionary = [key: value]
        // when
        let array = try? [String](json: dictionary => "key")
        // then
        XCTAssertEqual(array!, value)
    }
}