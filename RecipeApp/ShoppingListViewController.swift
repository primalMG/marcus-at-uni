//
//  ShoppingListViewController.swift
//  RecipeApp
//
//  Created by (s) Marcus Gardner on 08/03/2018.
//  Copyright © 2018 (s) Marcus Gardner. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class ShoppingListViewController: UIViewController{
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var txtIngredient: UITextField!
    
    var ref: DatabaseReference!
    var databaseHandle: DatabaseHandle!
    var ingredientsArray: [String] = []
    let currUser = Auth.auth().currentUser?.uid
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        // Do any additional setup after loading the view.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func btnAddIng(_ sender: Any) {
        let ingKey = ref.child("user").child(self.currUser!).child("ShoppingList").childByAutoId().key
        Auth.auth().addStateDidChangeListener { (auth, user) in
            if self.currUser != nil {
                self.ref.child("user").child(self.currUser!).child("ShoppingList").setValue(["\(ingKey)" : self.txtIngredient.text])
            }else {
                //redirect to login page...
            }
        }
    }
    
    @IBAction func unwindToShoppingList(_ sender: UIStoryboardSegue){
        
    }


}
