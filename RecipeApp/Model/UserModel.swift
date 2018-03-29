//
//  UserModel.swift
//  RecipeApp
//
//  Created by (s) Marcus Gardner on 06/03/2018.
//  Copyright © 2018 (s) Marcus Gardner. All rights reserved.
//

import UIKit

class UserModel: NSObject {
    var username: String?
    var userID: String?
    
    init(dictionary: [String: Any]) {
        self.username = dictionary["username"] as? String ?? ""
        self.userID = dictionary["userID"] as? String ?? ""
    }

}
