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
        if LocationModel.userObjectId != nil {
            showUpdateWarning()
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
            print(error!)
            return
        }
        
        LocationModel.studentLocations = locations
        print(locations)
        
        var annotations = [MKPointAnnotation]()
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
            self.mapView.addAnnotations(annotations)
        }
    }
    
    func showUpdateWarning() {
        let alertVC = UIAlertController(title: "Your location is already posted", message: "Do you want to update your location?", preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "Update", style: .default, handler: { (alert) in
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "addLocation", sender: nil)
            }
        }))
        alertVC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
    
}

