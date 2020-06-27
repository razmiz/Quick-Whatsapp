//
//  Country.swift
//  Clipboard Test
//
//  Created by Raz on 06/06/2020.
//  Copyright © 2020 Raz. All rights reserved.
//

import Foundation

struct Countries: Codable {
    let countries: [Country]
}
//
//struct Country: Codable {
//    let code, name: String
//}

struct Country: Codable {
    let name, dialCode, code: String

    enum CodingKeys: String, CodingKey {
        case name
        case dialCode = "dial_code"
        case code
    }
}
