//
//  ViewController.swift
//  On the Map
//
//  Created by Ender Güzel on 5.08.2019.
//  Copyright © 2019 Creyto. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    // MARK: Outlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    lazy var activityIndicator = createActivityIndicatorView()
    
    // MARK: Lifetime Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        emailTextField.text = ""
        passwordTextField.text = ""
    }

    @IBAction func loginPressed(_ sender: UIButton) {
        
        activityIndicator.startAnimating()
        view.addSubview(activityIndicator)
        
        UdacityClient.login(username: emailTextField.text!, password: passwordTextField.text!, completion: handleLoginResponse(success:error:))
    }
    
    func handleLoginResponse(success: Bool, error: Error?) {
        
        if success {
            activityIndicator.stopAnimating()
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "completeLogin", sender: nil)
            }
        } else {
            activityIndicator.stopAnimating()
            presentError(title: "Login Failed", with: error?.localizedDescription ?? "")
        }
    }
    
}

