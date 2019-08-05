//
//  ShowLocationViewController.swift
//  On the Map
//
//  Created by Ender Güzel on 5.08.2019.
//  Copyright © 2019 Creyto. All rights reserved.
//

import UIKit
import MapKit

class AddLocationViewController: UIViewController {
    
    var searchText: String!
    var mediaURL: String!
    
    override func viewDidLoad() {
        CLGeocoder().geocodeAddressString(searchText) { (placemark, error) in
            guard let placemark = placemark else {
                print(error!)
                return
            }
            print(placemark.first?.location?.coordinate as Any)
        }
    }
    
}
