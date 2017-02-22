//
//  FuncyButton.swift
//  devlslopes-Social Media (Udemy)
//
//  Created by Mahmoud Hamad on 2/22/17.
//  Copyright © 2017 Mahmoud SMGL. All rights reserved.
//

import UIKit

class FuncyButton: UIButton, DropShadow {

    @IBInspectable var CompletleyCircleIt: Bool = false {
        didSet {
            if CompletleyCircleIt {
                layer.cornerRadius = self.bounds.width/2
            } else {
                layer.cornerRadius = 0.0
            }
        }
    }
    
    @IBInspectable var CornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = CornerRadius
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        addDropShadow()
        //layer.cornerRadius = 12.0
    }

}
