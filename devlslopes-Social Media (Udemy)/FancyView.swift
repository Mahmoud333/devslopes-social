//
//  FancyView.swift
//  devlslopes-Social Media (Udemy)
//
//  Created by Mahmoud Hamad on 2/22/17.
//  Copyright © 2017 Mahmoud SMGL. All rights reserved.
//

import UIKit

class FancyView: UIView ,DropShadow{

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.addDropShadow()
        
    }

}
