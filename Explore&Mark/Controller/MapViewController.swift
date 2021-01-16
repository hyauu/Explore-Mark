//
//  MapViewController.swift
//  Explore&Mark
//
//  Created by 邱浩庭 on 14/1/2021.
//

import UIKit
import MapKit
import CoreLocation


class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    var locationManager: CLLocationManager!
    var pressGestureRecoginzer: UILongPressGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        mapView.delegate = self
        
        // long press on the map to reset region
        pressGestureRecoginzer = UILongPressGestureRecognizer(target: self, action: #selector(resetRegion))
        mapView.addGestureRecognizer(pressGestureRecoginzer)
        
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
        }
        // init the map region
        initMapRegion()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @IBAction func getUserLocationTapped(_ sender: Any) {
        resetRegion()
    }
    
    //Reset map region to userLocation
    @objc private func resetRegion() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
        }
        
        let latDelta = AppData.defaultLatDelta
        let lonDelta = AppData.defaultLonDelta
        UserDefaults.standard.setValue(AppData.defaultLatDelta, forKey: "latDelta")
        UserDefaults.standard.setValue(AppData.defaultLonDelta, forKey: "lonDelta")
        if let loc = AppData.userLocation {
            updateMapRegion(location: loc, latDelta: latDelta, lonDelta: lonDelta)
        }
        
    }
    
    // Configure the map region
    private func initMapRegion() {
        let center = ((UserDefaults.standard.value(forKey: "centerDict") ?? AppData.userLocation?.asDictionary) ?? mapView.region.center.asDictionary)
        let latDelta = (UserDefaults.standard.value(forKey: "latDelta") ?? AppData.defaultLatDelta) as! Double
        let lonDelta = (UserDefaults.standard.value(forKey: "lonDelta") ?? AppData.defaultLonDelta) as! Double
        
        updateMapRegion(location: CLLocationCoordinate2D(dict: center as! CLLocationCoordinate2D.CLLocationDictionary), latDelta: latDelta, lonDelta: lonDelta)
    }
    
    // Update the Map Center Location and Zoom level
    private func updateMapRegion(location: CLLocationCoordinate2D, latDelta: Double, lonDelta: Double) {
        let center = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: lonDelta))
        mapView.setRegion(region, animated: true)
    }
    
    func handleGetObjectListByRadiusReponse(data: [OTMObject]?, error: Error?) {
        guard let data = data else {
            if let error = error {
                showNetworkFailedAlert(title: "Get Object list Failed", message: error.localizedDescription)
                print(error)
            } else {
                showNetworkFailedAlert(title: "Get Object list Failed", message: "Fetch data failed for unkown reason")
            }
            return
        }
        
        //get the property for each object
        print("Number of object nearby: \(data.count)")
        for res in data {
            OTMClient.getObjectPerpertyByXid(xid: res.xid, completion: handleGetObjectPropoertyByXidResponse(data:error:))
        }
    }
    
    func handleGetObjectPropoertyByXidResponse(data: OTMObjectProperty?, error: Error?) {
        guard let data = data else {
            print(error ?? "Fail to get object property for unkown reason") // print the error in the background
            return
        }
        
        // update data to the CorData (todo)
        print(data)
    }
    
    func showNetworkFailedAlert(title: String, message:String) {
        DispatchQueue.main.async {
            let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alertVC, animated: true, completion: nil)
        }
    }
}

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let locations = locations.first {
            locationManager.stopUpdatingLocation()
            AppData.userLocation = locations.coordinate
        }
    }
}

extension MapViewController: MKMapViewDelegate {
    // Update map region to permanent store
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        
        // store the current map region
        let center = mapView.region.center
        let latDelta = mapView.region.span.latitudeDelta
        let lonDelta = mapView.region.span.longitudeDelta
        
        UserDefaults.standard.setValue(center.asDictionary, forKey: "centerDict")
        UserDefaults.standard.setValue(latDelta, forKey: "latDelta")
        UserDefaults.standard.setValue(lonDelta, forKey: "lonDelta")
        
        // get attraction spots nearby
        OTMClient.getObjectsByRadius(lang: "en", radius: mapView.radius, lon: mapView.centerCoordinate.longitude, lat: mapView.centerCoordinate.latitude, rate: "3", completion: handleGetObjectListByRadiusReponse(data:error:))
    }
}
