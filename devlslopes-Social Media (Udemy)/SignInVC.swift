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
        
        if let _ = KeychainWrapper.standard.string(forKey: C.KEY_UID){
            print("SMGL: ID found in the keychain ")
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
            
            if session != nil {
                let authToken = session?.authToken
                let authTokenSecret = session?.authTokenSecret
                
                print("SMGL: UserName \(session?.userName)")

            
                let credential = FIRTwitterAuthProvider.credential(withToken: authToken!, secret: authTokenSecret!)
                
                self.firebaseAuth(credential)
                
                let user = TWTRAPIClient.withCurrentUser()
                let request = user.urlRequest(withMethod: "GET",
                url: "https://api.twitter.com/1.1/account/verify_credentials.json",
                parameters: ["include_email": "true", "skip_status": "true"],
                error: nil)
                
                user.sendTwitterRequest(request, completion: { (response, data, error) in
                    
                    print("SMGL: Response :- \(response?.url)")
                    print("SMGL: Data :- \(data)")
                    print("SMGL: Error :- \(error)")
                    
                    let json : Dictionary<String,Any>
                    
                    do{
                        json = try JSONSerialization.jsonObject(with: data!, options: []) as! Dictionary<String,Any>
                        
                        print("SMGL: Json response: ", json)
                        
                        let firstName = json["name"]
                        let lastName = json["screen_name"]
                        let email = json["email"]
                        
                        print("SMGL: First name: ",firstName)
                        print("SMGL: Last name: ",lastName)
                        print("SMGL: Email: ",email)
                        
                        
                    } catch {
                        
                    }
                })
            }
        })
    }

    @IBAction func facebookBtnPressed(_ sender: Any) {
        
        let facebookLogin = FBSDKLoginManager()
        
        facebookLogin.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            
            if error != nil {   //something gone wrong
                print("SMGL: Unable to authenticate with Facebook:- \(error?.localizedDescription) ")
            } else if result?.isCancelled == true {     //User canceled it
                print("SMGL: User canceled Facebook authentication ")
            } else {
                print("SMGL: Successfully authenticated with Facebook ")
                
                let credentinal = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                //credentinal to access token based on facebook authentication
                //basicaly you get the credentinal, and credentinal is whats used to authenticate with firebase
                
                self.firebaseAuth(credentinal)
            }
        }
        //"email" requesting permision just for the email request
    }
    
    //this part of proccess is the same for twitter, facebook, google & github & contatins Firebase Part only
    //Sign in Firebase using facebook credentinal
    func firebaseAuth(_ credential: FIRAuthCredential) {
        
        FIRAuth.auth()?.signIn(with: credential, completion: { (user, error) in
            
            if error != nil { //there is error
                
                print("SMGL: Unable to authenticate with Firebase:- \(error?.localizedDescription) ")
                self.errorAlertSMGL(errorString: (error?.localizedDescription)!)
                
            } else {
                print("SMGL: Successfully authenticated with Firebase ") ; print("SMGl: credential:- \(credential) ")
                
                if let uid = user?.uid {
                    self.completeSignIn(uid: uid)
                }
            }
        })
    }
    //two steps to authenticate in, with the provider then with firebase
    //1 tell facebook i allow to give my info to this app,2 checking if everything is ok then go ahead
    
    
    
    @IBAction func signinBtnPressed(_ sender: Any) {
        if let email = emailTxtField.text, let password = passTxtField.text { //they r not nil
            
            FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
                
                if error == nil { //No errors Proceed, user existed & signed in
                    print("SMGL: Email User authenticated with Firebase [Signed In] ")
                
                    if let uid = user?.uid {
                        self.completeSignIn(uid: uid)
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
    
    @IBAction func signUpBtnPressed(_ sender: Any) {
        if let email = emailTxtField.text, let password = passTxtField.text { //they r not nil
            
            FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
                
                if error != nil {
                    print("SMGL: Unable to authenticate with Firebase using email ")
                    print("SMGL: Something Went completley wrong:- \(error?.localizedDescription) ")
                    
                    self.errorAlertSMGL(errorString: (error!.localizedDescription))
                    
                } else { //we where able to create the user
                    print("SMGL: Successfully authenticated with Firebase [created the account] ")
                    if let uid = user?.uid {
                        self.completeSignIn(uid: uid)
                    }
                }
            })
        } else {
            print("SMGL: either email or password are nil ")
            errorAlertSMGL(errorString: "SMGL: either email or password are nil ")
        }
    }


    //save uid & perform segue
    func completeSignIn(uid: String){
        KeychainWrapper.standard.set(uid, forKey: C.KEY_UID)
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
