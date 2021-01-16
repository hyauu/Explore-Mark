//
//  MapViewController.swift
//  Explore&Mark
//
//  Created by 邱浩庭 on 14/1/2021.
//

import UIKit
import MapKit
import CoreLocation
import CoreData


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
            print(error ?? "Fail to get object property for unkown reason") // print the error in the background
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
        
        // update data to the CoreData if not exist
        let fetechRequest: NSFetchRequest<Place> = Place.fetchRequest()
        fetechRequest.predicate = NSPredicate(format: "xid == %@", data.xid)
        do {
            let results = try DataController.shared.viewContext.fetch(fetechRequest)
            let newAnnotation = MKPointAnnotationWithPlace()
            if results.count == 0 {
                let place = Place(context: DataController.shared.viewContext)
                place.kinds = data.kinds ?? "kind is currently unkown"
                place.lat = data.point.lat
                place.lon = data.point.lon
                place.name = data.name
                place.xid = data.xid
                place.wikiDescription = data.wikiPediaExtracts.text
                do {
                    try DataController.shared.viewContext.save()
                    newAnnotation.place = place
                } catch {
                    print("Failed to store object property to CoreData for \(error.localizedDescription)")
                }
            } else {
                newAnnotation.place = results[0]
            }
            // update mapView pin
            newAnnotation.coordinate = CLLocationCoordinate2D(latitude: data.point.lat, longitude: data.point.lon)
            newAnnotation.title = data.name
            newAnnotation.subtitle = data.kinds ?? "kind is currently unkown"
            
            mapView.addAnnotation(newAnnotation)
        } catch {
            print("Fetch Place error for \(error.localizedDescription)")
        }
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
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView?.image = UIImage(named: "icons8-map-pin-24")
            pinView?.canShowCallout = true
            pinView?.tintColor = .lightGray
            pinView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        } else {
            pinView?.annotation = annotation
        }

        return pinView
    }

    
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
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let detailVC = self.storyboard?.instantiateViewController(identifier: "placeDetailVC") as! PlaceDetailViewController
            let annotation = view.annotation as! MKPointAnnotationWithPlace
            detailVC.place = annotation.place
            self.present(detailVC, animated: true, completion: nil)
        }
    }
}
