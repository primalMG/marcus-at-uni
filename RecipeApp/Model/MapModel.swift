//
//  MapModel.swift
//  RecipeApp
//
//  Created by Marcus Gardner on 14/05/2018.
//  Copyright © 2018 (s) Marcus Gardner. All rights reserved.
//

import UIKit

class MapModel: NSObject {
    var name: String?
    var lat: String?
    var long: String?
    
    init(dictionary: [String: Any]){
        self.name = dictionary["name"] as? String ?? ""
        self.lat = dictionary["lat"] as? String ?? ""
        self.long = dictionary["long"] as? String ?? ""
    }
    
    

}
