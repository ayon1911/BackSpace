//
//  CreateGroupVC.swift
//  BackSpace
//
//  Created by Khaled Rahman Ayon on 19.02.18.
//  Copyright © 2018 Khaled Rahman Ayon. All rights reserved.
//

import UIKit
import Firebase

class CreateGroupVC: UIViewController {

    @IBOutlet weak var titleTextField: InsetTextField!
    @IBOutlet weak var descTextField: InsetTextField!
    @IBOutlet weak var userSearchTextField: InsetTextField!
    @IBOutlet weak var addedGroupMemberLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var doneBtn: UIButton!
    
    var emailArray = [String]()
    var chosenUserArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        userSearchTextField.delegate = self
        userSearchTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        doneBtn.isHidden = true
    }
    
    @objc func textFieldDidChange() {
        if userSearchTextField.text == "" {
            emailArray = []
            tableView.reloadData()
        } else {
            DataService.shared.getEmail(withSearchQuery: userSearchTextField.text!, handler: { (returnedUserEmails) in
                self.emailArray = returnedUserEmails
                self.tableView.reloadData()
            })
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
    @IBAction func doneBtnPressed(_ sender: Any) {
        if titleTextField.text != "" && descTextField.text != "" {
            DataService.shared.getIds(forUserName: chosenUserArray, handler: { (returnedIdsArray) in
                var userIds = returnedIdsArray
                userIds.append((Auth.auth().currentUser?.uid)!)
                
                DataService.shared.createGroup(withTitle: self.titleTextField.text!, withDescription: self.descTextField.text!, forUserIds: userIds, handler: { (success, error) in
                    if success {
                        self.dismiss(animated: true, completion: nil)
                    } else {
                        debugPrint(error as Any)
                    }
                })
            })
        }
    }
    
    @IBAction func closeBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension CreateGroupVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return emailArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "userCell") as? UserCell else { return UITableViewCell() }
        let profileImage = UIImage(named: "defaultProfileImage")!
        if chosenUserArray.contains(emailArray[indexPath.row]) {
            cell.configureCell(profileImage: profileImage, email: emailArray[indexPath.row], isSelected: true)
        } else {
            cell.configureCell(profileImage: profileImage, email: emailArray[indexPath.row], isSelected: false)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? UserCell else { return }
        if !chosenUserArray.contains(cell.emailLbl.text!) {
           chosenUserArray.append(cell.emailLbl.text!)
            addedGroupMemberLbl.text = chosenUserArray.joined(separator: ", ")
            doneBtn.isHidden = false
        } else {
            chosenUserArray = chosenUserArray.filter({ $0 != cell.emailLbl.text!})
           if chosenUserArray.count >= 1 {
                addedGroupMemberLbl.text = chosenUserArray.joined(separator: ", ")
           } else {
            addedGroupMemberLbl.text = "add people to your group"
            doneBtn.isHidden = true
            }
        }
    }
}

extension CreateGroupVC: UITextFieldDelegate {
    
}
