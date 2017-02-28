//
//  FancyView.swift
//  devlslopes-Social Media (Udemy)
//
//  Created by Mahmoud Hamad on 2/22/17.
//  Copyright © 2017 Mahmoud SMGL. All rights reserved.
//

import UIKit

@IBDesignable
class FancyView: UIView ,DropShadow{

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
        
        self.addDropShadowSMGL()
        
    }

}
