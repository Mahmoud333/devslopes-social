//
//  FancyTextField.swift
//  devlslopes-Social Media (Udemy)
//
//  Created by Mahmoud Hamad on 2/22/17.
//  Copyright © 2017 Mahmoud SMGL. All rights reserved.
//

import UIKit

class FancyTextField: UITextField {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.borderColor = UIColor(red: C.SHADOW_GRAY, green: C.SHADOW_GRAY, blue: C.SHADOW_GRAY, alpha: 0.2).cgColor //body border
        layer.borderWidth = 1.0
    }
    
    //sort the inside out [text is on the border and textfield size shrinked on the text]
    //placeholder text on top off the border
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 10, dy: 5) //10 from the left
    }
    
    //when you typing the text in
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 10, dy: 5) //10 from the left
    }

}
