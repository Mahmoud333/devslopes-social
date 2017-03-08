//
//  Post.swift
//  devlslopes-Social Media (Udemy)
//
//  Created by Mahmoud Hamad on 3/5/17.
//  Copyright © 2017 Mahmoud SMGL. All rights reserved.
//

import Foundation


class Post {
    
    private var _caption: String!
    private var _imageURL: String!
    private var _likes: Int!
    private var _postKey: String! //post id
    
    private var _createdIn: String!
    
    init(caption: String,imageURL: String,likes: Int, createdIn: String){
        self._caption = caption
        self._imageURL = imageURL
        self._likes = likes
        self._createdIn = createdIn
    }
    
    init(postKey: String, postData: Dictionary<String, Any>) {
        //this is what we gonna use to convert the data we get from firebase into something we can use
        self._postKey = postKey
        
        //postData could contain anything so we have to prepare for that
        if let caption = postData["caption"] as? String{
            self._caption = caption
        }
        
        if let imageURL = postData["imageURL"] as? String {
            self._imageURL = imageURL
        }
        
        if let likes = postData["numberOfLikes"] as? Int {
            self._likes = likes
        }
        
        if let createdIn = postData["createdIn"] as? String {
            self._createdIn = createdIn
        }
    }
    
    var caption: String {
        if _caption == nil { return "" }
        return _caption
    }
    
    var imageURL: String {
        if _imageURL == nil {
           return "gs://devslopes-social-media.appspot.com/post-pics/a103eb2dc0ebe70231161f9cb71d308b.png"
        }
        return _imageURL
    }
    
    var likes: Int {
        if _likes == nil { return 0 }
        return _likes
    }
    
    var postKey: String {
        if _postKey == nil { return "" }
        return _postKey
    }
    
    var createdIn: String {
        if _createdIn == nil { return "" }
        return _createdIn
    }

}
