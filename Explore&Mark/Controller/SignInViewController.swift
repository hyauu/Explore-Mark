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
        GIDSignIn.sharedInstance().delegate = self
    }
    
}

extension SignInViewController: GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            print("Error occurs: \(error.localizedDescription)")
            return
        }
        
        guard let authentication = user.authentication else {
            print("Authentication Failed")
            return
        }
        
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
        print("Success")
        
        Auth.auth().signIn(with: credential) { (authResult, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            AppData.uid = authResult!.user.uid
            print(AppData.uid!)
            let vc = self.storyboard?.instantiateViewController(identifier: "mainTabBarVC")
            self.navigationController!.show(vc!, sender: self)
        }
    }
    
    func signOut() {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
}

