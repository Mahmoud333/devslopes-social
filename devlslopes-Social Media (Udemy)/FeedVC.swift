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
    
    
    
    @IBOutlet weak var writeView: UIView!
    var writeScreenVisible = false
    
    var postss = [Post]()
    var imagePicker : UIImagePickerController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        writeView.frame = CGRect(x: 0, y: -200, width: UIScreen.main.bounds.width - 10, height: 180)
        writeView.center.x = self.view.center.x
        self.view.addSubview(writeView)
        
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true //mke it can crop it
        imagePicker.delegate = self
        
        
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
           UIView.animate(withDuration: 0.5) {
                self.writeView.transform = CGAffineTransform(translationX: 0, y: 270)
                self.writeScreenVisible = true
            }
            
        } else {
            UIView.animate(withDuration: 0.5) {
                self.writeView.transform = CGAffineTransform(translationX: 0, y: -200)
                self.writeScreenVisible = false
            }
        }
    }

}

extension FeedVC {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) { //can be video or image
        
        if let choosenImage = info[UIImagePickerControllerEditedImage] as? UIImage { //array have original, edited & other info
            
            addImage.image = choosenImage
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
            cell.configuerCell(postData: postData )
            
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
