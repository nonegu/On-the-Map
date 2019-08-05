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
        UdacityClient.getStudentLocations(resultOf: 100, completion: handleStudentLocationsResponse(locations:error:))
    }
    
    @IBAction func addPinPressed(_ sender: UIBarButtonItem) {
    }
    
    @IBAction func refreshPinsPressed(_ sender: UIBarButtonItem) {
        UdacityClient.getStudentLocations(resultOf: 100, completion: handleStudentLocationsResponse(locations:error:))
    }
    
    @IBAction func logoutPressed(_ sender: UIBarButtonItem) {
    }
    
    func handleStudentLocationsResponse(locations: [StudentLocation]?, error: Error?) {
        guard let locations = locations else {
            print(error!)
            return
        }
        
        LocationModel.studentLocations = locations
        
        for location in locations {
            let annotation = MKPointAnnotation()
            annotation.title = location.firstName + location.lastName
            annotation.subtitle = location.mediaURL
            let latitude = CLLocationDegrees(location.latitude)
            let longitude = CLLocationDegrees(location.longitude)
            annotation.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            DispatchQueue.main.async {
                self.mapView.addAnnotation(annotation)
            }
        }
    }
    
}

