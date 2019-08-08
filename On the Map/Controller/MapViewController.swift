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
    
    // activityIndicator can only be initiated as lazy, since it requires view to be loaded.
    lazy var activityIndicator = createActivityIndicatorView()
    var annotations = [MKPointAnnotation]()
    
    
    // MARK: Lifetime Methods
    override func viewDidLoad() {
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getStudentLocations()
    }
    
    
    // MARK: Buttons
    @IBAction func addPinPressed(_ sender: UIBarButtonItem) {
        if LocationModel.userObjectId != nil {
            showUpdateWarning(segueIdentifier: "addLocation")
        } else {
            performSegue(withIdentifier: "addLocation", sender: nil)
        }
    }
    
    @IBAction func refreshPinsPressed(_ sender: UIBarButtonItem) {
        getStudentLocations()
    }
    
    @IBAction func logoutPressed(_ sender: UIBarButtonItem) {
        UdacityClient.logout { (success, error) in
            if success {
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
                }
            } else {
                self.presentError(title: "Logout Error", with: error?.localizedDescription ?? "")
            }
        }
    }
    
    
    // MARK: Student Locations' GET Methods
    func getStudentLocations() {
        activityIndicator.startAnimating()
        view.addSubview(activityIndicator)
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        UdacityClient.getStudentLocations(resultOf: 100, completion: handleStudentLocationsResponse(locations:error:))
    }
    
    func handleStudentLocationsResponse(locations: [StudentInformation]?, error: Error?) {
        guard let locations = locations else {
            presentError(title: "Error", with: error?.localizedDescription ?? "Could not retrieve data")
            return
        }
        
        LocationModel.studentLocations = locations
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
            self.activityIndicator.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()
        }
    }
    
}

