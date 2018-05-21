//
//  AnnotationView.swift
//  RecipeApp
//
//  Created by Marcus Gardner on 16/05/2018.
//  Copyright © 2018 (s) Marcus Gardner. All rights reserved.
//

import MapKit
import UIKit

extension MapViewController: MKMapViewDelegate {

     func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {return nil}
        
        let reusePin = "pin"
        
        var annotations = mapView.dequeueReusableAnnotationView(withIdentifier: reusePin) as? MKMarkerAnnotationView
        if annotations == nil {            
            annotations = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: reusePin)
            annotations?.animatesWhenAdded = true
            annotations?.canShowCallout = true
            
            let info = UIButton(type: .detailDisclosure)
            annotations?.rightCalloutAccessoryView = info
            
            
        } else {
            annotations?.annotation = annotation
        }
        return annotations
    }
}
