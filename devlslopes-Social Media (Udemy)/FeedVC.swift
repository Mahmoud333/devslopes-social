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

class FeedVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var postss = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
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

    @IBAction func signOutPressed(_ sender: Any) {
        do {
            KeychainWrapper.standard.removeObject(forKey: C.KEY_UID)
            try FIRAuth.auth()?.signOut()
            dismiss(animated: true, completion: nil)
        }catch let error as NSError {
            errorAlertSMGL(errorString: error.localizedDescription)
        }
    }
}

//TableView
extension FeedVC {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: C.Cell_Ident, for: indexPath) as? PostCell {
            
            cell.likesLbl.text = "\(postss[indexPath.row].likes)"
            cell.caption.text = postss[indexPath.row].caption
            
            do {
                let url: URL = URL(string: self.postss[indexPath.row].imageURL)!
                    print("SMGL \(url)")
                let imageData: Data = try Data(contentsOf: url)
                    print("SMGL \(imageData)")
                    
                    cell.postImage.image = UIImage(data: imageData)
                

            } catch let error as NSError {
               print("SMGL: \(error.localizedDescription)")
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
