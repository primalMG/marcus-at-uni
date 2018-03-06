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
                    let alert = UIAlertController(title: "Sign up Successful!", message: "You have sucessfully signed up to Marcus at Uni", preferredStyle: .alert)
                    let OKAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {
                        (_)in
                        self.performSegue(withIdentifier: "unwindSegue", sender: self)
                    })
                    alert.addAction(OKAction)
                    self.present(alert, animated: true, completion: nil)
                } else {
                    self.lblBlank.isHidden = false
                }
            })
        }
    }


}
