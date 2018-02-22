//
//  CreatePostVC.swift
//  BackSpace
//
//  Created by Khaled Rahman Ayon on 19.02.18.
//  Copyright © 2018 Khaled Rahman Ayon. All rights reserved.
//

import UIKit
import Firebase

class CreatePostVC: UIViewController {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var postTextView: UITextView!
    @IBOutlet weak var sendBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        postTextView.delegate = self
        sendBtn.bindToKeyboard()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.emailLbl.text = Auth.auth().currentUser?.email
        StorageService.shared.downloadTask(forCurrentUserId: (Auth.auth().currentUser?.uid)!) { (returnedImage) in
            self.profileImage.image = returnedImage
        }
    }

    @IBAction func closeBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func sendBtnPressed(_ sender: Any) {
        if postTextView.text != "" && postTextView.text != "Say something...." {
            sendBtn.isEnabled = false
            DataService.shared.uploadPost(withMessage: postTextView.text, forUID: (Auth.auth().currentUser?.uid)!, withGroupKey: nil, handler: { (success, error) in
                if success {
                    self.sendBtn.isEnabled = true
                    self.dismiss(animated: true, completion: nil)
                } else {
                    debugPrint(error as Any)
                }
            })
        }
    }
}

extension CreatePostVC: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        postTextView.text = ""
    }
}
