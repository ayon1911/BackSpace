//
//  ShadowView.swift
//  BackSpace
//
//  Created by Khaled Rahman Ayon on 18.02.18.
//  Copyright © 2018 Khaled Rahman Ayon. All rights reserved.
//

import UIKit

class ShadowView: UIView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpView()
    }

    func setUpView() {
        self.layer.shadowOpacity = 0.75
        self.layer.shadowRadius = 5
        self.layer.shadowColor = #colorLiteral(red: 0.06274510175, green: 0, blue: 0.1921568662, alpha: 1)
        self.setNeedsLayout()
    }
    
}
