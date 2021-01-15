//
//  OTMClient.swift
//  Explore&Mark
//
//  Created by 邱浩庭 on 15/1/2021.
//

import Foundation
import Alamofire

/**
 This class is responsible for sending OpenTripMap API request
 */
class OTMClient {
    private static let apiKey = "5ae2e3f221c38a28845f05b6091dd76d8bdafd297f2bfe6df5739ecb"
    
    enum Endpoints {
        static private let getObjectListBase = "https://api.opentripmap.com/0.1"
        
        case getObjectListByBbox(String, Int, Int, Int, Int, String, String)
        case getObjectListByRadius(String)
        
        private var stringValue: String {
            switch self {
            case .getObjectListByBbox(let lang, let lonMin, let lonMax, let latMin, let latMax, let kinds, let rate):
                return Endpoints.getObjectListBase + "/\(lang)/places/bbox?" + "lon_min=\(lonMin)&lon_max=\(lonMax)&lat_min=\(latMin)&lat_max=\(latMax)&kinds=\(kinds)&rate=\(rate)&apiKey=\(OTMClient.apiKey)"
            case .getObjectListByRadius(let lang):
                return Endpoints.getObjectListBase + "/\(lang)/places/radius"
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
    class func getObjectsByRadius(lang: String, radius: Double, lon: Double, lat: Double, format: String = "json", kinds: String = "interesting_places", rate: String?) {
        let headers: HTTPHeaders = [
            .accept("application/json")
        ]
        
        var parameters: [String: Any] = [
            "radius": radius,
            "lon": lon,
            "lat": lat,
            "kinds": kinds,
            "format": format,
            "apikey": apiKey
        ]
        
        if let rate = rate {
            parameters["rate"] = rate
        }
        
        AF.request(Endpoints.getObjectListByRadius("en").url, method: .get, parameters: parameters, headers: headers).validate().responseDecodable(of: [OTMObject].self) { (response) in
            switch response.result {
            case .success:
                print(response.value)
            case .failure:
                print(response.debugDescription)
            }
        }
    }
    
    
    
    
    // get object lists by boundary box
//    class func getObjectListByBbox(lang: String, lonMin: Int, lonMax: Int, latMin: Int, latMax:Int, kinds: String, rate: String) {
//        let url = Endpoints.getObjectListByBbox(lang, lonMin, lonMax, latMin, latMax, kinds, rate)
//
//    }
}
