//
//  FeedVC.swift
//  devlslopes-Social Media (Udemy)
//
//  Created by Mahmoud Hamad on 2/26/17.
//  Copyright © 2017 Mahmoud SMGL. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper

class FeedVC: UIViewController, UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    //UINavigationControllerDelegate uses it to display imagepicker and dismiss it as well
    

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addImage: CircleImageView!
    @IBOutlet weak var captionTextField: FancyTextField!
    
    @IBOutlet weak var writeView: UIView!
    var writeScreenVisible = false
    static var imageCache: NSCache<NSString, UIImage> = NSCache()//static bec. we gonna use it in multiple location Dict String key get image value
    
    var postss = [Post]()
    var imagePicker : UIImagePickerController!
    
    var selectedImage = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        writeView.frame = CGRect(x: 0, y: -130, width: UIScreen.main.bounds.width - 10, height: 170)
        writeView.center.x = self.view.center.x
        self.view.addSubview(writeView)
        
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true //mke it can crop it
        imagePicker.delegate = self
        
        print("SMGL: DB \(DB_BASE)")
        print("SMGL: Storage \(STORAGE_BASE)")
        
        //observe our posts by url of our posts database
        
        DataService.ds.REF_POSTS.observe(.value, with: { (snapshot) in
            print("SMGL: \(snapshot.value)")
            self.postss.removeAll()
            if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] { //snapshot is many
                //array of all of our posts
                for snap in snapshot {
                    print("SMGL: SnapKey: \(snap.key)")
                    print("SMGL: Snap: \(snap.value)")
                    if let postDict = snap.value as? Dictionary<String, Any> {
                        let snapKey = snap.key //170301-SMGL123-04-11-40
                        let post = Post(postKey: snapKey, postData: postDict)
                        self.postss.append(post)
                    }
                }
                self.tableView.reloadData()
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    
    @IBAction func addImageTapped(_ sender: Any) {
        present(imagePicker, animated: true, completion: nil)
    }
    @IBAction func postTapped(_ sender: Any) {
        
        guard let caption = captionTextField.text, caption != "" else {
            print("SMGL: caption is empty write something") //maybe highlight the view make popup
            return //or break
        }
        
        guard let img = addImage.image, selectedImage == true else {
            print("SMGL: An image must be selected")
            return
        }
        
        //convert to data JPEG and compress it
        if let imgData = UIImageJPEGRepresentation(img, 0.2) { //1.0 best quality, 0.2 still look good
            
            //create random string for image name
            let imgUid = NSUUID().uuidString
            
            //to tell firebase storage its jpeg we passing in, FB can infer what it is but sometimes he get it wrong
            let metadata = FIRStorageMetadata()
            metadata.contentType = "image/jpeg"
            
            //upload it
            DataService.ds.REF_POST_IMAGES.child(imgUid).put(imgData, metadata: metadata) { (metadata, error) in
                
                if error != nil {
                    
                    print("SMGL: something wrong with uploading the image to firebase storage")
                    self.errorAlertSMGL(errorString: "something wrong with uploading the image to firebase storage")
                
                } else {
                    
                    print("SMGL: Successfully uploaded image to Firebase storage")
                    self.errorAlertSMGL(errorString: "Successfully Uploaded Image")
                    
                    let downloadURL = metadata?.downloadURL()?.absoluteString //get 100% good String for the url we can download it from
                    print("SMGL: absoluteString URL \(downloadURL)")
                    
                    if let url = downloadURL {
                        self.postToFirebase(imgUrl: url)
                    }
                    /* Real Me
                    let postData: Dictionary<String, String> = ["caption": caption,
                                                                "imageURL": downloadURL!,
                                                                "createdIn": self.getDateAndTimeSMGL(),
                                                                "numberOfLikes": "0"
                    ]
                    DataService.ds.createAPost(uid: imgUid, postData: postData)
                    */
                }
            }
        }
        /*
        let imageData: Data = UIImageJPEGRepresentation(addImage.image!, 0)!
        let postData = ["caption": "\(captionTextField.text)",
                        "imageData": String(describing: imageData),
                        "createdIn": getDateAndTimeSMGL(),
                        "numberOfLikes": "0"
                            ] as? Dictionary<String, String>
        DataService.ds.createAPost(uid: "123456789", postData: postData!)
 */
    }
    
    func postToFirebase(imgUrl: String){
        let postData: Dictionary<String, Any> = ["caption": captionTextField.text!,
                                                    "imageURL": imgUrl,
                                                    "createdIn": self.getDateAndTimeSMGL(),
                                                    "numberOfLikes": 1
        ]
        
        //childByAutoId() firebase create id for post on fly (random)
        let firebasePost = DataService.ds.REF_POSTS.childByAutoId()
        firebasePost.setValue(postData) //is other way of "updateChildValues" it removes anything with same id then put ours
        
        captionTextField.text = ""
        selectedImage = false
        addImage.image = UIImage(named: "add-image")
        tableView.reloadData()
        
    }
    
    @IBAction func signOutPressed(_ sender: Any) {
        do {
            KeychainWrapper.standard.removeObject(forKey: C.KEY_UID)
            try FIRAuth.auth()?.signOut()
            dismiss(animated: true, completion: nil)
        }catch let error as NSError {
            errorAlertSMGL(errorString: error.localizedDescription)
        }
    }

    @IBAction func writePressed(_ sender: Any) {
        if writeScreenVisible == false {
            writeView.isHidden = false
           UIView.animate(withDuration: 0.5) {
                self.writeView.transform = CGAffineTransform(translationX: 0, y: 200)
                self.writeScreenVisible = true
            }
        } else {
            UIView.animate(withDuration: 0.5, animations: {
                self.writeView.transform = CGAffineTransform(translationX: 0, y: -130)
                self.writeScreenVisible = false
            }, completion: { (Bool) in
                 self.writeView.isHidden = true
            })
        }
    }

}

extension FeedVC {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) { //can be video or image
        
        if let choosenImage = info[UIImagePickerControllerEditedImage] as? UIImage { //array have original, edited & other info
            
            addImage.image = choosenImage
            selectedImage = true
        } else {
            print("SMGL: a valid image wasn't selected INFO:- \(info)") ; errorAlertSMGL(errorString: "a valid image wasn't selected")
        }
        imagePicker.dismiss(animated: true, completion: nil)
    } //when we select the image dismiss the image picker
}

//TableView
extension FeedVC {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: C.Cell_Ident, for: indexPath) as? PostCell {
            let postData = postss[indexPath.row]
            
            let imgUrl = postData.imageURL
                
            if let img = FeedVC.imageCache.object(forKey: imgUrl as NSString) { //found it
                
                cell.configuerCell(postData: postData, img: img)
                
            } else {                                                            //didnt found, download it
                
                cell.configuerCell(postData: postData, img: nil)
            }
            
            return cell
        }
        return UITableViewCell()
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postss.count
    }
}
