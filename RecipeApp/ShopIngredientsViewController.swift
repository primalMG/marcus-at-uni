//
//  ShopIngredientsViewController.swift
//  RecipeApp
//
//  Created by Marcus Gardner on 25/04/2018.
//  Copyright © 2018 (s) Marcus Gardner. All rights reserved.
//

import UIKit
import Firebase

class ShopIngredientsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var shopID : String!
    var ingredients: [String] = []
    var ref : DatabaseReference!
    var databaseHandle : DatabaseHandle!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.ref = Database.database().reference()
        tableView.delegate = self
        tableView.dataSource = self
        
        self.ref.child("ShopLocation").child(shopID).child("List").observeSingleEvent(of:  DataEventType.value, with: { (snapshot) in
        print(snapshot)
        for child in snapshot.children {
            let dictionary = child as! DataSnapshot
            self.ingredients.append(dictionary.value as! String)
        }
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        })
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ingredients.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = ingredients[indexPath.row]
        
        return cell

    }

 

}
