//
//  UIViewController+Warnings.swift
//  On the Map
//
//  Created by Ender Güzel on 8.08.2019.
//  Copyright © 2019 Creyto. All rights reserved.
//

import UIKit

extension UIViewController {
    
    
    // MARK: Alerts
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
    
    // MARK: Creating an Activity Indicator
    func createActivityIndicatorView() -> UIActivityIndicatorView {
        let indicator = UIActivityIndicatorView(style: .whiteLarge)
        indicator.hidesWhenStopped = true
        indicator.center = view.center
        indicator.color = #colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1)
        return indicator
    }
    
}
