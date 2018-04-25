//
//  RecipeScreen.swift
//  RecipeApp
//
//  Created by (s) Marcus Gardner on 21/02/2018.
//  Copyright © 2018 (s) Marcus Gardner. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class RecipeDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var ingredientsArray: [String] = []
    var stepsArray: [String] = []
    var currentRecipe = [Recipe]()
    var ref : DatabaseReference!
    var databaseHandle: DatabaseHandle!
    var recipeID: String!
    let currentUser = Auth.auth().currentUser?.uid
 
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imgSelectRecipe: UIImageView!
    @IBOutlet weak var recipeImage: UIImageView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.ref = Database.database().reference()
        tableView.delegate = self
        tableView.dataSource = self
        getIngredients()
        getSteps()
        recipe()

    }
    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        self.ref.child("Recipe").child(recipeID).removeObserver(withHandle: databaseHandle)
<<<<<<< HEAD
    }*/
        
=======
    }
    
>>>>>>> 55fac37f41126103db13d4de7a98fb2ab8211ec6
    func recipe() {
        databaseHandle = self.ref.child("Recipe").child(recipeID).observe(.value, with: { (snapshot) in
          
            
            
            
            if let dictionary = snapshot.value as? [String: AnyObject]{
                let recipe = Recipe(dictionary: dictionary)
                self.navigationItem.title = recipe.name
                if let recipeImgUrl = recipe.img {
                    self.recipeImage.LoadingImageUsingCache(urlString: recipeImgUrl)
                } else {
                    print("error")
                }

            }
            
        })
    }
    
    
    func getIngredients() {
        databaseHandle = self.ref.child("Recipe").child(recipeID).child("Ingredients").observe(.value, with: { (snapshot) in
            //print(snapshot)
            
            for child in snapshot.children {
                let dictionary = child as! DataSnapshot
                self.ingredientsArray.append(dictionary.value as! String)
            }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        })
    }
    
    func getSteps(){
        databaseHandle = self.ref.child("Recipe").child(recipeID).child("steps").observe(.value, with: { (snapshot) in
          //print(snapshot)
            
            for child in snapshot.children {
                let dictionary = child as! DataSnapshot
                self.stepsArray.append(dictionary.value as! String)
            }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        })
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return ingredientsArray.count
        case 1:
            return stepsArray.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ingredients", for: indexPath)
            cell.textLabel?.text = ingredientsArray[indexPath.row]
            return cell
        case 1:
            let stepsCell = tableView.dequeueReusableCell(withIdentifier: "steps", for: indexPath)
            stepsCell.textLabel?.text = stepsArray[indexPath.row]
            stepsCell.textLabel?.textColor = UIColor.black
            return stepsCell
        default:
            return UITableViewCell()
        }
   
    }
    
    let headerTitles = ["Ingredients","Steps"]

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section < headerTitles.count {
            return headerTitles[section]
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let indexPath = ingredientsArray[indexPath.row]
        
        Auth.auth().addStateDidChangeListener { (auth, user) in
            if self.currentUser != nil {
                let ingredient = self.ref.child("users").child(self.currentUser!).child("ShoppingList").childByAutoId()
                let ingredientKey = ingredient.key
                let name = ["nameID": ingredientKey,
                            "imgName": indexPath]
                ingredient.setValue(name)
                let alert = UIAlertController(title: "Ingredient Added to Shopping List", message: nil, preferredStyle: .alert)
                self.present(alert, animated: true, completion: nil)
                let delay = DispatchTime.now() + 0.5
                DispatchQueue.main.asyncAfter(deadline: delay){
                    alert.dismiss(animated: true, completion: nil)
                }
            } else {
                print("error")
            }
        }
    }
    
    @IBAction func btnAddAll(_ sender: Any) {
    }
    
    @IBAction func btnShare(_ sender: Any) {
    }
    
    
    
}

