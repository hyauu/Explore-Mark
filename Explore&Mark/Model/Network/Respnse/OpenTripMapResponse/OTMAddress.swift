//
//  OTMAddress.swift
//  Explore&Mark
//
//  Created by 邱浩庭 on 15/1/2021.
//

import Foundation

struct OTMAddress: Codable {
    let city: String
    let road: String
    let state: String
    let county: String
    let country: String
    let postcode: String
    let countryCode: String
    let houseNumber: String
    let neighbourhood: String
    
    enum CodingKeys: String, CodingKey {
        case city
        case road
        case state
        case county
        case country
        case postcode
        case countryCode = "country_code"
        case houseNumber = "house_number"
        case neighbourhood
    }
}
