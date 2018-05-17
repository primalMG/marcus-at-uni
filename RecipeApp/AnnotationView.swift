//
//  AnnotationView.swift
//  RecipeApp
//
//  Created by Marcus Gardner on 16/05/2018.
//  Copyright © 2018 (s) Marcus Gardner. All rights reserved.
//

import MapKit
import UIKit

class AnnotationView: MKAnnotationView, MKMapViewDelegate {

//    var selectedShop: String!

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotations = mapView.dequeueReusableAnnotationView(withIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier) as? MKMarkerAnnotationView {
            annotations.animatesWhenAdded = true
            annotations.canShowCallout = true

            let info = UIButton(type: .detailDisclosure)
            annotations.rightCalloutAccessoryView = info

            return annotations
        }
        return nil
    }


    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
