//
//  PostCell.swift
//  devlslopes-Social Media (Udemy)
//
//  Created by Mahmoud Hamad on 2/28/17.
//  Copyright © 2017 Mahmoud SMGL. All rights reserved.
//

import UIKit

class PostCell: UITableViewCell {

    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var caption: UITextView!
    @IBOutlet weak var likesLbl: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }


    
    
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
