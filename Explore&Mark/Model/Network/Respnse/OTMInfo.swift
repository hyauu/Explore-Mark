//
//  OTMInfo.swift
//  Explore&Mark
//
//  Created by 邱浩庭 on 15/1/2021.
//

import Foundation

struct OTMInfo: Codable {
    let src: String?
    let srcId: Int?
    let descr: String?
    
    enum CodingKeys: String, CodingKey {
        case src
        case srcId = "src_id"
        case descr
    }
}
