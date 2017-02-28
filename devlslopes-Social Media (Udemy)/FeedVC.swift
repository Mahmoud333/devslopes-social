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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
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
            
            return cell
        }
        
        return UITableViewCell()
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
}
