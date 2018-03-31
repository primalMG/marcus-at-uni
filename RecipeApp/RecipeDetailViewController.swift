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
        databaseHandle = self.ref.child("Recipe").child(recipeID).child("Ingredients").observe(.childAdded, with: { (snapshot) in
            print(snapshot)
            
            if let dictionary = snapshot.value as? String {
                self.ingredientsArray.append(dictionary)
            }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        })
    }
    
    func getSteps(){
        databaseHandle = self.ref.child("Recipe").child(recipeID).child("steps").observe(.childAdded, with: { (snapshot) in
          print(snapshot)
            
            if let dictionary = snapshot.value as? String {
                self.stepsArray.append(dictionary)
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
        Auth.auth().addStateDidChangeListener { (auth, user) in
            
        }
    }
}

