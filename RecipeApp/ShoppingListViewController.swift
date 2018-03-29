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
    
    var ref: DatabaseReference!
    var databaseHandle: DatabaseHandle!
    var ingredientsArray: [String] = []
    let currUser = Auth.auth().currentUser?.uid
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        <#code#>
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        <#code#>
//    }
    
    
    @IBAction func btnAddIng(_ sender: Any) {
        
    }
    



}
