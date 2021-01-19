//
//  NewRecordViewController.swift
//  Explore&Mark
//
//  Created by 邱浩庭 on 14/1/2021.
//

import UIKit
import Firebase
import Foundation
import CoreData

class NewRecordViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleText: UITextField!
    @IBOutlet weak var blankLine: UIView!
    @IBOutlet weak var textView: UITextView!
    
    var lat: Double!
    var lon: Double!
    var icon: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        blankLine.backgroundColor = .darkGray
        // Do any additional setup after loading the view.
        
        lat = (UserDefaults.standard.value(forKey: "centerDict") as! CLLocationCoordinate2D.CLLocationDictionary)["lat"]
        lon = (UserDefaults.standard.value(forKey: "centerDict") as! CLLocationCoordinate2D.CLLocationDictionary)["lon"]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.setHidesBackButton(false, animated: false)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "PUBLISH", style: .done, target: self, action: #selector(publishTapped))
        self.navigationItem.title = "Add Mark"
        OWClient.getWeatherByCoordinate(lon: lon, lat: lat, completion: handleGetWeatherResponse(data:error:))
    }
    
    @objc private func publishTapped() {
        let keyValue = AppData.ref.child(Auth.auth().currentUser!.uid).child("posts").childByAutoId().key
        let data: [String: Any] = [
            "title": titleText.text!,
            "content": textView.text!,
            "lon": lon!,
            "lat": lat!,
            "icon": icon!,
            "postId": keyValue
        ]
        
        AppData.ref.child(Auth.auth().currentUser!.uid).child("posts/\(String(describing: keyValue))").setValue(data)
        self.navigationController?.popViewController(animated: true)
    }
    
    private func handleGetWeatherResponse(data: CurrentWeatherData?, error: Error?) {
        guard let data = data else {
            print("Get weather fail \(error!.localizedDescription)")
            return
        }
        
        icon = data.weather[0].icon
        OWClient.downloadImageByIcon(iconId: icon!, completion: handleDownLoadWeatherIconResposne(data:error:))
    }
    
    private func handleDownLoadWeatherIconResposne(data: UIImage?, error: Error?) {
        guard let data = data else {
            print("Download icon image failed \(error!.localizedDescription)")
            return
        }
        
        imageView.image = data
    }
}
