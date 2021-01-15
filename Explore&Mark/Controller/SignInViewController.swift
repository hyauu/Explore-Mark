//
//  SignInViewController.swift
//  Explore&Mark
//
//  Created by 邱浩庭 on 13/1/2021.
//

import UIKit
import Firebase
import GoogleSignIn

class SignInViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationController?.isNavigationBarHidden = true
        GIDSignIn.sharedInstance()?.presentingViewController = self
    }
    
}

