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
    
    // MARK: Alert Controller
    func showUpdateWarning() {
        let alertVC = UIAlertController(title: "Your location is already posted", message: "Do you want to update your location?", preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "Update", style: .default, handler: { (alert) in
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "addLocationFromTable", sender: nil)
            }
        }))
        alertVC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
    
}
