//
//  TableViewController.swift
//  Explore&Mark
//
//  Created by 邱浩庭 on 14/1/2021.
//

import UIKit
import Firebase

class TableViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var userData: [Any] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationController?.isNavigationBarHidden = false
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        if (Auth.auth().currentUser != nil) {
            let ref = AppData.ref.child("\(Auth.auth().currentUser!.uid)/posts")
            ref.observe(.value) { (snapshot) in
                if let userDict = snapshot.value as? [String: Any] {
                    self.userData = Array(userDict.values)
                    self.tableView.reloadData()
                }
            }
        }
    }
}

extension TableViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: "recordCell")
        cell?.textLabel?.text = (userData[indexPath.row] as! [String: Any])["title"] as? String
        cell?.detailTextLabel?.text = (userData[indexPath.row] as! [String: Any])["content"] as? String
        let icon = (userData[indexPath.row] as! [String: Any])["icon"] as! String
        OWClient.downloadImageByIcon(iconId: icon, completion: { (data, error) in
            guard let data = data else {
                return
            }
            cell?.imageView?.image = data
        })
        return cell!
    }
    
}
