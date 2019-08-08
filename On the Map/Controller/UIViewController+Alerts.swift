//
//  UIViewController+Warnings.swift
//  On the Map
//
//  Created by Ender Güzel on 8.08.2019.
//  Copyright © 2019 Creyto. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func presentError(title: String, with message: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
    
    func showUpdateWarning(segueIdentifier: String) {
        let alertVC = UIAlertController(title: "Your location is already posted", message: "Do you want to update your location?", preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "Update", style: .default, handler: { (alert) in
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: segueIdentifier, sender: nil)
            }
        }))
        alertVC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
    
}
