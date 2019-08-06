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
    
    var placemark: CLPlacemark!
    
    override func viewDidLoad() {
        print(placemark.location?.coordinate as Any)
    }
    
}
