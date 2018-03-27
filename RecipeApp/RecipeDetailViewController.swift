//
//  RecipeScreen.swift
//  RecipeApp
//
//  Created by (s) Marcus Gardner on 21/02/2018.
//  Copyright © 2018 (s) Marcus Gardner. All rights reserved.
//

import UIKit
import FirebaseDatabase

class RecipeDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var ingredientsArray: [String] = []
    var stepsArray: [String] = []
    var ref : DatabaseReference!
    var databaseHandle: DatabaseHandle!
    var recipeID: String!
 
    func loadingTings(){
        var recipeName: Recipe? {
            didSet {
                navigationItem.title = recipeName?.name
                print("something")
            }
        }
    }
    
   
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imgSelectRecipe: UIImageView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.ref = Database.database().reference()
        tableView.delegate = self
        tableView.dataSource = self
        getIngredients()
        getSteps()

        
    }
    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*deinit {
        self.ref.child("Recipe").child(recipeID).removeObserver(withHandle: databaseHandle)
    }*/
    
    
    func getIngredients() {
        databaseHandle = self.ref.child("Recipe").child(recipeID).child("Ingredients").observe(.value, with: { (snapshot) in
            print(snapshot)
            for child in snapshot.children {
                let dictionary = child as! DataSnapshot
                self.ingredientsArray.append(dictionary.key)
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        })
    }
    
    func getSteps(){
        databaseHandle = self.ref.child("Recipe").child(recipeID).child("steps").observe(.value, with: { (snapshot) in
          print(snapshot)
            
            for child in snapshot.children {
                let steps = child as! DataSnapshot
                self.stepsArray.append(steps.key)
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
        return (ingredientsArray.count + stepsArray.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row < ingredientsArray.count{
            let cell = tableView.dequeueReusableCell(withIdentifier: "ingredients", for: indexPath)
            cell.textLabel?.text = ingredientsArray[indexPath.row]
            return cell
        } else {
            let cellSteps = tableView.dequeueReusableCell(withIdentifier: "steps", for: indexPath)
            cellSteps.textLabel?.text = stepsArray[indexPath.row - ingredientsArray.count]
            return cellSteps
        }
    }
    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//
//            let cell = tableView.dequeueReusableCell(withIdentifier: "ingredients", for: indexPath)
//            cell.textLabel?.text = ingredientsArray[indexPath.row]
//            return cell
//
//    }
    
    let headerTitles = ["ingredients","Steps"]

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section < headerTitles.count {
            return headerTitles[section]
        }
        return nil
    }
}

