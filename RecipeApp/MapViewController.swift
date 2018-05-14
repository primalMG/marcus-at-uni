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
import Firebase

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

    var ref : DatabaseReference!
    var databaseHandle:DatabaseHandle!
    var shopNames: [String] = []
    
    @IBOutlet weak var mapView: MKMapView!
 

    
    let locationManager = CLLocationManager()
  
    
    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        //locationManager.startUpdatingLocation()
        setupUserTrackingButtonAndScaleView()
        userlocation()
        ref = Database.database().reference()
        
        getShops()
        
        mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
//        let sains = CLLocationCoordinate2D(latitude: 50.3807, longitude: -4.1332)
//        let sainAnnotation = annotations(coordinate: sains, title: "Sainsbury's local", subtitle: "little shop")
//        mapView.addAnnotation(sainAnnotation)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getShops(){
         ref.child("ShopLocation").observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
            print(snapshot)
            
            for child in snapshot.children {
                let dictionary = child as! DataSnapshot
                
                if let dictionaryy = dictionary.value as? [String: AnyObject] {
                    let lat = dictionaryy["lat"] as! CLLocationDegrees
                    let long = dictionaryy["long"] as! CLLocationDegrees
                    let name = dictionaryy["name"] as! String
                    
                    let coords = CLLocationCoordinate2D(latitude: lat, longitude: long)
                    
                    self.shopNames.append(name)
                    
                    let pinCoord: CLLocationCoordinate2D = CLLocationCoordinate2DMake(lat, long)
                    
                    let annotation = annotations(coordinate: pinCoord, title: name, subtitle: name)
                    
                    annotation.coordinate = pinCoord
                    self.mapView.addAnnotation(annotation)
                }
                
            }
            
            
            
            
        })
        
    }
    
    func userlocation(){
        let button = MKUserTrackingButton(mapView: mapView)
        button.layer.backgroundColor = UIColor(white: 1, alpha: 0.8).cgColor
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
        
        let scale = MKScaleView(mapView: mapView)
        scale.legendAlignment = .trailing
        scale.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scale)
        
        NSLayoutConstraint.activate([button.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40),
                                     button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
                                     scale.trailingAnchor.constraint(equalTo: button.leadingAnchor, constant: -40),
                                     scale.centerYAnchor.constraint(equalTo: button.centerYAnchor)])
        
    }

    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations[0]
        let center = location.coordinate
        let span = MKCoordinateSpanMake(0.005, 0.005)
        let region = MKCoordinateRegionMake(center, span)

        mapView.setRegion(region, animated: true)
        mapView.showsUserLocation = true
    }
    
 
     func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotations = mapView.dequeueReusableAnnotationView(withIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier) as? MKMarkerAnnotationView {
            annotations.animatesWhenAdded = true
            annotations.titleVisibility = .adaptive
            annotations.subtitleVisibility = .adaptive
            
            return annotations
        }
        return nil
    }

    
    func setupUserTrackingButtonAndScaleView() {
        
        let button = MKUserTrackingButton(mapView: mapView)
        button.layer.backgroundColor = UIColor(white: 1, alpha: 0.8).cgColor
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
        
        let scale = MKScaleView(mapView: mapView)
        scale.legendAlignment = .trailing
        scale.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scale)
        
        NSLayoutConstraint.activate([button.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10),
                                     button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
                                     scale.trailingAnchor.constraint(equalTo: button.leadingAnchor, constant: -10),
                                     scale.centerYAnchor.constraint(equalTo: button.centerYAnchor)])
        
        print("is this running")
    }

}

