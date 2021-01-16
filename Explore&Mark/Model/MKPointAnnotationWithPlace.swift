//
//  MKPointAnnotationWithPlace.swift
//  Explore&Mark
//
//  Created by 邱浩庭 on 16/1/2021.
//

import Foundation
import MapKit

/**
 Subclass to MKPointAnnotation so that it can store xid
 */

class MKPointAnnotationWithPlace: MKPointAnnotation {
    var place: Place?
}
