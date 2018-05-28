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
        self.ref = Database.database().reference().child("ShopLocation").child(shopID).child("List")
        tableView.delegate = self
        tableView.dataSource = self
        
        self.ref.observe(.childAdded, with: { (snapshot) in
        
            if let ingredient = snapshot.value {
                self.ingredients.append(ingredient as! String)
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

    @IBAction func btnAdd(_ sender: Any) {
        Auth.auth().addStateDidChangeListener { (auth, user) in
            if (user?.isEmailVerified)! && user != nil{
                let alert = UIAlertController(title: "Add Ingredient", message: nil, preferredStyle: .alert)
                let append = UIAlertAction(title: "Add", style: .default, handler: { [weak alert] (action) in
                    if let txt = alert?.textFields![0] {
                        self.ref.childByAutoId().setValue(txt.text)
                    }
                })
                append.isEnabled = false
                alert.addTextField(configurationHandler: { (txt) in
                    NotificationCenter.default.addObserver(forName: NSNotification.Name.UITextFieldTextDidChange, object: txt, queue: OperationQueue.main, using: { (notifaction) in
                        append.isEnabled = txt.hasText
                    })
                })
                alert.addAction(append)
                alert.addAction((UIAlertAction(title: "Cancel", style: .destructive, handler: nil)))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }

}
