//
//  CircleImageView.swift
//  devlslopes-Social Media (Udemy)
//
//  Created by Mahmoud Hamad on 2/28/17.
//  Copyright © 2017 Mahmoud SMGL. All rights reserved.
//

import UIKit

@IBDesignable
class CircleImageView: UIImageView, DropShadow {

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

    @IBInspectable var addShadow: Bool = false {
        didSet {
            if addShadow {
                addDropShadowSMGL()
            }
        }
    }

}
