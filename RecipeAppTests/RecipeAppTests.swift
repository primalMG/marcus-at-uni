//
//  RecipeAppTests.swift
//  RecipeAppTests
//
//  Created by Marcus Gardner on 20/05/2018.
//  Copyright © 2018 (s) Marcus Gardner. All rights reserved.
//

import XCTest
@testable import RecipeApp
import Firebase

class RecipeAppTests: XCTestCase {
    

    var databaseHandle: DatabaseHandle!
    var ref: DatabaseReference!
    var recipeArray = [Recipe]()
    
    
    func testDatabase(){
        FirebaseApp.configure()
    }
    
    
    
    func testFetchRecipes(){
        FirebaseApp.configure()
        ref = Database.database().reference()
        
        databaseHandle = ref.child("Recipe").observe(.childAdded, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject]{
                let recipe = Recipe(dictionary: dictionary)
                self.recipeArray.append(recipe)
                XCTAssertEqual(recipe.name, "Roast Chicken")
            }
            
        })
        
        XCTAssertTrue((databaseHandle != nil))
    }
    


    
}
