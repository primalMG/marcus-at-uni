//
//  RecipeScreen.swift
//  RecipeApp
//
//  Created by (s) Marcus Gardner on 21/02/2018.
//  Copyright © 2018 (s) Marcus Gardner. All rights reserved.
//

import UIKit
import FirebaseFirestore

class RecipeScreen: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var recipeName: UILabel!
    
    var currentRecipe = [Recipe]()
    

    
    
    @IBOutlet weak var tableView: UITableView!
    

    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        print("Accessed Recipe")
        
    
        recipeName.text = currentRecipe[0].name
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    /*func getIngredients() {
        let db = Firestore.firestore().collection("recipe").getDocuments { (querySnapshot, error) in
            if error != nil {
                print("error getting doc")
            }else{
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                }
            }
        }
    }*/
    

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentRecipe.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ingredients", for: indexPath)
        
        let ingredients = currentRecipe[indexPath.row]
        cell.textLabel?.text = ingredients.name
        
        return cell
        
    }
    
    
    
}
