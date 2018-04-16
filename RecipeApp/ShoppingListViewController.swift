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
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        // Do any additional setup after loading the view.
        ShoppingList()
        clear()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func ShoppingList(){
        let currUser = Auth.auth().currentUser?.uid
        databaseHandle = ref.child("users").child(currUser!).child("ShoppingList").observe(.childAdded, with: { (snapshot) in
            print(snapshot)

            if let dictionary = snapshot.value as? String {
               self.ingredientsArray.append(dictionary)
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }

        })
    }

    func clear(){
        let currUser = Auth.auth().currentUser?.uid
        databaseHandle = ref.child("users").child(currUser!).child("ShoppingList").observe(.childRemoved, with: { (snapshot) in

            self.ingredientsArray.removeAll()

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
        let currUser = Auth.auth().currentUser?.uid
        let ingredient = self.ref.child("users").child(currUser!).child("ShoppingList")
        let key = ingredient.key
        let delete = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completetion) in
            ingredient.child(self.ingredientsArray[indexPath.row]).removeValue()
            self.ingredientsArray.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)

        }
        delete.image = #imageLiteral(resourceName: "Trash")
        return delete
    }

    //self.ingredientsArray[indexPath.row]

    @IBAction func btnAddIng(_ sender: Any) {
        let currUser = Auth.auth().currentUser?.uid
        let ingredient = self.ref.child("users").child(currUser!).child("ShoppingList").childByAutoId()
        let ingredientKey = ingredient.key
        let alert = UIAlertController(title: "Add Ingredient", message: nil, preferredStyle: .alert)
        let append = UIAlertAction(title: "Add", style: .default, handler: { [weak alert] (action) in
            Auth.auth().addStateDidChangeListener({ (auth, user) in
                if let txt = alert?.textFields![0], currUser != nil{
                    let name = ["nameID": ingredientKey,
                                "Name": txt.text!] as [String : Any]
                    ingredient.setValue(txt.text)
                    //self.ref.child("users").child(self.currUser!).child("ShoppingList").setValue(self.ingredientKey)
                } else {
                    print("error")

                }
            })
        })

        alert.addAction(append)

        alert.addTextField(configurationHandler: { (txt) in
            txt.placeholder = "Eg... Eggs"
            NotificationCenter.default.addObserver(forName: NSNotification.Name.UITextViewTextDidChange, object: txt, queue: OperationQueue.main) { (notification) in
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
//            Auth.auth().addStateDidChangeListener { (auth, user) in
//                if self.currUser != nil, let text = self.txtIngredient.text, !text.isEmpty {
//                    self.ref.child("users").child(self.currUser!).child("ShoppingList").childByAutoId().setValue(self.txtIngredient.text)
//                    self.txtIngredient.text = ""
//                }else {
//                    self.txtIngredient.text = "please sign in"
//                    //TODO redirect to login page...
//                }
//            }

    @IBAction func btnDeleteAll(_ sender: Any) {
        
        let currUser = Auth.auth().currentUser?.uid
        let alert = UIAlertController(title: "Are you done?", message: "Are you sure you want to clear your shopping list", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
            self.ref.child("users").child(currUser!).child("ShoppingList").removeValue()
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
