//
//  GroupCell.swift
//  BackSpace
//
//  Created by Khaled Rahman Ayon on 20.02.18.
//  Copyright © 2018 Khaled Rahman Ayon. All rights reserved.
//

import UIKit

class GroupCell: UITableViewCell {
    
    @IBOutlet weak var groupTitleLbl: UILabel!
    @IBOutlet weak var groupDescLbl: UILabel!
    @IBOutlet weak var membersLbl: UILabel!
    
    func configureCell(title: String, description: String, memmersCount: Int) {
        self.groupTitleLbl.text = title
        self.groupDescLbl.text = description
        self.membersLbl.text = "\(memmersCount) members."
    }
    
}
