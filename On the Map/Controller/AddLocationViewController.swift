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
    
    // MARK: Outlets
    @IBOutlet weak var mapView: MKMapView!
    
    var placemark: CLPlacemark!
    var mediaUrl: String!
    var mapString: String!
    
    override func viewDidLoad() {
        
        setAnnotation(with: placemark)
        setRegion(with: placemark)
    }
    
    @IBAction func finishPressed(_ sender: UIButton) {
        guard let coordinate = placemark.location?.coordinate else {
            return
        }
        // Following body requested as hardcoded. However, we could receive the user data from UdacityAPI
        // Storing the objectId of posted user location, would help when updating it
        // UserDefaults could be used for such small data.
        let body = UserLocationRequest(uniqueKey: "1234", firstName: "Hugh", lastName: "Laurie", mapString: mapString, mediaURL: mediaUrl, latitude: coordinate.latitude, longitude: coordinate.longitude)
        UdacityClient.markUserLocation(body: body, completion: handleMarkUserLocationResponse(success:error:))
    }
    
    func handleMarkUserLocationResponse(success: Bool, error: Error?) {
        if success {
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
            }
        } else {
            print(error!)
        }
    }
    
    func setAnnotation(with placemark: CLPlacemark) {
        guard let coordinate = placemark.location?.coordinate else {
            return
        }
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        DispatchQueue.main.async {
            self.mapView.addAnnotation(annotation)
        }
    }
    
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
    
}
