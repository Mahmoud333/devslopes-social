//
//  PostCell.swift
//  devlslopes-Social Media (Udemy)
//
//  Created by Mahmoud Hamad on 2/28/17.
//  Copyright © 2017 Mahmoud SMGL. All rights reserved.
//

import UIKit
import Firebase

class PostCell: UITableViewCell {

    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var caption: UITextView!
    @IBOutlet weak var likesLbl: UILabel!
    @IBOutlet weak var createdInLbl: UILabel!
    
    func configuerCell(postData: Post, img: UIImage?){
        
        caption.text = postData.caption
        likesLbl.text = "\(postData.likes)"
        createdInLbl.text = postData.createdIn
        
        if img != nil { //chached img?
            postImage.image = img
        
        } else {        //no chached img?
            let ref = FIRStorage.storage().reference(forURL: postData.imageURL)
            ref.data(withMaxSize:  2 * 1024 * 1024, completion: { (data, error) in  //download img
                
                if error != nil {
                    print("SMGL: Unable to download image from firebase storage ")
                } else {
                    print("SMGL: Image Downloaded from firebase sotrage")
                    
                    if let imageData = data {
                        if let img = UIImage(data: imageData) {
                            
                            self.postImage.image = img
                            FeedVC.imageCache.setObject(img, forKey: postData.imageURL as NSString) //save img in chache
                        }
                    }
                }
            })
            //2mb why? u have limit for storage in firebase and users cellular data so dont go crazy with it
            
        }

        
        
            /*
        do {
            let url = URL(string: postData.imageURL)   ; print("SMGL \(url)")
            let data = try Data(contentsOf: url!)        ; print("SMGL \(data)")
            postImage.image = UIImage(data: data)
        } catch let error as NSError {
            print("SMGL: error with setting the cell image:::- \(error.localizedDescription)")
        }
            */
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
