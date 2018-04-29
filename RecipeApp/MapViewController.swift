//
//  MapViewController.swift
//  RecipeApp
//
//  Created by (s) Marcus Gardner on 25/04/2018.
//  Copyright © 2018 (s) Marcus Gardner. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

final class annotations: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?

    init(coordinate: CLLocationCoordinate2D, title: String?, subtitle: String?){
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
        
        super.init()
    }
}

class MapViewController: UIViewController, CLLocationManagerDelegate {

    
    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
  
    
    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        
        mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        let sains = CLLocationCoordinate2D(latitude: 50.3807, longitude: -4.1332)
        let sainAnnotation = annotations(coordinate: sains, title: "Sainsbury's local", subtitle: "little shop")
        mapView.addAnnotation(sainAnnotation)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations[0]
        let center = location.coordinate
        let span = MKCoordinateSpanMake(0.005, 0.005)
        let region = MKCoordinateRegionMake(center, span)

        mapView.setRegion(region, animated: true)
        mapView.showsUserLocation = true
    }
}

extension UIViewController: MKMapViewDelegate {
    public func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotations = mapView.dequeueReusableAnnotationView(withIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier) as? MKMarkerAnnotationView {
            annotations.animatesWhenAdded = true
            annotations.titleVisibility = .adaptive
            annotations.subtitleVisibility = .adaptive
            
            return annotations
        }
        return nil
    }
}
