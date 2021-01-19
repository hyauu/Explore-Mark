//
//  OWClient.swift
//  Explore&Mark
//
//  Created by 邱浩庭 on 18/1/2021.
//

import Foundation
import Alamofire

// OpenWeather Client
// api.openweathermap.org/data/2.5/weather?lat={lat}&lon={lon}&appid={API key}
class OWClient {
    private static let apiKey = "7537020ade7eecea2b47f5f9eee38294"
    
    enum Endpoints {
        private static let curretnWeatherBase = "http://api.openweathermap.org/data/2.5/weather"
        private static let weatherIconBase = "http://openweathermap.org/img/wn/"
        
        case getWeatherByCoordinate
        case getWeatherIconImage(String)
        
        var stringValue: String {
            switch self {
            case .getWeatherByCoordinate:
                return Endpoints.curretnWeatherBase
            case .getWeatherIconImage(let iconId):
                return Endpoints.weatherIconBase + "/\(iconId).png"
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
    class func getWeatherByCoordinate(lon: Double, lat: Double, completion: @escaping (CurrentWeatherData?, Error?) -> Void) {
        let headers: HTTPHeaders = [
            .accept("application/json")
        ]
        let parameters: [String: Any] = [
            "lon": lon,
            "lat": lat,
            "appid": apiKey
        ]
        
        AF.request(Endpoints.getWeatherByCoordinate.url, method: .get, parameters: parameters, headers: headers).responseDecodable(of: CurrentWeatherData.self) { (response) in
            switch response.result {
            case .success:
                completion(response.value!, nil)
            case .failure:
                completion(nil, response.error!)
            }
        }
    }
    
    class func downloadImageByIcon(iconId: String, completion: @escaping (UIImage?, Error?) -> Void) {
        let headers: HTTPHeaders = [
            .accept("application/json")
        ]
        
        AF.request(Endpoints.getWeatherIconImage(iconId).url, method: .get, headers: headers).responseData { (response) in
            switch response.result {
            case .success:
                completion(UIImage(data: response.value!)!, nil)
            case .failure:
                completion(nil, response.error!)
            }
        }
    }
}
