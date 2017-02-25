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

class SignInVC: UIViewController {

    @IBOutlet weak var emailTxtField: FancyTextField!
    @IBOutlet weak var passTxtField: FancyTextField!
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


    @IBAction func facebookBtnPressed(_ sender: Any) {
        
        let facebookLogin = FBSDKLoginManager()
        
        facebookLogin.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            
            if error != nil {   //something gone wrong
                print("SMGL: Unable to authenticate with Facebook:- \(error?.localizedDescription)")
            } else if result?.isCancelled == true {     //User canceled it
                print("SMGL: User canceled Facebook authentication")
            } else {
                print("SMGL: Successfully authenticated with Facebook")
                
                let credentinal = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                //credentinal to access token based on facebook authentication
                //basicaly you get the credentinal, and credentinal is whats used to authenticate with firebase
                
                self.firebaseAuth(credentinal)
            }
        }
        //"email" requesting permision just for the email request
    }
    
    //this part of proccess is the same for twitter, facebook, google & github & contatins Firebase Part
    //Sign in Firebase using facebook credentinal
    func firebaseAuth(_ credential: FIRAuthCredential) {
        
        FIRAuth.auth()?.signIn(with: credential, completion: { (user, error) in
            
            if error != nil {
                print("SMGL: Unable to authenticate with Firebase:- \(error?.localizedDescription)")
            } else {
                print("SMGL: Successfully authenticated with Firebase")
                print("SMGl: credential:- \(credential)")
            }
        })
    }
    //two steps to authenticate in, with the provider then with firebase
    //1 tell facebook i allow to give my info to this app,2 checking if everything is ok then go ahead
    
    
    
    @IBAction func signinBtnPressed(_ sender: Any) {
        if let email = emailTxtField.text, let password = passTxtField.text { //they r not nil
            
            FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
                
                if error == nil { //No errors Proceed, user existed & signed in
                    print("SMGL: Email User authenticated with Firebase [Signed In]")
                
                } else { //check firebase docmentation
                    print("SMGL: There is error with signing in:- \(error?.localizedDescription)")
                    
                    //user doesn't exist
                    FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
                        
                        if error != nil {
                            print("SMGL: Unable to authenticate with Firebase using email")
                            print("SMGL: Something Went completley wrong:- \(error?.localizedDescription)")
                        
                        } else { //we where able to create the user
                            print("SMGL: Successfully authenticated with Firebase [created the account]")
                        }
                    })
                }
                
            })
            
        } else { print("SMGL: either email or password are nil") }
        
    }
    //two scenarios:
    //new user make him an account and sign in him (2 parts)
    //already a user sign in him (1 part) check pwd, and details

}

let error1 = "The password must be 6 characters long or more."
let error2 = "The password is invalid or the user does not have a password."
let error3 = "The email address is already in use by another account."
