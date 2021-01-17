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

    @IBOutlet weak var signInAsGuest: UIButton!
    
    var signInAsGuestIsHidden: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationController?.isNavigationBarHidden = true
        GIDSignIn.sharedInstance()?.presentingViewController = self
        signInAsGuest.isHidden = signInAsGuestIsHidden
        NotificationCenter.default.addObserver(self, selector: #selector(didReceiveUserSignedIn), name: .didAuthenticated, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if Auth.auth().currentUser != nil {
            didReceiveUserSignedIn()
        }
    }
    
    @IBAction func signInAsGuest(_ sender: Any) {
        didReceiveUserSignedIn()
    }
    
    @objc private func didReceiveUserSignedIn() {
        if isModal == false {
            let vc = self.storyboard?.instantiateViewController(identifier: "mainTabBarVC")
            self.navigationController?.show(vc!, sender: self)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
}
