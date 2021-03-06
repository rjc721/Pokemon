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
        mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.showsCompass = false
        // mapView.userLocation.title = "Gotta catch 'em all!"
        
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
            Timer.scheduledTimer(withTimeInterval: 10, repeats: true, block: { (timer) in
                if let coordinates = self.manager.location?.coordinate {
                    //Spawn Pokemon
                    
                    let pokemon = self.pokemons[Int(arc4random_uniform(UInt32(self.pokemons.count)))]
                    let anno = PokeAnnotation(coord: coordinates, pokemon: pokemon)
                    let randomLat = (Double(arc4random_uniform(200))-100)/50000.0
                    let randomLong = (Double(arc4random_uniform(200))-100)/50000.0
                    
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
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        locationPermissionsCheck()
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
        let pokemon = (annotation as! PokeAnnotation).pokemon
        annoView.image = UIImage(named: pokemon.imageName!)
        
        var frame = annoView.frame
        frame.size.height = 50
        frame.size.width = 50
        annoView.frame = frame
        
        return annoView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if view.annotation! is MKUserLocation {
            return
        }
        mapView.deselectAnnotation(view.annotation!, animated: true)
        
        let region = MKCoordinateRegionMakeWithDistance(view.annotation!.coordinate, 150, 150)
        mapView.setRegion(region, animated: true)
        
        Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) { (timer) in
            if let userLocation = self.manager.location?.coordinate {
                
                let pokemon = (view.annotation as! PokeAnnotation).pokemon
                
                if MKMapRectContainsPoint(mapView.visibleMapRect, MKMapPointForCoordinate(userLocation)) {
                    
                    pokemon.caught = true
                    (UIApplication.shared.delegate as! AppDelegate).saveContext()
                    
                    mapView.removeAnnotation(view.annotation!)
                    
                    let alertVC = UIAlertController(title: "Congrats!", message: "You caught \(pokemon.name!)!", preferredStyle: .alert)
                    let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alertVC.addAction(OKAction)
                    let pokedexAction = UIAlertAction(title: "Pokedex", style: .default, handler: { (action) in
                        self.performSegue(withIdentifier: "pokedexSegue", sender: nil)
                    })
                    alertVC.addAction(pokedexAction)
                    self.present(alertVC, animated: true, completion: nil)
                    
                } else {
                    let alertVC = UIAlertController(title: "Uh-oh! You're not close enough!", message: "Move closer to catch the \(pokemon.name!)", preferredStyle: .alert)
                    let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alertVC.addAction(OKAction)
                    self.present(alertVC, animated: true, completion: nil)
                }
                
            }
        }
        
    }
    
}

