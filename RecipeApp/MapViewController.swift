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

class MapViewController: UIViewController, CLLocationManagerDelegate {

    var ref : DatabaseReference!
    var databaseHandle:DatabaseHandle!
    var selectedShop: String!
    var shop = [MapModel]()
    var shopRegion : CLCircularRegion!
    
    @IBOutlet weak var mapView: MKMapView!
 

    
    
   
  
    let locationManager = CLLocationManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        
        userlocation()
        ref = Database.database().reference()
   
        getShops()
   
        
        mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getShops(){
         ref.child("ShopLocation").observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
        
            
            for child in snapshot.children {
                let dictionary = child as! DataSnapshot
                if let dictionaryy = dictionary.value as? [String: AnyObject] {
                    let lat = dictionaryy["lat"] as! CLLocationDegrees
                    let long = dictionaryy["long"] as! CLLocationDegrees
                    let name = dictionaryy["name"] as! String
                    let subName = dictionaryy["subName"] as! String
                    let key = dictionaryy["key"] as! String
                   
                    
                    let pinCoord: CLLocationCoordinate2D = CLLocationCoordinate2DMake(lat, long)
                    
                    let annotation = MapModel(coordinate: pinCoord, title: name, subtitle: subName, key: key)
                    
                  
                    self.shopRegion = CLCircularRegion(center: CLLocationCoordinate2DMake(50.3755, -4.1427), radius: 1000, identifier: "buff")
                    
                    self.shopRegion.notifyOnEntry = true
                    self.shopRegion.notifyOnExit = true
                    self.locationManager.startMonitoring(for: self.shopRegion)
                    annotation.coordinate = pinCoord
                    self.mapView.addAnnotation(annotation)
                }
            }
        })
    }
    
//    if currUser == region {
//    add ingreidnt to shop within regions list
//    } else {
//    tell them they are not within the region...
//    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        print("welcome to the region")
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        print("you've left the region")
    }
    
    func locationManager(_ manager: CLLocationManager, didStartMonitoringFor region: CLRegion) {
        print("user lurking in region")
    }
    
    func userlocation(){
        locationManager.startUpdatingLocation()
        mapView.showsUserLocation = true
        
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

        NSLayoutConstraint.activate([button.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
                                     button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
                                     scale.trailingAnchor.constraint(equalTo: button.leadingAnchor, constant: -50),
                                     scale.centerYAnchor.constraint(equalTo: button.centerYAnchor)])

    }

    
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//
//        let location = locations[0]
//        let center = location.coordinate
//        let span = MKCoordinateSpanMake(0.005, 0.005)
//        let region = MKCoordinateRegionMake(center, span)
//
//        mapView.setRegion(region, animated: true)
//        mapView.showsUserLocation = true
//    }

    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        let location = locations.last as! CLLocation
        
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        self.mapView.setRegion(region, animated: true)
    }

    

    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let annoations = view.annotation as! MapModel
        selectedShop = annoations.key!
        self.performSegue(withIdentifier: "ShopIngredients", sender: self)
    }
    

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShopIngredients" {
            if let destination = segue.destination as? ShopIngredientsViewController {
                destination.shopID = selectedShop
            }
        }
    }
}






