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
    var ingredientsArray = [UserModel]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        // Do any additional setup after loading the view.
        ShoppingList()
        
        
        tableView.allowsMultipleSelectionDuringEditing = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnRefresh(_ sender: Any) {
        self.tableView.reloadData()
    }
    
    
    func ShoppingList(){
        let currUser = Auth.auth().currentUser?.uid
        if currUser != nil {
            databaseHandle = ref.child("users").child(currUser!).child("ShoppingList").observe(.childAdded, with: { (snapshot) in
                print(snapshot)
                if let dictionary = snapshot.value as? [String: AnyObject]{
                    let ingredient = UserModel(dictionary: dictionary)
                    self.ingredientsArray.append(ingredient)
                }
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }

            })
        } else {
            print("please sign in")
        }

    }


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ingredientsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "shoppingList", for: indexPath)
        cell.textLabel?.text = ingredientsArray[indexPath.row].imgName
        return cell
    }
    

    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = deleteAction(at: indexPath)
        return UISwipeActionsConfiguration(actions: [delete])
    }

    func deleteAction(at indexPath: IndexPath) -> UIContextualAction {
        let currUser = Auth.auth().currentUser?.uid
        let ingredient = self.ref.child("users").child(currUser!).child("ShoppingList") 
        let delete = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completetion) in
            ingredient.child(self.ingredientsArray[indexPath.row].nameID!).removeValue()
            self.ingredientsArray.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)

        }
        delete.image = #imageLiteral(resourceName: "Trash")
        return delete
    }

    
    
    
    @IBAction func btnAddIng(_ sender: Any) {
        let currUser = Auth.auth().currentUser?.uid
        let alert = UIAlertController(title: "Add Ingredient", message: nil, preferredStyle: .alert)
        let append = UIAlertAction(title: "Add", style: .default, handler: { [weak alert] (action) in
            if let txt = alert?.textFields![0], currUser != nil{
                
                let ingredient = self.ref.child("users").child(currUser!).child("ShoppingList").childByAutoId()
                    let ingredientKey = ingredient.key
                    let name = ["nameID": ingredientKey,
                                "imgName": txt.text!] as [String : Any]
                    ingredient.setValue(name)
                } else {
                    print("error")
                }
        })
        
//        let alert = UIAlertController(title: "Sign In", message: "Please sign up to use the shopping list feature", preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "Sign In", style: .default, handler: { (action: UIAlertAction!) in
//            //direct the user to login page.
//        }))
//        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action: UIAlertAction!) in
//            alert.dismiss(animated: true, completion: {
//                print("sign in cancelled")
//            })
//        }))
//        self.present(alert, animated: true, completion: nil)

        alert.addAction(append)
        append.isEnabled = false
        alert.addTextField(configurationHandler: { (txt) in
            txt.placeholder = "Eg... Eggs"
            NotificationCenter.default.addObserver(forName: NSNotification.Name.UITextFieldTextDidChange, object: txt, queue: OperationQueue.main) { (notification) in
                append.isEnabled = txt.hasText
            }
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action: UIAlertAction!) in
            alert.dismiss(animated: true, completion: {
                print("Cancel")
            })
        }))

        present(alert, animated: true, completion: nil)
    }


    @IBAction func btnDeleteAll(_ sender: Any) {
        
        let currUser = Auth.auth().currentUser?.uid
        let alert = UIAlertController(title: "Are you done?", message: "Are you sure you want to clear your shopping list", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
            self.ref.child("users").child(currUser!).child("ShoppingList").removeValue()
            self.ingredientsArray.removeAll()
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action: UIAlertAction!) in
            alert.dismiss(animated: true, completion: {
                print("Delete all canceled")
            })
        }))

        present(alert, animated: true, completion: nil)
    }



    @IBAction func unwindToShoppingList(_ sender: UIStoryboardSegue){

    }


}
