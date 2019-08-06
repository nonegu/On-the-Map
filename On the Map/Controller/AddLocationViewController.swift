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
    
    override func viewDidLoad() {
        
        setAnnotation(with: placemark)
        setRegion(with: placemark)
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
