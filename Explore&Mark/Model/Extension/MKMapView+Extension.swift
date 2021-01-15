//
//  MKMapView+Extension.swift
//  Explore&Mark
//
//  Created by 邱浩庭 on 15/1/2021.
//

import Foundation
import MapKit

// Extend the MKMapView to make it support radius calculation
extension MKMapView {
    var topLeftCoordinate: CLLocationCoordinate2D {
        return convert(CGPoint.zero, toCoordinateFrom: self) // the top left coordinate
    }
    
    var radius: CLLocationDistance {
        let centerLocation = CLLocation(latitude: centerCoordinate.latitude, longitude: centerCoordinate.longitude)
        let topLeftLocation = CLLocation(latitude: topLeftCoordinate.latitude, longitude: topLeftCoordinate.longitude)
        return centerLocation.distance(from: topLeftLocation)
    }
    
}
