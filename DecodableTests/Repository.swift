//
//  RepositoryExample.swift
//  Decodable
//
//  Created by Fran_DEV on 13/07/15.
//  Copyright © 2015 anviking. All rights reserved.
//

import Foundation
@testable import Decodable

struct Owner {
    let id: Int
    let login: String
}

struct Repository {
    let id: Int
    let name: String
    let description: String
    let htmlUrlString : String
    let owner: Owner // Struct conforming to Decodable
    let coverage: Double
    let files: Array<String>
    let optional: String?
    let active: Bool
    let optionalActive: Bool?
}

extension Owner : JSONInitiable {
    init(json: AnyObject) throws {
        self = try Owner(
            id: json => "id",
            login: json => "login"
        )
    }
}

extension Repository : JSONInitiable {
    init(json: AnyObject) throws {
        self = try Repository(
            id: json => "id",
            name: json => "name",
            description: json => "description",
            htmlUrlString : json => "html_url",
            owner: json => "owner",
            coverage: json => "coverage",
            files: json => "files",
            optional: json => "optional",
            active: json => "active",
            optionalActive: json => "optionalActive"
        )
    }
}

// MARK: Equatable

func == (lhs: Owner, rhs: Owner) -> Bool {
    return lhs.id == rhs.id && lhs.login == rhs.login
}

extension Owner: Equatable {
    var hashValue: Int { return id.hashValue }
}

func == (lhs: Repository, rhs: Repository) -> Bool {
    return lhs.id == rhs.id &&
    lhs.name == rhs.name &&
    lhs.description == rhs.description &&
    lhs.htmlUrlString == rhs.htmlUrlString &&
    lhs.owner == rhs.owner &&
    lhs.coverage == rhs.coverage &&
    lhs.files == rhs.files &&
    lhs.optional == rhs.optional &&
    lhs.active == rhs.active &&
    lhs.optionalActive == rhs.optionalActive
}

extension Repository: Equatable {
    var hashValue: Int { return id.hashValue }
}