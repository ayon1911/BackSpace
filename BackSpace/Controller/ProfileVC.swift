//
//  ProfileVC.swift
//  BackSpace
//
//  Created by Khaled Rahman Ayon on 19.02.18.
//  Copyright © 2018 Khaled Rahman Ayon. All rights reserved.
//

import UIKit
import Firebase

class ProfileVC: UIViewController {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        // Do any additional setup after loading the view.
        let tap = UITapGestureRecognizer(target: self, action: #selector(addTapedAction(_:)))
        profileImage.addGestureRecognizer(tap)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.emailLbl.text = Auth.auth().currentUser?.email
        DataService.shared.REF_USER.observe(.value) { (snapshot) in
            StorageService.shared.downloadTask(forCurrentUserId: (Auth.auth().currentUser?.uid)!) { (returnedImage) in
                self.profileImage.image = returnedImage
            }
        }
    }
    
    @IBAction func signOutBtnPressed(_ sender: Any) {
        let logoutPopUp = UIAlertController(title: "LogOut?", message: "Are you sure you want to logout", preferredStyle: .actionSheet)
        let logoutAction = UIAlertAction(title: "LogOut", style: .destructive) { (action) in
            do {
                try Auth.auth().signOut()
                guard let loginVC = self.storyboard?.instantiateViewController(withIdentifier: AUTH_VC) as? AuthVC else { return }
                self.present(loginVC, animated: true, completion: nil)
            } catch let err {
                debugPrint(err as Any)
            }
        }
        
        logoutPopUp.addAction(logoutAction)
        present(logoutPopUp, animated: true, completion: nil)
    }
    
    @objc func addTapedAction(_ gesture: UITapGestureRecognizer) {
        print("Tapped")
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
}

extension ProfileVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            StorageService.shared.uploadTask(forImage: pickedImage, andFileName: (Auth.auth().currentUser?.uid)!, handler: { (success, error) in
                if success {
                    print("Upload Successfull")
                } else {
                    debugPrint(error as Any)
                }
            })
        }
        dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
