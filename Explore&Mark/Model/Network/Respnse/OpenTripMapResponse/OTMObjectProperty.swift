//
//  OTMObjectProperty.swift
//  Explore&Mark
//
//  Created by 邱浩庭 on 15/1/2021.
//

import Foundation

struct OTMObjectProperty: Codable {
    let xid: String
    let name: String
    let kinds: String?
    let osm: String?
    let wikiData: String?
    let rate: String?
    let image: String?
    let preview: OTMPreview?
    let wikiPedia: String?
    let wikiPediaExtracts: OTMWikiPediaExtracts
    let voyage: String?
    let url: String?
    let otm: String?
    let point: OTMPoint
    let sources: OTMObjectSource?
    let info: OTMInfo?
    let bbox: OTMBbox?
    let address: OTMAddress?
    
    enum CodingKeys: String, CodingKey {
        case xid
        case name
        case kinds
        case osm
        case wikiData = "wikidata"
        case rate
        case image
        case preview
        case wikiPedia = "wikipedia"
        case wikiPediaExtracts = "wikipedia_extracts"
        case voyage
        case url
        case otm
        case point
        case sources
        case info
        case bbox
        case address
    }
}
