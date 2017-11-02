//
//  MapViewController.swift
//  Pokemon
//
//  Created by Ryan Chingway on 11/1/17.
//  Copyright © 2017 Ryan Chingway. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var manager = CLLocationManager()
    var updateCount = 0
    var pokemons : [Pokemon] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pokemons = getAllPokemon()
        
        manager.delegate = self
        mapView.showsUserLocation = true
        mapView.showsCompass = false
        
        locationPermissionsCheck()
    }
    
    @IBAction func centerTapped(_ sender: UIButton) {
        locationPermissionsCheck()
        if let coordinates = manager.location?.coordinate {
            let region = MKCoordinateRegionMakeWithDistance(coordinates, 200, 200)
            mapView.setRegion(region, animated: true)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if updateCount < 1 {
            let region = MKCoordinateRegionMakeWithDistance(manager.location!.coordinate, 200, 200)
            mapView.setRegion(region, animated: false)
            updateCount += 1
        } else {
            manager.stopUpdatingLocation()
        }
    }
    
    private func locationPermissionsCheck() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedAlways, .authorizedWhenInUse:
            manager.startUpdatingLocation()
            Timer.scheduledTimer(withTimeInterval: 5, repeats: true, block: { (timer) in
                if let coordinates = self.manager.location?.coordinate {
                    //Spawn Pokemon
                    
                    let anno = MKPointAnnotation()
                    let randomLat = (Double(arc4random_uniform(200))-100)/50000.0
                    let randomLong = (Double(arc4random_uniform(200))-100)/50000.0
                    anno.coordinate = coordinates
                    anno.coordinate.latitude += randomLat
                    anno.coordinate.longitude += randomLong
                    self.mapView.addAnnotation(anno)
                    
                }
            })
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
            manager.startUpdatingLocation()
        case .denied, .restricted:
            let alertController = UIAlertController(title: "Location Access is Disabled", message: "Please visit Settings and enable Location Services to use the full functionality of this app.", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            let openAction = UIAlertAction(title: "Open Settings", style: .default) { (action) in
                if let url = URL(string:UIApplicationOpenSettingsURLString) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    
                }
            }
            alertController.addAction(cancelAction)
            alertController.addAction(openAction)
            alertController.preferredAction = openAction
            self.present(alertController, animated: true, completion: nil)
        }
    }
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation is MKUserLocation {
            let annoView = MKAnnotationView(annotation: annotation, reuseIdentifier: nil)
            annoView.image = UIImage(named: "player")
            
            var frame = annoView.frame
            frame.size.height = 50
            frame.size.width = 50
            annoView.frame = frame
            
            return annoView
        }
        
        let annoView = MKAnnotationView(annotation: annotation, reuseIdentifier: nil)
        annoView.image = UIImage(named: "mew")
        
        var frame = annoView.frame
        frame.size.height = 50
        frame.size.width = 50
        annoView.frame = frame
        
        return annoView
    }
    
}

