//
//  ViewController.swift
//  devlslopes-Social Media (Udemy)
//
//  Created by Mahmoud Hamad on 2/21/17.
//  Copyright © 2017 Mahmoud SMGL. All rights reserved.
// Was the ViewController

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase
import SwiftKeychainWrapper

import TwitterKit

class SignInVC: UIViewController {

    @IBOutlet weak var emailTxtField: FancyTextField!
    @IBOutlet weak var passTxtField: FancyTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let existed_uid = KeychainWrapper.standard.string(forKey: C.KEY_UID){
            print("SMGL: ID found in the keychain ")
            DataService.ds.createFirebaseDBUser(uid: existed_uid, userData: ["lastLogin": getDateAndTimeSMGL()])
            performSegue(withIdentifier: C.Segues.ToFeed.rawValue, sender: nil)
        }
    }

    
    @IBAction func twitterBtnPressed(_ sender: Any) {
        print("SMGL: twitterBtnPressed")

        Twitter.sharedInstance().logIn(withMethods: [.webBased], completion: { (session, error) in
        
            print("SMGL: logInCompletion")
            if let error = error {
                self.errorAlertSMGL(errorString: error.localizedDescription)
            }
            
            if session != nil { //success
                let authToken = session?.authToken
                let authTokenSecret = session?.authTokenSecret
                
                print("SMGL: UserName \(session?.userName)")

                let credential = FIRTwitterAuthProvider.credential(withToken: authToken!, secret: authTokenSecret!)
                
                let user = TWTRAPIClient.withCurrentUser()
                let request = user.urlRequest(withMethod: "GET",
                url: "https://api.twitter.com/1.1/account/verify_credentials.json",
                parameters: ["include_email": "true", "skip_status": "true"],
                error: nil)
                
                user.sendTwitterRequest(request, completion: { (response, data, error) in
                    
                    print("SMGL: Response :-[ \(response?.url) ]...SMGL: Data :-[ \(data) ]... SMGL: Error :-[ \(error) ]")

                    
                    if error != nil {
                        self.errorAlertSMGL(errorString: (error?.localizedDescription)!)
                    }
                    
                    
                    let json : Dictionary<String,Any>
                    
                    do{
                        json = try JSONSerialization.jsonObject(with: data!, options: []) as! Dictionary<String,Any>
                        
                        print("SMGL: Json response: ", json)
                        
                        let firstName = json["name"]
                        let lastName = json["screen_name"]
                        let email = json["email"]
                        

                        let userData = [
                            "lastLogin": "\(self.getDateAndTimeSMGL())",
                            "provider" : "\(credential.provider)",
                            "twitter_profileImage": "\(json["profile_image_url"]!)",
                            "twitter_name": "\(json["name"]!)",
                            "twitter_email" : "\(json["email"]!)",
                            "twitter_screen_name" : "\(json["screen_name"]!)",
                            "twitter_description" : "\(json["description"]!)",
                            "twitter_created_at" : "\(json["created_at"]!)",
                            "twitter_profile_banner_url" : "\(json["profile_banner_url"]!)",
                            "twitter_followers_count" : "\(json["followers_count"]!)",
                            "twitter_verified" : "\(json["verified"]!)",
                            "twitter_location" : "\(json["location"]!)"
                        ]
                    
                        
                        self.firebaseAuth(credential, userData: userData)
                        
                    } catch let error as NSError {
                        self.errorAlertSMGL(errorString: error.localizedDescription)
                    }
                })
            }
        })
    }

    @IBAction func facebookBtnPressed(_ sender: Any) {
        
        let facebookLogin = FBSDKLoginManager()
        
        facebookLogin.logIn(withReadPermissions: [ "email" ], from: self) { (result, error) in
            
            if error != nil {   //something gone wrong
                print("SMGL: Unable to authenticate with Facebook:- \(error?.localizedDescription) ")
            } else if result?.isCancelled == true {     //User canceled it
                print("SMGL: User canceled Facebook authentication ")
            } else {
                print("SMGL: Successfully authenticated with Facebook ")
                
                print("SMGL: result?.declinedPermissions: [\(result?.declinedPermissions as? String)]")

                
                let credentinal = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                //credentinal to access token based on facebook authentication
                //basicaly you get the credentinal, and credentinal is whats used to authenticate with firebase
                
                
                
                //get alot of userData
                //
                var fbRequest = FBSDKGraphRequest(graphPath:"me", parameters: nil)
                fbRequest?.start(completionHandler: { (connection, result, error) in
                    if error == nil {
                        print("User Info : \(result)")
                    } else {
                        print("Error Getting Info \(error)");
                    }
                })

                
                
                self.firebaseAuth(credentinal, userData: nil)
            }
        }
        //"email" requesting permision just for the email request
    }
    
    //this part of proccess is the same for twitter, facebook, google & github & contatins Firebase Part only
    //Sign in Firebase using facebook credentinal
    func firebaseAuth(_ credential: FIRAuthCredential, userData: Dictionary<String,String>?) {
        
        FIRAuth.auth()?.signIn(with: credential, completion: { (user, error) in
            
            if error != nil { //error
                
                print("SMGL: Unable to authenticate with Firebase:- \(error?.localizedDescription) ")
                self.errorAlertSMGL(errorString: (error?.localizedDescription)!)
                
            } else { //Success
                print("SMGL: Successfully authenticated with Firebase ") ; print("SMGl: credential:- \(credential) ")
                
                
                if let uid = user?.uid {
                    if userData == nil {
                        let userData2 = ["provider" : "\(credential.provider)",
                            "lastLogin": "\(self.getDateAndTimeSMGL())",
                            "createdFirebase": "\(self.getDateAndTimeSMGL())",
                            "facebook_Email": "\(user!.email!)",
                            "facebook_Name": "\(user!.displayName!)",
                            "facebook_PhotoURL": "\(user!.photoURL)!" ] as Dictionary<String,String>
                        self.completeSignIn(uid: uid, userData: userData2)
                    } else {
                        self.completeSignIn(uid: uid, userData: userData!)
                    }
                }
            }
        })
    }
    //2 steps to authenticate in, with the provider then with firebase
    //1 tell facebook i allow to give my info to this app,2 checking if everything is ok then go ahead
    
    
    @IBAction func signUpBtnPressed(_ sender: Any) {
        if let email = emailTxtField.text, let password = passTxtField.text { //they r not nil
            
            FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
                
                if error != nil {
                    print("SMGL: Something Went completley wrong with authenticating with Firebase using email :- \(error?.localizedDescription) ")
                    self.errorAlertSMGL(errorString: (error!.localizedDescription))
                    
                } else { //we where able to create the user
                    print("SMGL: Successfully authenticated with Firebase [created the account] ")
                    if let uid = user?.uid {
                        let userData = ["Provider": "\(user!.providerID)",
                            "lastLogin": self.getDateAndTimeSMGL(),
                            "Email": "\(user!.email!)",
                            "createdFirebase": "\(self.getDateAndTimeSMGL())",
                        ]
                        self.completeSignIn(uid: uid,userData: userData)
                    }
                }
            })
        } else {
            print("SMGL: either email or password are nil ")
            errorAlertSMGL(errorString: "SMGL: either email or password are nil ")
        }
    }

    @IBAction func signinBtnPressed(_ sender: Any) {
        if let email = emailTxtField.text, let password = passTxtField.text { //they r not nil
            
            FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
                
                if error == nil { //No errors Proceed, user existed & signed in
                    print("SMGL: Email User authenticated with Firebase [Signed In] ")
                    
                    if let uid = user?.uid { //leave last login
                        
                        let userData = ["lastLogin": self.getDateAndTimeSMGL()]
                        self.completeSignIn(uid: uid, userData: userData)
                    }
                    
                } else { //there is error //check firebase docmentation //user doesn't exist
                    print("SMGL: There is error with signing in:- \(error?.localizedDescription) ")
                    
                    self.errorAlertSMGL(errorString: (error!.localizedDescription))
                }
            })
        } else {
            print("SMGL: either email or password are nil ")
            errorAlertSMGL(errorString: "SMGL: either email or password are nil ")
        }
    }

    
    //save uid & perform segue
    func completeSignIn(uid: String, userData: Dictionary<String, String>){
        DataService.ds.createFirebaseDBUser(uid: uid, userData: userData) //our ds class
        KeychainWrapper.standard.set(uid, forKey: C.KEY_UID) //pod
        print("SMGL: data saved to keychain")
        
        performSegue(withIdentifier: C.Segues.ToFeed.rawValue, sender: nil)
    }
}

let error1 = "The password must be 6 characters long or more."
let error2 = "The password is invalid or the user does not have a password."
let error3 = "The email address is already in use by another account."
let error4 = "There is no user record corresponding to this identifier. The user may have been deleted."
//two scenarios:
//new user make him an account and sign in him (2 parts)
//already a user sign in him (1 part) check pwd, and details
