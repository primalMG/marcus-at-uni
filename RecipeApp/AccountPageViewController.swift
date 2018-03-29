//
//  Account Page.swift
//  RecipeApp
//
//  Created by (s) Marcus Gardner on 13/02/2018.
//  Copyright © 2018 (s) Marcus Gardner. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseAuth
import FirebaseFacebookAuthUI

class AccountPageViewController: UIViewController {

    @IBOutlet weak var lblFalse: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        lblFalse.isHidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtPass: UITextField!
  
    @IBAction func btnForgotPass(_ sender: Any) {
            //send the user an email... with a link to allow them to reset pass
    }
    
  
    @IBAction func btnlogin(_ sender: Any) {
        if let email = txtUsername.text, let pass = txtPass.text{
            Auth.auth().signIn(withEmail: email, password: pass, completion: { (emailExists, Error) in
                if emailExists != nil{
                    let alert = UIAlertController(title: "Login Successful", message: "Successfully logged in", preferredStyle: .alert)
                    let OkAction = UIAlertAction(title: "Aight Boom", style: UIAlertActionStyle.default, handler:{
                        (_) in
                        self.performSegue(withIdentifier: "unwindSegue", sender: self)
                    })
                    alert.addAction(OkAction)
                    self.present(alert, animated: true, completion: nil)
                }else{
                    self.lblFalse.isHidden = false
                }
            })
        }
    }
    
    
 
    
}
