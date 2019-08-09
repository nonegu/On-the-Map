//
//  TableTabbedViewController.swift
//  On the Map
//
//  Created by Ender Güzel on 5.08.2019.
//  Copyright © 2019 Creyto. All rights reserved.
//

import UIKit

class TableTabbedViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // activityIndicator can only be initiated as lazy, since it requires view to be loaded.
    lazy var activityIndicator = createActivityIndicatorView()
    
    // MARK: Lifetime Methods
    override func viewDidLoad() {
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    // MARK: Button Actions
    @IBAction func addPinPressed(_ sender: UIBarButtonItem) {
        if LocationModel.userObjectId != nil {
            showUpdateWarning(segueIdentifier: "addLocationFromTable")
        } else {
            performSegue(withIdentifier: "addLocationFromTable", sender: nil)
        }
    }
    
    @IBAction func refreshPressed(_ sender: UIBarButtonItem) {
        getStudentLocations()
    }
    
    @IBAction func logoutPressed(_ sender: UIBarButtonItem) {
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        UdacityClient.logout { (success, error) in
            if success {
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    UIApplication.shared.endIgnoringInteractionEvents()
                    self.dismiss(animated: true, completion: nil)
                }
            } else {
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    UIApplication.shared.endIgnoringInteractionEvents()
                    self.presentError(title: "Logout Error", with: error?.localizedDescription ?? "")
                }
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
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.activityIndicator.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()
        }
    }
    
    // MARK: TableView Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return LocationModel.studentLocations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let fullName = LocationModel.studentLocations[indexPath.row].firstName + " " + LocationModel.studentLocations[indexPath.row].lastName
        cell.textLabel?.text = fullName
        
        let detail = LocationModel.studentLocations[indexPath.row].mediaURL
        cell.detailTextLabel?.text = detail
        
        let pinImage = UIImage(named: "icon_pin")
        cell.imageView?.image = pinImage
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        let urlString = cell?.detailTextLabel?.text
        if let url = URL(string: urlString!) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
}
