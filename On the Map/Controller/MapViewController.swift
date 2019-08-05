//
//  MapViewController.swift
//  On the Map
//
//  Created by Ender Güzel on 5.08.2019.
//  Copyright © 2019 Creyto. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    // MARK: Outlets
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        UdacityClient.getStudentLocations(result: 100, completion: handleStudentLocationsResponse(locations:error:))
    }
    
    @IBAction func addPinPressed(_ sender: UIBarButtonItem) {
    }
    
    @IBAction func refreshPinsPressed(_ sender: UIBarButtonItem) {
    }
    
    @IBAction func logoutPressed(_ sender: UIBarButtonItem) {
    }
    
    func handleStudentLocationsResponse(locations: [StudentLocation]?, error: Error?) {
        if error != nil {
            print(error!)
        } else {
            print(locations!)
        }
    }
    
}

