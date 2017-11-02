//
//  PokeAnnotation.swift
//  Pokemon
//
//  Created by Ryan Chingway on 11/2/17.
//  Copyright © 2017 Ryan Chingway. All rights reserved.
//

import UIKit
import MapKit

class PokeAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var pokemon : Pokemon
    
    init(coord: CLLocationCoordinate2D, pokemon: Pokemon) {
        self.coordinate = coord
        self.pokemon = pokemon
    }
}
