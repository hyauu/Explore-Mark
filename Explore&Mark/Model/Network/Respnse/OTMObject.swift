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
      }
 
     {
         "xid": "Q44634921",
         "name": "State Theatre",
         "dist": 55.75666565,
         "rate": 1,
         "wikidata": "Q44634921",
         "kinds": "architecture,historic_architecture,cinemas,cultural,theatres_and_entertainments,interesting_places,destroyed_objects",
         "point": {
           "lon": -122.405785,
           "lat": 37.785782
         }
       }
 */
struct OTMObject: Codable {
    let xid: String
    let name: String
    let rate: Int
    let osm: String? // property of reponse for object lists by bbox
    let wikiData: String?
    let kinds: String
    let point: OTMPoint
    let dist: Double? // property of reponse for object lists by radius
    
    enum CodingKeys: String, CodingKey {
        case xid
        case name
        case rate
        case osm
        case wikiData = "wikidata"
        case point
        case kinds
        case dist
    }
}
