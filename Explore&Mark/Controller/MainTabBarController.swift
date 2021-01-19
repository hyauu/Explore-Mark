//
//  MainTabBarController.swift
//  Explore&Mark
//
//  Created by 邱浩庭 on 14/1/2021.
//

import Foundation
import UIKit
import Firebase

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.setHidesBackButton(true, animated: false)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "icon_addpin"), style: .plain, target: self, action: #selector(addTapped))
    }
    
    @objc private func addTapped() {
        if Auth.auth().currentUser != nil {
            let newRecordVC = (self.storyboard?.instantiateViewController(identifier: "newRecordVC"))!
            self.navigationController?.pushViewController(newRecordVC, animated: true)
        } else {
            if let vc = (self.storyboard?.instantiateViewController(identifier: "signInVC") as? SignInViewController) {
                vc.signInAsGuestIsHidden = true
                self.present(vc, animated: true, completion: nil)
            }
        }
    }
}

extension MainTabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        return true
    }
}
