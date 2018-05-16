//
//  AccountSettingsViewController.swift
//  RecipeApp
//
//  Created by (s) Marcus Gardner on 18/04/2018.
//  Copyright © 2018 (s) Marcus Gardner. All rights reserved.
//

import UIKit
import Firebase

class AccountSettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func btnLogout(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        
        do {
            try firebaseAuth.signOut()
            let alert = UIAlertController(title: "Logout Successful", message: "Successfully logged in", preferredStyle: .alert)
            let OkAction = UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler:{
                (_) in
                self.performSegue(withIdentifier: "accountSettingsUnwind", sender: self)
            })
            alert.addAction(OkAction)
            self.present(alert, animated: true, completion: nil)
            
        } catch let error as NSError {
            print("error signing out", error)
        }
    }
    
    @IBAction func btnChangeEmail(_ sender: Any) {
        let changeEmailAlert = UIAlertController(title: "Change Email", message: nil, preferredStyle: .alert)
        changeEmailAlert.addTextField { (textField) in
            textField.placeholder = "New Email"
        }
        changeEmailAlert.addAction(UIAlertAction(title: "Okay", style: .default, handler: { (action) in
            let changeEmail = changeEmailAlert.textFields?.first?.text
            Auth.auth().currentUser?.updateEmail(to: changeEmail!, completion: { (error) in
                if error != nil {
                    print("email change failed")
                } else {
                    print("email changed worked.")
                }
            })
        }))
    }
    
    @IBAction func btnChangePassword(_ sender: Any) {

        let changePasswordAlert = UIAlertController(title: "Change Password", message: nil, preferredStyle: .alert)
//        changePasswordAlert.addTextField { (textField) in
//            textField.placeholder = "Current Password"
//        }
        changePasswordAlert.addTextField { (textField) in
            textField.placeholder = "New Password"
        }
        changePasswordAlert.addAction(UIAlertAction(title: "Okay", style: .default, handler: { (action) in
            let changePassword = changePasswordAlert.textFields?.first?.text
            Auth.auth().currentUser?.updatePassword(to: changePassword!, completion: { (error) in
                if error != nil {
                    print("password change fail")
                } else {
                    print("passwor changed")
                }
            })
        }))
        self.present(changePasswordAlert, animated: true, completion: nil)
        
    }

 
}
