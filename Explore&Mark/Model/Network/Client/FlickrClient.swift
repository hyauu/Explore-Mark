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
        case downloadImage(String, String, String)
        
        var stringValue: String {
            switch self {
            case .searchPhotos:
                return Endpoints.baseURL
            case .downloadImage(let photoServer, let photoId, let photoSecret):
                return Endpoints.imageBaseURL + "\(photoServer)/\(photoId)_\(photoSecret)"
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
    // Search photos information associate with specific place
    class func searchForPhotos(place: Place, perPage: Int = 15, completion: @escaping (FlickrPhotoSearch?, Error?) -> Void) {
        let paramters: [String: Any] = ["method": "flickr.photos.search",
                         "api_key": apiKey,
                         "lat": place.lat,
                         "lon": place.lon,
                         "format": "json",
                         "nojsoncallback": 1,
                         "page": Int(arc4random_uniform(UInt32(20))) % 20,
                         "per_page": perPage
        ]
        
        AF.request(Endpoints.searchPhotos.url, method: .get, parameters: paramters).validate().responseDecodable(of: FlickrPhotoSearch.self) { (response) in
            switch response.result {
            case .success:
                completion(response.value!, nil)
            case .failure:
                completion(nil, response.error!)
            }
        }
    }
    
    // Download image
    class func downloadImage(photo: FlickrPhotoInfo, size: String? = nil, completion: @escaping (UIImage?, Error?) -> Void) {
        DispatchQueue.global(qos: .userInteractive).async {
            var url = Endpoints.downloadImage(photo.server, photo.id, photo.secret).stringValue
            if let size = size {
                url += "_\(size).jpg"
            } else {
                url += ".jpg"
            }
            AF.request(url, method: .get).validate().responseData { (response) in
                switch response.result {
                case .success:
                    completion(UIImage(data: response.value!)!, nil)
                case .failure:
                    completion(nil, response.error!)
                }
            }
        }
    }
}
