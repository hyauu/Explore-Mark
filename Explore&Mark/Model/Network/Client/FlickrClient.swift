//
//  FlickrClient.swift
//  Explore&Mark
//
//  Created by 邱浩庭 on 15/1/2021.
//

import Foundation
import Alamofire
/**
 This class is responsible for sending Flickr API request
 */

class FlickrClient {
    private static let apiKey = "7ad2a920214efc1137227ac4017957f2"
    private static let secret = "73e64d4be25ec5e1"
    
    enum Endpoints {
        private static let baseURL = "https://www.flickr.com/services/rest/"
        private static let imageBaseURL = "https://live.staticflickr.com/" // url for download iamge file
        
        case searchPhotos
        case downloadImage
        
        private var stringValue: String {
            switch self {
            case .searchPhotos:
                return Endpoints.baseURL
            default:
                return Endpoints.imageBaseURL
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
    // Search photos information associate with specific place
    class func searchForPhotos(place: Place) {
        let paramters: [String: Any] = ["method": "flickr.photos.search",
                         "api_key": apiKey,
                         "lat": place.lat,
                         "lon": place.lon,
                         "format": "json",
                         "nojsoncallback": 1,
                         "page": Int(arc4random_uniform(UInt32(20))) % 20
        ]
        
        
    }
}
