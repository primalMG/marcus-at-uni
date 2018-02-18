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

class AccountPage: UIViewController {
    
    
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
            
    }
    
    @IBOutlet weak var btnLogin: UIButton!

    
}
