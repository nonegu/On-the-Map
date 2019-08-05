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
        tableView.reloadData()
    }
    
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
    
}
