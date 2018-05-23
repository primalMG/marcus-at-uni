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
import FBSDKLoginKit
import FBSDKCoreKit

class AccountPageViewController: UIViewController, FBSDKLoginButtonDelegate {

    @IBOutlet weak var lblFalse: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        lblFalse.isHidden = true
        
        let fbButton = FBSDKLoginButton()
        
        view.addSubview(fbButton)
        fbButton.readPermissions = ["email"]
        //NSLayoutConstraint.activate([fbButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100),
                                     //fbButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -100)])
        fbButton.frame = CGRect(x: 16, y: 100, width: view.frame.width - 32, height: 50)
        
        fbButton.delegate = self
        
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("logout successful")
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if error != nil {
            print(error)
        }
        print("login successful")
        fbEmail()
    }
    
    func fbEmail(){
        let accessToken = FBSDKAccessToken.current()
        guard let accessTokenString = accessToken?.tokenString else { return }
        
        let credientals = FacebookAuthProvider.credential(withAccessToken: accessTokenString)
        Auth.auth().signInAndRetrieveData(with: credientals) { (user, error) in
            if error != nil {
                print("error")
                return
            }else{
                print("auth succesful")
            }
        }
    }

    
    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtPass: UITextField!
  
    
  
    @IBAction func btnlogin(_ sender: Any) {
        let email = txtUsername.text
        let pass = txtPass.text
                Auth.auth().signIn(withEmail: email!, password: pass!, completion: { (emailExists, Error) in
                    //add a nested if loop here to get the proper error validation??
                    if emailExists != nil && (emailExists?.isEmailVerified)! {
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
    
    @IBAction func btnForgottenPassword(_ sender: Any) {
        let forgotPasswordAlert = UIAlertController(title: "Forgot password?", message: "Enter email address", preferredStyle: .alert)
        forgotPasswordAlert.addTextField { (textField) in
            textField.placeholder = "Enter email address"
        }
        forgotPasswordAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        forgotPasswordAlert.addAction(UIAlertAction(title: "Reset Password", style: .default, handler: { (action) in
            let resetEmail = forgotPasswordAlert.textFields?.first?.text
            Auth.auth().sendPasswordReset(withEmail: resetEmail!, completion: { (error) in
                if error != nil{
                    let resetFailedAlert = UIAlertController(title: "Reset Failed", message: "Error: \(String(describing: error?.localizedDescription))", preferredStyle: .alert)
                    resetFailedAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(resetFailedAlert, animated: true, completion: nil)
                }else {
                    let resetEmailSentAlert = UIAlertController(title: "Reset email sent successfully", message: "Check your email", preferredStyle: .alert)
                    resetEmailSentAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(resetEmailSentAlert, animated: true, completion: nil)
                }
            })
        }))
        //PRESENT ALERT
        self.present(forgotPasswordAlert, animated: true, completion: nil)
    }
    
    
    
 
    
}
