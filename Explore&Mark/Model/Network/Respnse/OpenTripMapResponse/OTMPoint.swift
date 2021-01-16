//
//  OTMPoint.swift
//  Explore&Mark
//
//  Created by 邱浩庭 on 15/1/2021.
//

import Foundation

/**
 Respnse Example:
     "point": {
       "lon": 104.666351,
       "lat": 51.995689
     }
 */

struct OTMPoint: Codable {
    let lon: Double
    let lat: Double
}
