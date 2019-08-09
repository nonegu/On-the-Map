//
//  ShowLocationViewController.swift
//  On the Map
//
//  Created by Ender Güzel on 5.08.2019.
//  Copyright © 2019 Creyto. All rights reserved.
//

import UIKit
import MapKit

class AddLocationViewController: UIViewController, MKMapViewDelegate {
    
    // MARK: Outlets
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var finishButton: UIButton!
    
    // MARK: Properties
    var placemark: CLPlacemark!
    var mediaUrl: String!
    var mapString: String!
    lazy var activityIndicator = createActivityIndicatorView()
    
    override func viewDidLoad() {
        
        finishButton.layer.cornerRadius = 5.0
        setAnnotation(with: placemark)
        setRegion(with: placemark)
        
        // Since the Udacity API has an issue regarding the userDataResponse, the UserLocationRequest created by hardcoding.
        // There is a topic in Knowledge section about this issue and it has not been corrected yet.
        // UdacityClient.getUserData(completion: handleUserDataResponse(success:error:))
    }
    
    // MARK: Button Action
    @IBAction func finishPressed(_ sender: UIButton) {
        guard let coordinate = placemark.location?.coordinate else {
            return
        }
        activityIndicator.startAnimating()
        view.addSubview(activityIndicator)
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        // When the UdacityAPI is corrected, following can be used as the body.
//        let body = UserLocationRequest(uniqueKey: "1234", firstName: UdacityClient.Auth.userFirstName, lastName: UdacityClient.Auth.userLastName, mapString: mapString, mediaURL: mediaUrl, latitude: coordinate.latitude, longitude: coordinate.longitude)
        
        // Following body requested as hardcoded.
        let body = UserLocationRequest(uniqueKey: "1234", firstName: "Hugh", lastName: "Laurie", mapString: mapString, mediaURL: mediaUrl, latitude: coordinate.latitude, longitude: coordinate.longitude)
        if LocationModel.userObjectId == nil {
            UdacityClient.markUserLocation(body: body, completion: handleUserLocationResponse(success:error:))
        } else {
            UdacityClient.updateUserLocation(body: body, completion: handleUserLocationResponse(success:error:))
        }
    }
    
    func handleUserLocationResponse(success: Bool, error: Error?) {
        
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()
        }
        
        if success {
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
            }
        } else {
            presentError(title: "Response Error", with: error?.localizedDescription ?? "Could not retrieve response")
        }
    }
    
//    func handleUserDataResponse(success: Bool, error: Error?) {
//        
//        if error != nil {
//            presentError(title: "User Data Error", with: "Can not retrieve user data.")
//        }
//    }
    
    // MARK: Adding an annotation at the search result.
    func setAnnotation(with placemark: CLPlacemark) {
        guard let coordinate = placemark.location?.coordinate else {
            return
        }
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = "\(placemark.name!), \(placemark.country!)"
        DispatchQueue.main.async {
            self.mapView.addAnnotation(annotation)
        }
    }
    
    // MARK: Following will set the region, to focus on the map where the annotation placed.
    func setRegion(with placemark: CLPlacemark) {
        guard let coordinate = placemark.location?.coordinate else {
            return
        }
        let userLocation: CLLocationCoordinate2D = coordinate
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region: MKCoordinateRegion = MKCoordinateRegion(center: userLocation, span: span)
        
        DispatchQueue.main.async {
            self.mapView.setRegion(region, animated: true)
        }
    }
    
    // MARK: MapView Delegate Method
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
}
