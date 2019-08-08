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
    
    // MARK: Properties
    var placemark: CLPlacemark!
    var mediaUrl: String!
    var mapString: String!
    lazy var activityIndicator = createActivityIndicatorView()
    
    override func viewDidLoad() {
        
        setAnnotation(with: placemark)
        setRegion(with: placemark)
    }
    
    // MARK: Button Action
    @IBAction func finishPressed(_ sender: UIButton) {
        guard let coordinate = placemark.location?.coordinate else {
            return
        }
        activityIndicator.startAnimating()
        view.addSubview(activityIndicator)
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        // Following body requested as hardcoded. However, we could receive the user data from UdacityAPI
        // Storing the objectId of posted user location, would help when updating it
        // UserDefaults could be used for such small data.
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
