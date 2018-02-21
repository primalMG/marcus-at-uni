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
    var ingredients: String?
    var steps: String?
    
    init(dictionary: [String: Any]) {
        self.name = dictionary["name"] as? String ?? ""
        self.ingredients = dictionary["ingredients"] as? String ?? ""
        self.steps = dictionary["steps"] as? String ?? ""
    }
    
}
