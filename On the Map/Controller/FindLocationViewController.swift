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
    @IBOutlet weak var findButton: UIButton!
    
    
    var placemark: CLPlacemark?
    
    // activityIndicator can only be initiated as lazy, since it requires view to be loaded.
    lazy var activityIndicator = createActivityIndicatorView()
    
    override func viewDidLoad() {
        findButton.layer.cornerRadius = 5.0
    }
    
    @IBAction func findLocationPressed(_ sender: UIButton) {
        
        if isTextFieldsFilledIn() {
            guard let locationText = locationTextField.text else {
                return
            }
            
            activityIndicator.startAnimating()
            view.addSubview(activityIndicator)
            UIApplication.shared.beginIgnoringInteractionEvents()
            
            CLGeocoder().geocodeAddressString(locationText) { (placemarks, error) in
                guard let placemarks = placemarks else {
                    DispatchQueue.main.async {
                        self.activityIndicator.stopAnimating()
                        self.view.addSubview(self.activityIndicator)
                        UIApplication.shared.endIgnoringInteractionEvents()
                        
                        self.presentError(title: "Search Error", with: "We did not find any location. Please check for typing or network errors.")
                    }
                    return
                }
                self.placemark = placemarks.first
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    self.view.addSubview(self.activityIndicator)
                    UIApplication.shared.endIgnoringInteractionEvents()
                    
                    self.performSegue(withIdentifier: "addLocation", sender: self)
                }
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
    
    func isTextFieldsFilledIn() -> Bool {
        if locationTextField.text == "" {
            presentError(title: "Location can not be empty", with: "Please enter a valid adress")
            return false
        } else if mediaTextField.text == "" {
            presentError(title: "Link can not be empty", with: "Please enter a valid link")
            return false
        } else {
            return true
        }
    }
    
}
