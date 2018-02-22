//
//  AuthService.swift
//  BackSpace
//
//  Created by Khaled Rahman Ayon on 19.02.18.
//  Copyright © 2018 Khaled Rahman Ayon. All rights reserved.
//

import Foundation
import Firebase

class AuthService {
    static let shared = AuthService()
    
    func registerUser(withEmail email: String, andPassword password: String, registratioComplete: @escaping handler) {
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            guard let user = user else {
                registratioComplete(false, error)
                return
            }
            let userData = ["provider": user.providerID, "email": user.email]
            DataService.shared.createDbUser(uid: user.uid, userData: userData)
            registratioComplete(true, nil)
        }
    }
    
    func loginUser(withEmail email: String, andPassword password: String, loginComplete: @escaping handler) {
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if error != nil {
                loginComplete(false, error)
            }
            loginComplete(true, nil)
        }
    }
    
    func addProfileImage(withUrl url: String, handler: @escaping handler) {
        DataService.shared.REF_USER.child((Auth.auth().currentUser?.uid)!).updateChildValues(["profileUrl" : url])
        handler(true, nil)
    }
}
