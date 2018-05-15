//
//  MapModel.swift
//  RecipeApp
//
//  Created by Marcus Gardner on 14/05/2018.
//  Copyright © 2018 (s) Marcus Gardner. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation


class annotations: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    var key: String?
    
    
    init(coordinate: CLLocationCoordinate2D, title: String?, subtitle: String?, key: String?){
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
        self.key = key
        
        super.init()
    }
}
