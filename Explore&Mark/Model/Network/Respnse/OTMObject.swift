//
//  OTMObject.swift
//  Explore&Mark
//
//  Created by 邱浩庭 on 15/1/2021.
//

import Foundation

/**
 Response Example:
 {
    "xid": "W146079278",
    "name": "Talzy Museum",
    "rate": 7,
    "osm": "way/146079278",
    "wikidata": "Q2391061",
    "kinds": "museums,cultural,interesting_places,local_museums",
    "point": {
      "lon": 104.666351,
      "lat": 51.995689
    }
 */
struct OTMObject: Codable {
    let xid: String
    let name: String
    let rate: Int
    let osm: String
    let wikiData: String
    let kinds: String
    let point: OTMPoint
    
    enum CodingKeys: String, CodingKey {
        case xid
        case name
        case rate
        case osm
        case wikiData = "wikidata"
        case kinds
        case point
    }
}
