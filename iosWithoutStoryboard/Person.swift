//
//  Person.swift
//  iosWithoutStoryboard
//
//  Created by quan bui on 2021/05/09.
//

import Foundation

struct Person : Codable {
    var firstname: String
    var lastname: String = "***" // This property will not be encode/decode because it not included in enum CodingKeys.
    var yob: String
    var team: String

    enum CodingKeys: String, CodingKey {
        case firstname
//        case lastname
        case yob
        case team
    }
}
