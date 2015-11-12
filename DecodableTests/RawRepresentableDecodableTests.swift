//
//  RawRepresentableDecodableTests.swift
//  Decodable
//
//  Created by Daniel Garbień on 06/11/15.
//  Copyright © 2015 anviking. All rights reserved.
//

import XCTest
@testable import Decodable

enum CMYKColor: String, JSONInitiable {
    case Cyan = "Cyan"
    case Magenta = "Magenta"
    case Yellow = "Yellow"
    case Black = "Black"
}

class RawRepresentableDecodableTests: XCTestCase {
    
    func testDecodingCorrectRawRepresentableValueSucceed() {
        // given
        let key = "color"
        let color = "Cyan"
        let json: NSDictionary = [key: color]
        // when
        let cmykColor: CMYKColor = try! json => key
        // then
        XCTAssertEqual(cmykColor, CMYKColor.Cyan)
    }
    
    func testDecodingIncorrectRawRepresentableValueFail() {
        // given
        let key = "color"
        let color = "Green"
        let json: NSDictionary = [key: color]
        // when
        do {
            try json => key as CMYKColor
            XCTFail()
        } catch DecodingError.UnexpectedValue(_, let info) {
            // then
            XCTAssertNotNil(info.object)
        } catch {
            XCTFail("should not throw \(error)")
        }
    }
    
    func testDecodingIncorrectRawRepresentableTypeFail() {
        // given
        let key = "color"
        let color = 0
        let json: NSDictionary = [key: color]
        // when
        do {
            try json => key as CMYKColor
            XCTFail()
        } catch DecodingError.TypeMismatch(_, CMYKColor.RawValue.self, let info) {
            // then
            XCTAssertNotNil(info.object)
        } catch {
            XCTFail("should not throw \(error)")
        }
    }
}
