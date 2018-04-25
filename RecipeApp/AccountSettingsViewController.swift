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
    
}
