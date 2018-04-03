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

class ShoppingListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
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
        ShoppingList()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func ShoppingList(){
        databaseHandle = ref.child("users").child(self.currUser!).child("ShoppingList").observe(.childAdded, with: { (snapshot) in
            print(snapshot)
            
            if let dictionary = snapshot.value as? String {
               self.ingredientsArray.append(dictionary)
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ingredientsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "shoppingList", for: indexPath)
        cell.textLabel?.text = ingredientsArray[indexPath.row]
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = deleteAction(at: indexPath)
        return UISwipeActionsConfiguration(actions: [delete])
    }

    func deleteAction(at indexPath: IndexPath) -> UIContextualAction {
        let delete = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completetion) in
            self.ref.child("users").child(self.currUser!).child("ShoppingList").child(self.ingredientsArray[indexPath.row]).removeValue()
            self.ingredientsArray.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)

        }
        delete.image = #imageLiteral(resourceName: "Trash")
        return delete
    }
    
    @IBAction func btnAddIng(_ sender: Any) {
        
        Auth.auth().addStateDidChangeListener { (auth, user) in
            if self.currUser != nil, let text = self.txtIngredient.text, !text.isEmpty {
                self.ref.child("users").child(self.currUser!).child("ShoppingList").childByAutoId().setValue(self.txtIngredient.text)
                self.txtIngredient.text = ""
            }else {
                self.txtIngredient.text = "please sign in"
                //TODO redirect to login page...
            }
        }
    }
    
    @IBAction func btnDeleteAll(_ sender: Any) {
        self.ref.child("users").child(self.currUser!).child("ShoppingList").removeValue()
    }
    
    
    @IBAction func unwindToShoppingList(_ sender: UIStoryboardSegue){
        
    }


}
