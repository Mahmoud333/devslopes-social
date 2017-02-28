//
//  Constants.swift
//  devlslopes-Social Media (Udemy)
//
//  Created by Mahmoud Hamad on 2/22/17.
//  Copyright © 2017 Mahmoud SMGL. All rights reserved.
//

import UIKit //have foundation in it

struct C {
    static let SHADOW_GRAY: CGFloat = 120.0/255.0 //Color For Shadow
    
    static let KEY_UID = "uid" //For Keychain
    
    static let Cell_Ident = "PostCell"
    
    enum Segues: String {
        case ToFeed = "goToFeed"
    }
}


extension UIViewController {
    func errorAlertSMGL(errorString: String) {
        let messageText = errorString
        let ac = UIAlertController(title: "Error", message: messageText, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(ac, animated: true, completion: nil)
    }
}
