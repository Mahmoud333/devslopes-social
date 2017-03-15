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
    @IBOutlet weak var likeImg: UIImageView!
    
    var post: Post!

    var userLikesRef: FIRDatabaseReference!
    //var userLikesRef = DataService.ds.REF_USER_CURRENT.child("likes").child(post)
    //Users -> currentUser -> Posts he Likes -> postkey
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let tap = UITapGestureRecognizer(target: self, action: #selector(LikeTapped))
        tap.numberOfTapsRequired = 1
        likeImg.isUserInteractionEnabled = true
        likeImg.addGestureRecognizer(tap)
    }
    
    func configuerCell(postData: Post, img: UIImage?){

        self.post = postData
        
        userLikesRef = DataService.ds.REF_USER_CURRENT.child("likes").child(post.postKey)
        
        caption.text = postData.caption
        likesLbl.text = "\(postData.likes)"
        createdInLbl.text = postData.createdIn
        
        if img != nil { //we have chached img?
            postImage.image = img
        
        } else {        //no chached img?
            let ref = FIRStorage.storage().reference(forURL: postData.imageURL) //the url doesn't change but have to do it like this to do it and get photo
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
        
        //Want reference to the likes
        //userLikesRef = DataService.ds.REF_USER_CURRENT.child("likes")
        
        //single event observer("only when cell gets created check if we liked it before or not")
        userLikesRef.observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let _ = snapshot.value as? NSNull { //in fb Null is nil, if it doesn't exsist will return NSNull
                self.likeImg.image = UIImage(named: "empty-heart")
                
            } else {                               //is not nil
                self.likeImg.image = UIImage(named: "filled-heart")
                
            }
            
        })
    }
    
    func LikeTapped(sener: UITapGestureRecognizer){
        
        
        userLikesRef.observeSingleEvent(of: .value, with: { (snapshot) in //when tap it
            
            if let _ = snapshot.value as? NSNull {                        //if it was Null,nill, Not liked
                self.likeImg.image = UIImage(named: "filled-heart") //change it to liked
                self.post.addLike()
                
                //update our data in fb
                self.userLikesRef.child(self.post.postKey).setValue(true) //like it in fb
            } else {                                                      //wasn't nil, is liked
                self.likeImg.image = UIImage(named: "empty-heart") //change it to unliked
                self.post.removeLike()
                
                //update our data in fb
                self.userLikesRef.child(self.post.postKey).removeValue() //remove our like from fb
            }
        })
        
    }

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
