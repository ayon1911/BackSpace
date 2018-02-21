//
//  GroupFeedCell.swift
//  BackSpace
//
//  Created by Khaled Rahman Ayon on 20.02.18.
//  Copyright © 2018 Khaled Rahman Ayon. All rights reserved.
//

import UIKit

class GroupFeedCell: UITableViewCell {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var contentLbl: UILabel!
    
    func configureCell(profileImage: UIImage, emailLbl: String, contentLbl: String) {
        self.profileImage.image = profileImage
        self.emailLbl.text = emailLbl
        self.contentLbl.text = contentLbl
    }
    

}
