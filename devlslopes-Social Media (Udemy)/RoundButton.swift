//
//  RoundButton.swift
//  devlslopes-Social Media (Udemy)
//
//  Created by Mahmoud Hamad on 2/22/17.
//  Copyright © 2017 Mahmoud SMGL. All rights reserved.
//
//Used to be For Facebook Button  


//NOT USING THEM [Using FuncyButton instead & put its code their]
//NOT USING THEM [Using FuncyButton instead & put its code their]


import UIKit

class RoundButton: UIButton, DropShadow {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.addDropShadow()
        imageView?.contentMode = .scaleAspectFit
    }

    //will do it here bec. in this point the self.size has been decided in awakeFromNib we dont
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = self.bounds.width/2
    }
}

