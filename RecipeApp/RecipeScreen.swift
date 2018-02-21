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
        
        getIngredients()
        tableView.delegate = self
        tableView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getIngredients() {
        ref = Database.database().reference()
        
        databaseHandle = ref?.child("Ingredients").observe(.childAdded, with: { (snapshot) in
            
            
            if let dictionary = snapshot.value as? [String: AnyObject]{
                let ingredients = Recipe(dictionary: dictionary)
                self.ingredientsArray.append(ingredients)
            }
            print(snapshot)
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
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
