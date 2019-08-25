//
//  ViewController.swift
//  On the Map
//
//  Created by Ender Güzel on 5.08.2019.
//  Copyright © 2019 Creyto. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: Outlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    lazy var activityIndicator = createActivityIndicatorView()
    
    // MARK: Lifetime Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        emailTextField.delegate = self
        passwordTextField.delegate = self
        loginButton.layer.cornerRadius = 5.0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        subscribeToKeyboardNotifications()
        emailTextField.text = ""
        passwordTextField.text = ""
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        unsubscribeToKeyboardNotifications()
    }

    @IBAction func loginPressed(_ sender: UIButton) {
        
        activityIndicator.startAnimating()
        view.addSubview(activityIndicator)
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        UdacityClient.login(username: emailTextField.text!, password: passwordTextField.text!, completion: handleLoginResponse(success:error:))
    }
    
    @IBAction func signUpPressed(_ sender: UIButton) {
        
        guard let signupURL = URL(string: "https://auth.udacity.com/sign-up") else {
            return
        }

        UIApplication.shared.open(signupURL, options: [:], completionHandler: nil)
    }
    
    func handleLoginResponse(success: Bool, error: Error?) {
        
        if success {
            activityIndicator.stopAnimating()
            DispatchQueue.main.async {
                UIApplication.shared.endIgnoringInteractionEvents()
                self.performSegue(withIdentifier: "completeLogin", sender: nil)
            }
        } else {
            activityIndicator.stopAnimating()
            DispatchQueue.main.async {
                UIApplication.shared.endIgnoringInteractionEvents()
                self.presentError(title: "Login Failed", with: error?.localizedDescription ?? "")
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
}

