//
//  SignUp.swift
//  RecipeApp
//
//  Created by (s) Marcus Gardner on 18/02/2018.
//  Copyright © 2018 (s) Marcus Gardner. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class SignUp: UIViewController {

    @IBOutlet weak var lblBlank: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        lblBlank.isHidden = true
        
        // Do any additional setup after loading the view.
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPass: UITextField!
    
    
    @IBAction func btnSignUp(_ sender: Any) {
        if let email = txtEmail.text, let pass = txtPass.text{
            Auth.auth().createUser(withEmail: email, password: pass, completion: { (correctEmail, error) in
                if correctEmail != nil {
                } else {
                    self.lblBlank.isHidden = false
                }
            })
        }
        
        
        /* if (the user email and pass is correct){
         sign them in
         }else{
         regect them with a nice little message.
         }
         */
    }
    
   


}
