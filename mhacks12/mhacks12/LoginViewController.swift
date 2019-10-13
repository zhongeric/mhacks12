//
//  LoginViewController.swift
//  mhacks12
//
//  Created by Eric Zhong on 10/12/19.
//  Copyright © 2019 ericzhong. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseUI

class LoginViewController: UIViewController {
//    @IBOutlet weak var avatarImage: UIImageView!
    
    @IBOutlet weak var loginBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        FUIAuth.defaultAuthUI()?.auth?.addStateDidChangeListener { auth, user in
          if user != nil {
            // User is signed in. Show home screen
            print("already signed in")
            self.performSegue(withIdentifier: "toMain", sender: self)
          } else {
            // No User is signed in. Show user the login screen
            print("not signed in")
//            self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
//            self.navigationController?.popToRootViewController(animated: true)
            self.view.window?.rootViewController?.presentedViewController?.dismiss(animated: true, completion: nil)

            print("returned to root")

          }
        }
    }
    
    func dismissViewControllers() {

        guard let vc = self.presentingViewController else { return }

        while (vc.presentingViewController != nil) {
            vc.dismiss(animated: true, completion: nil)
        }
    }

    
    
    @IBAction func loginTapped(_ sender: Any) {
         // Get default auth UI object
        let authUI = FUIAuth.defaultAuthUI()
        guard authUI != nil else {
            // log the error
            return
        }
        
        authUI?.delegate = self
        let providers = [FUIEmailAuth()]

        authUI?.providers = providers
        
        let authViewController = authUI!.authViewController()
        present(authViewController, animated: true, completion: nil)
        
    }
}

extension LoginViewController: FUIAuthDelegate {
    func authUI(_ authUI: FUIAuth, didSignInWith authDataResult: AuthDataResult?, error: Error?) {
        
        // Check if there was an error
        guard error == nil else {
            // log error
            return
        }
        
        // authDataResult?.user.uid - To get UID
        
        performSegue(withIdentifier: "toMain", sender: self)
    }
}



