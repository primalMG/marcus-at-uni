//
//  Recipe.swift
//  RecipeApp
//
//  Created by (s) Marcus Gardner on 20/02/2018.
//  Copyright © 2018 (s) Marcus Gardner. All rights reserved.
//

import UIKit

class Recipe: NSObject {
    var name: String?
    var price: String?
    var ingredients: String?
    var steps: String?
    var img: String?
    var video: String?
    var recipeID: String?
    var serving: String?

    
    init(dictionary: [String: Any]) {
        self.name = dictionary["name"] as? String ?? ""
        self.price = dictionary["price"] as? String ?? ""
        self.img = dictionary["img"] as? String ?? ""
        self.video = dictionary["video"] as? String ?? ""
        self.recipeID = dictionary["recipeID"] as? String ?? ""
        self.ingredients = dictionary["Ingredients"] as? String ?? ""
        self.steps = dictionary["steps"] as? String ?? ""
        self.serving = dictionary["serving"] as? String ?? ""
    }
    
}


