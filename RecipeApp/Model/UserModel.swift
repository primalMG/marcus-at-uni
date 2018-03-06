//
//  UserModel.swift
//  RecipeApp
//
//  Created by (s) Marcus Gardner on 06/03/2018.
//  Copyright © 2018 (s) Marcus Gardner. All rights reserved.
//

import UIKit

class UserModel: NSObject {
    var userName: String?
    
    init(dictionary: [String: Any]) {
        self.userName = dictionary["username"] as? String ?? ""
    }

}
