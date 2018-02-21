//
//  AuthVC.swift
//  BackSpace
//
//  Created by Khaled Rahman Ayon on 18.02.18.
//  Copyright © 2018 Khaled Rahman Ayon. All rights reserved.
//

import UIKit
import Firebase

class AuthVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if Auth.auth().currentUser != nil {
            dismiss(animated: true, completion: nil)
        }
    }
    

    @IBAction func signInWithEmailBtnPressed(_ sender: Any) {
        guard let loginVC = storyboard?.instantiateViewController(withIdentifier: LOGIN_VC) else { return }
        present(loginVC, animated: true, completion: nil)
        
    }
    
    @IBAction func googleSignInBtnPressed(_ sender: Any) {
    }
    
    @IBAction func facebookSignInBtnPressed(_ sender: Any) {
 
    }
}
