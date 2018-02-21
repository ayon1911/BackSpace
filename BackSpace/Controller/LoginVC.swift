//
//  LoginVC.swift
//  BackSpace
//
//  Created by Khaled Rahman Ayon on 18.02.18.
//  Copyright © 2018 Khaled Rahman Ayon. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {
    
    @IBOutlet weak var emailField: InsetTextField!
    @IBOutlet weak var passwordField: InsetTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailField.delegate = self
        passwordField.delegate = self
        // Do any additional setup after loading the view.
    }
    @IBAction func signInBtnPressed(_ sender: Any) {
        if emailField.text != nil && passwordField.text != nil {
            AuthService.shared.loginUser(withEmail: emailField.text!, andPassword: passwordField.text!, loginComplete: { (success, loginError) in
                if success {
                    self.dismiss(animated: true, completion: nil)
                } else {
                    debugPrint(loginError as Any)
                }
                AuthService.shared.registerUser(withEmail: self.emailField.text!, andPassword: self.passwordField.text!, registratioComplete: { (success, registrationError) in
                    if success {
                        AuthService.shared.loginUser(withEmail: self.emailField.text!, andPassword: self.passwordField.text!, loginComplete: { (success, nil) in
                            print("Successfully login user")
                            self.dismiss(animated: true, completion: nil)
                        })
                    } else {
                        debugPrint(registrationError as Any)
                    }
                })
                
            })
        }
    }
    
    @IBAction func closeBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension LoginVC: UITextFieldDelegate {
    
}
