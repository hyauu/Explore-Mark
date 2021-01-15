//
//  OTMBbox.swift
//  Explore&Mark
//
//  Created by 邱浩庭 on 15/1/2021.
//

import Foundation
// Minimum bounding box for the object geometry
struct OTMBbox: Codable {
    let lonMin: Double?
    let lonMax: Double?
    let latMin: Double?
    let latMax: Double?
    
    enum CodingKeys: String, CodingKey {
        case lonMin = "lon_min"
        case lonMax = "lon_max"
        case latMin = "lat_min"
        case latMax = "lat_max"
    }
}

