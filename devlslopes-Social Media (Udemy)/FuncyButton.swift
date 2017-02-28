//
//  FuncyButton.swift
//  devlslopes-Social Media (Udemy)
//
//  Created by Mahmoud Hamad on 2/22/17.
//  Copyright © 2017 Mahmoud SMGL. All rights reserved.
// Facebook Button & Sign In Button

import UIKit

@IBDesignable
class FuncyButton: UIButton, DropShadow {

    @IBInspectable var CompletleyCircleIt: Bool = false { //Cirlce IT
        didSet {
            if CompletleyCircleIt {
                layer.cornerRadius = self.bounds.width/2
                //layer.masksToBounds = true
            } else {
                layer.cornerRadius = 0.0
                //layer.masksToBounds = false
            }
        }
    }
    
    @IBInspectable var CornerRadius: CGFloat = 0 { //Choose Corner Radius
        didSet {
            layer.cornerRadius = CornerRadius
        }
    }
    
    @IBInspectable var addShadow: Bool = false { //Shadow It
        didSet {
            if addShadow {
                addDropShadowSMGL()
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //layer.cornerRadius = 12.0
    }

}
