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
    }

}

extension MainTabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if viewController is NewRecordViewController {
            if Auth.auth().currentUser != nil {
                print(Auth.auth().currentUser?.email)
                if let vc = self.storyboard?.instantiateViewController(identifier: "newRecordVC") {
                    self.present(vc, animated: true, completion: nil)
                }
            } else {
                if let vc = (self.storyboard?.instantiateViewController(identifier: "signInVC") as? SignInViewController) {
                    vc.signInAsGuestIsHidden = true
                    self.present(vc, animated: true, completion: nil)
                }
            }
            return false
        }
        return true;
    }
}
