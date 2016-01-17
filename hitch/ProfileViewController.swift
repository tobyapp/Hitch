//
//  ProfileViewController.swift
//  hitch
//
//  Created by Toby Applegate on 21/12/2015.
//  Copyright © 2015 Toby Applegate. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import Whisper
import Parse
import ParseFacebookUtilsV4


class ProfileViewController: UIViewController, FBSDKLoginButtonDelegate {

    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var displayPictureView: UIImageView!
    
    var facebookProfileData = ParseFBData()
    var account = UserAccount()
    
    var userName: String?
    var userGender: String?
    var userDOB: String?
    var userEducation: String?
    var userEmail: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Used to display side menu (using SWRevealViewController)
        self.addSideMenu(menuButton)

        if (FBSDKAccessToken.currentAccessToken() != nil)
        {
            displayFBButton()
        }
        
        //display profile pciture from 
        if let dp = account.displayPicture {
            self.displayPictureView.image = UIImage(data: dp)
        }
        
        self.userName = account.userName
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    func displayFBButton() {
        let loginView : FBSDKLoginButton = FBSDKLoginButton()
        self.view.addSubview(loginView)
        loginView.center = self.view.center
        loginView.readPermissions = ["public_profile", "email", "age_range", "bio", "birthday", "education", "gender"]
        loginView.delegate = self
        print("accessed displayFBButton()")
    }

    // Facebook delegate method, check if user logged in successfully
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        //method only here to satisfy Facebook delegate method, when users at this view they must have already logged in so dont care about login button
    }
    
    // Function to handle what happens when a user logs out
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print("User Logged Out")
        
        //segue to loging screen
        let viewController = self.storyboard!.instantiateViewControllerWithIdentifier("loginView") as UIViewController
        self.presentViewController(viewController, animated: true, completion: nil)
        
        //display logout message
        let murmur = Murmur(title: "\(userName!) logged out")
        Whistle(murmur)
    }
}
