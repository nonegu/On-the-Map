//
//  FindLocationViewController.swift
//  On the Map
//
//  Created by Ender Güzel on 5.08.2019.
//  Copyright © 2019 Creyto. All rights reserved.
//

import UIKit
import CoreLocation

class FindLocationViewController: UIViewController {
    
    // MARK: Outlets
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var mediaTextField: UITextField!
    
    var placemark: CLPlacemark?
    
    override func viewDidLoad() {
        
    }
    
    @IBAction func findLocationPressed(_ sender: UIButton) {
        guard let locationText = locationTextField.text else {
            return
        }
        
        CLGeocoder().geocodeAddressString(locationText) { (placemarks, error) in
            guard let placemarks = placemarks else {
                self.presentError(title: "Placemark Error", with: error?.localizedDescription ?? "Could not find the place")
                return
            }
            self.placemark = placemarks.first
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "addLocation", sender: self)
            }
        }
    }
    
    @IBAction func cancelPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addLocation" {
            let addLocationVC = segue.destination as! AddLocationViewController
            addLocationVC.placemark = placemark!
            addLocationVC.mediaUrl = mediaTextField.text
            addLocationVC.mapString = locationTextField.text
        }
    }
    
}
