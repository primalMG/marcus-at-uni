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

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
     
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
                    //let a brother know he's good.
                }else{
                    //let a brother know he's bad.
                }
            })
        }
    }
    
    
 
    
}
