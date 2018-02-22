//
//  FeedVC.swift
//  BackSpace
//
//  Created by Khaled Rahman Ayon on 07/02/2018.
//  Copyright © 2018 Khaled Rahman Ayon. All rights reserved.
//

import UIKit

class FeedVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var messageArray = [Message]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DataService.shared.getAllFeedMsg { (returnedMsgArray) in
            self.messageArray = returnedMsgArray.reversed()
            self.tableView.reloadData()
        }
    }
}

extension FeedVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
     
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "feedCell") as? FeedCell else { return UITableViewCell() }
        let message = messageArray[indexPath.row]
        DataService.shared.getUserName(forUid: message.senderId) { (returnedUserName) in
            StorageService.shared.downloadTask(forCurrentUserId: message.senderId, handler: { (returnedImage) in
                cell.configureCell(profileImage: returnedImage, email: returnedUserName, content: message.content)
            })
        }
        return cell
    }
}

