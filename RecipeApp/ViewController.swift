//
//  ViewController.swift
//  RecipeApp
//
//  Created by (s) Marcus Gardner on 13/02/2018.
//  Copyright © 2018 (s) Marcus Gardner. All rights reserved.
//

import UIKit
import FirebaseDatabase

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    var ref : DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DisplayingRecipes()
        ref = Database.database().reference()
        getRecipes()
        searchbar()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    func getRecipes(){
        // getting the recipes from the database
    }
    
    
    var recipeArray = [Recipe]()
    var selectedRecipe = [Recipe]()
    
    class Recipe {
        let name: String
        
        init(name: String) {
            self.name = name
        }
    }
    
    private func DisplayingRecipes() {
        recipeArray.append(Recipe(name:"Oxtail Stew"))
        recipeArray.append(Recipe(name:"Mac n Cheese"))
        recipeArray.append(Recipe(name:"Rice and Stew"))
        
        selectedRecipe = recipeArray
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipeArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(withIdentifier: "recipes")
    }
    
    /*func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "recipes") as? TableCell else {
            return UITableViewCell()
        }
        cell.lblRecipe.text = recipeArray[indexPath.row].name
        return cell
    }*/
    
    
    private func searchbar() {
        searchBar.delegate = self
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else { selectedRecipe = recipeArray
            tableView.reloadData()
            return
        }
        selectedRecipe = recipeArray.filter({ Recipe -> Bool in
            Recipe.name.lowercased().contains(searchText.lowercased())
        })
        tableView.reloadData()
    }
    


   
    //Segue back to the home/Recipe screen
    @IBAction func unwindSegue(_ sender: UIStoryboardSegue) {
        
    }
    

    
    

    

    //Drawer Menu
    var menuState = false
    
    @IBOutlet weak var leadingConstraint: NSLayoutConstraint!
    @IBAction func btnMenu(_ sender: Any) {
        if (menuState){
            //closes menu
            leadingConstraint.constant = 430
            UIView.animate(withDuration: 0.3, animations: {
                self.view.layoutIfNeeded()
            })
        }else{
            //opens menu
           leadingConstraint.constant = 175
            UIView.animate(withDuration: 0.3, animations: {
                self.view.layoutIfNeeded()
            })
        }
        menuState = !menuState
    }
    



    
}

