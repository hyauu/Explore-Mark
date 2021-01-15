//
//  Coordinate+Extension.swift
//  Explore&Mark
//
//  Created by 邱浩庭 on 14/1/2021.
//

import Foundation
import CoreData

// Extend the CLLocationCoordinate2D class to make it can be represented as Dictionary
extension CLLocationCoordinate2D: Equatable {
    private static let lat = "lat"
    private static let lon = "lon"
    
    typealias CLLocationDictionary = [String: CLLocationDegrees]
    
    var asDictionary: CLLocationDictionary {
        return [CLLocationCoordinate2D.lat: self.latitude,
                CLLocationCoordinate2D.lon: self.longitude]
    }
    
    init(dict: CLLocationDictionary) {
        self.init(latitude: dict[CLLocationCoordinate2D.lat]!, longitude: dict[CLLocationCoordinate2D.lon]!)
    }
    
    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        return (lhs.longitude == rhs.longitude) && (lhs.latitude == rhs.latitude)
    }
}
