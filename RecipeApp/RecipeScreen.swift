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
    var databaseHandle:DatabaseHandle!
    
    var recipe: Recipe? {
        didSet{
            navigationItem.title = recipe?.name
        }
    }
    
    
    @IBOutlet weak var tableView: UITableView!
    

    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //getIngredients()
        tableView.delegate = self
        tableView.dataSource = self
        
        print("Accessed Recipe")
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    /*func getIngredients() {
      let ref = Database.database().reference().child("Recipe").queryOrdered(byChild: "Ingredients").queryEqual(toValue: "Ing 1")
      
        ref.observe(.value, with: { (snapshot: DataSnapshot) in
            for snap in snapshot.children{
                print((snap as! DataSnapshot).key)
            }
        })
    }*/
    

    
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
