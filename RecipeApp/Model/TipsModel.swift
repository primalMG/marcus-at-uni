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
    var shortDescription: String?
    var longDescription: String?
    
    init(dictionary: [String: Any]) {
        self.name = dictionary["name"] as? String ?? ""
        self.shortDescription = dictionary["shortDescription"] as? String ?? ""
        self.longDescription = dictionary["longDescription"] as? String ?? ""
    }
}
