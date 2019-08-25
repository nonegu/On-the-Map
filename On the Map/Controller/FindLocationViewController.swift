//
//  FindLocationViewController.swift
//  On the Map
//
//  Created by Ender Güzel on 5.08.2019.
//  Copyright © 2019 Creyto. All rights reserved.
//

import UIKit
import CoreLocation

class FindLocationViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: Outlets
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var mediaTextField: UITextField!
    @IBOutlet weak var findButton: UIButton!
    
    
    var placemark: CLPlacemark?
    
    // activityIndicator can only be initiated as lazy, since it requires view to be loaded.
    lazy var activityIndicator = createActivityIndicatorView()
    
    // MARK: Lifetime Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        locationTextField.delegate = self
        mediaTextField.delegate = self
        findButton.layer.cornerRadius = 5.0
        
        // Preparing UI before the userData request
        activityIndicator.startAnimating()
        view.addSubview(activityIndicator)
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        // Getting the user data before posting a new location
        UdacityClient.getUserData(completion: handleUserDataResponse(success:error:))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        subscribeToKeyboardNotifications()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        unsubscribeToKeyboardNotifications()
    }
    
    // MARK: Button Actions
    @IBAction func findLocationPressed(_ sender: UIButton) {
        
        if isTextFieldsFilledIn() {
            
            activityIndicator.startAnimating()
            view.addSubview(activityIndicator)
            UIApplication.shared.beginIgnoringInteractionEvents()
            
            // MARK: the text of locationTextField.text already checked, so we can safely force unwrap it.
            CLGeocoder().geocodeAddressString((locationTextField.text)!) { (placemarks, error) in
                guard let placemarks = placemarks else {
                    DispatchQueue.main.async {
                        self.activityIndicator.stopAnimating()
                        UIApplication.shared.endIgnoringInteractionEvents()
                        
                        self.presentError(title: "Search Error", with: "We did not find any location. Please check for typing or network errors.")
                    }
                    return
                }
                self.placemark = placemarks.first
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    UIApplication.shared.endIgnoringInteractionEvents()
                    
                    self.performSegue(withIdentifier: "addLocation", sender: self)
                }
            }
        }
    }
    
    @IBAction func cancelPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: Sending necessary information to AddLocationView controller
    // to show the placemark on the map and to create the body of the post request.
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
    
    func handleUserDataResponse(success: Bool, error: Error?) {
        
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()
        }
        if error != nil {
            DispatchQueue.main.async {
                self.presentError(title: "User Data Error", with: "Can not retrieve user data, your name will not be posted with the location. Try to re-login.")
            }
        }
    }
    
    // MARK: Textfield Methods
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
}
