//
//  TipsModel.swift
//  RecipeApp
//
//  Created by (s) Marcus Gardner on 21/02/2018.
//  Copyright © 2018 (s) Marcus Gardner. All rights reserved.
//

import UIKit

class TipsModel: NSObject {
    var name: String?
    var brief: String?
    var descript: String?
    var id: String?
    
    init(dictionary: [String: Any]) {
        self.name = dictionary["name"] as? String ?? ""
        self.brief = dictionary["brief"] as? String ?? ""
        self.descript = dictionary["Description"] as? String ?? ""
        self.id = dictionary["tipID"] as? String ?? ""
    }
}
