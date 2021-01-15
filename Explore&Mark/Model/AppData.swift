//
//  AppData.swift
//  Explore&Mark
//
//  Created by 邱浩庭 on 14/1/2021.
//

import Foundation
import Firebase
import CoreData

class AppData {
    static var ref: DatabaseReference!
    static var uid: String!
    static let defaultLatDelta = 0.1
    static let defaultLonDelta = 0.1
    static var userLocation: CLLocationCoordinate2D?
}
