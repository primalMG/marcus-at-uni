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
import FirebaseDatabase

class SignUpViewController: UIViewController {

    @IBOutlet weak var lblBlank: UILabel!
    var database: DatabaseHandle!
    var ref: DatabaseReference!
    
    
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
        ref = Database.database().reference()
        let userID = Auth.auth().currentUser?.uid
        
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
                    self.ref.child("users").child(userID!).setValue(["username": self.txtUsername.text])
                } else {
                    self.lblBlank.isHidden = false
                    print("email \(String(describing: email)) or password \(String(describing: pass)) is empty")
                }
            })
        }
    }


}
