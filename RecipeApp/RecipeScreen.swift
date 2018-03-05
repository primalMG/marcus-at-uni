//
//  RecipeScreen.swift
//  RecipeApp
//
//  Created by (s) Marcus Gardner on 21/02/2018.
//  Copyright © 2018 (s) Marcus Gardner. All rights reserved.
//

import UIKit
import FirebaseDatabase

class RecipeScreen: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var ingredientsArray = [Recipe]()
    var stepsArray = [Recipe]()
    var recScreen: String!
    var ref : DatabaseReference!
    var ingredientsRef : DatabaseReference!
    var databaseHandle:DatabaseHandle!
    var recipeID = ""
    var currentRecipe = [Recipe]()
 

    
    
    @IBOutlet weak var tableView: UITableView!
    

    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.ref = Database.database().reference()
        tableView.delegate = self
        tableView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        self.ref.child("Recipe").child(recipeID).removeObserver(withHandle: databaseHandle)
    }
    
    
    func getIngredients() {
        databaseHandle = self.ref.child("Recipe").child(recipeID).observe(.childAdded, with: { (snapshot) in
            
          
                print(snapshot)
            
            if let dictionary = snapshot.value as? [String: AnyObject]{
                let recipe = Recipe(dictionary: dictionary)
                self.ingredientsArray.append(recipe)
            }

        })
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ingredientsArray.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ingredients", for: indexPath)
        
        let ingredients = ingredientsArray[indexPath.row]
        cell.textLabel?.text = ingredients.name
        
        return cell
        
    }
    
    
    
}
