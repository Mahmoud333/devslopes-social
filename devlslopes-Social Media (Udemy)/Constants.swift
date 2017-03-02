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
    
    func getDateAndTimeSMGL() -> String {
        
        // get the current date and time
        let currentDateTime = Date()
        
        // get the user's calendar
        let userCalendar = Calendar.current
        
        // choose which date and time components are needed
        let requestedComponents: Set<Calendar.Component> = [
            .year,
            .month,
            .day,
            .hour,
            .minute,
            .second
        ]
        
        // get the components
        let dateTimeComponents = userCalendar.dateComponents(requestedComponents, from: currentDateTime)
        
        
        return "\(dateTimeComponents.hour!):\(dateTimeComponents.minute!):\(dateTimeComponents.second!) - \(dateTimeComponents.day!)/\(dateTimeComponents.month!)/\(dateTimeComponents.year!)"
        //hour:minute - day/month/year
        
        // now the components are available
        /*
        dateTimeComponents.year   // 2016
        dateTimeComponents.month  // 10
        dateTimeComponents.day    // 8
        dateTimeComponents.hour   // 22
        dateTimeComponents.minute // 42
        dateTimeComponents.second // 17
        */
    }
}
