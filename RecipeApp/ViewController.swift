//
//  ViewController.swift
//  RecipeApp
//
//  Created by (s) Marcus Gardner on 13/02/2018.
//  Copyright © 2018 (s) Marcus Gardner. All rights reserved.
//

import UIKit


class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    let Recipes = ["Mac n Cheese","Pasta","Chicken"]
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (Recipes.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "recipes")
        cell.textLabel?.text = Recipes[indexPath.row]
        
        return(cell)
    }
    
    @IBAction func unwindSegue(_ sender: UIStoryboardSegue) {
        
    }

    

    
    var menuState = false
    
    @IBOutlet weak var leadingConstraint: NSLayoutConstraint!
    //Drawer Menu
    @IBAction func btnMenu(_ sender: Any) {
        if (menuState){
            leadingConstraint.constant = 430
            UIView.animate(withDuration: 0.3, animations: {
                self.view.layoutIfNeeded()
            })
        }else{
           leadingConstraint.constant = 175
            UIView.animate(withDuration: 0.3, animations: {
                self.view.layoutIfNeeded()
            })
        }
        menuState = !menuState
    }
    



    
}

