//
//  FlickrPhotoSearchResponse.swift
//  Explore&Mark
//
//  Created by 邱浩庭 on 15/1/2021.
//

import Foundation

struct FlickrPhotoSearch: Codable {
    let photos: FlickrPhotos
    let stat: String
}
