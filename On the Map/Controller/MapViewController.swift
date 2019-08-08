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
    
    var annotations = [MKPointAnnotation]()
    
    override func viewDidLoad() {
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        UdacityClient.getStudentLocations(resultOf: 100, completion: handleStudentLocationsResponse(locations:error:))
    }
    
    @IBAction func addPinPressed(_ sender: UIBarButtonItem) {
        if LocationModel.userObjectId != nil {
            showUpdateWarning(segueIdentifier: "addLocation")
        } else {
            performSegue(withIdentifier: "addLocation", sender: nil)
        }
    }
    
    @IBAction func refreshPinsPressed(_ sender: UIBarButtonItem) {
        UdacityClient.getStudentLocations(resultOf: 100, completion: handleStudentLocationsResponse(locations:error:))
    }
    
    @IBAction func logoutPressed(_ sender: UIBarButtonItem) {
    }
    
    func handleStudentLocationsResponse(locations: [StudentInformation]?, error: Error?) {
        guard let locations = locations else {
            presentError(title: "Error", with: error?.localizedDescription ?? "Could not retrieve data")
            return
        }
        
        LocationModel.studentLocations = locations
        print(locations)
        updateAnnotations(with: locations)
        
    }
    
    func updateAnnotations(with locations: [StudentInformation]) {
    
        DispatchQueue.main.async {
            self.mapView.removeAnnotations(self.annotations)
        }
        
        annotations = []
        
        for location in locations {
            let annotation = MKPointAnnotation()
            annotation.title = "\(location.firstName) \(location.lastName)"
            annotation.subtitle = location.mediaURL
            let latitude = CLLocationDegrees(location.latitude)
            let longitude = CLLocationDegrees(location.longitude)
            annotation.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            annotations.append(annotation)
        }
        DispatchQueue.main.async {
            self.mapView.addAnnotations(self.annotations)
        }
    }
    
}

