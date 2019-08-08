//
//  TableTabbedViewController.swift
//  On the Map
//
//  Created by Ender Güzel on 5.08.2019.
//  Copyright © 2019 Creyto. All rights reserved.
//

import UIKit

class TableTabbedViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    @IBAction func addPinPressed(_ sender: UIBarButtonItem) {
        if LocationModel.userObjectId != nil {
            showUpdateWarning()
        } else {
            performSegue(withIdentifier: "addLocationFromTable", sender: nil)
        }
    }
    
    @IBAction func refreshPressed(_ sender: UIBarButtonItem) {
        UdacityClient.getStudentLocations(resultOf: 100, completion: handleStudentLocationsResponse(locations:error:))
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
    
    func handleStudentLocationsResponse(locations: [StudentInformation]?, error: Error?) {
        guard let locations = locations else {
            presentError(title: "Error", with: error?.localizedDescription ?? "Could not retrieve data")
            return
        }
        
        LocationModel.studentLocations = locations
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
}
