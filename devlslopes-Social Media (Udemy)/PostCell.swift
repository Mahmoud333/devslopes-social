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
    @IBOutlet weak var createdInLbl: UILabel!
    
    func configuerCell(postData: Post){
        
        caption.text = postData.caption
        likesLbl.text = "\(postData.likes)"
        createdInLbl.text = postData.createdIn
        
        do {
            let url = URL(string: postData.imageURL)!   ; print("SMGL \(url)")
            let data = try Data(contentsOf: url)        ; print("SMGL \(data)")
            postImage.image = UIImage(data: data)
        } catch let error as NSError {
            print("SMGL: error with setting the cell image:::- \(error.localizedDescription)")
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
