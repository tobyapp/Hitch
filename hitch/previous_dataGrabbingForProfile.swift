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


class ProfileViewController2: UIViewController, FBSDKLoginButtonDelegate {
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var displayPictureView: UIImageView!
    
    var facebookProfileData = ObtainFBData()
    
    var userName: String?
    var userGender: String?
    var userDOB: String?
    var userEducation: String?
    var userEmail: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Used to display side menu (using SWRevealViewController)
        self.addSideMenu(menuButton)
        
        if (FBSDKAccessToken.current() != nil)
        {
            displayFBButton()
        }

         // Obtain users Facebook profile picture and set to UIImageView
                facebookProfileData.getProfilePicture {(pictureData, error) -> Void in
                    if error != nil {
                        print("login error: \(error!.localizedDescription)")
                    }
                    self.displayPictureView
                        .image = UIImage(data: pictureData! as Data)
                }

                facebookProfileData.getUserDetails { (nameData, genderData, dobData, educationData, emailData, error) -> Void in
                    if error != nil {
                        print("login error: \(error!.localizedDescription)")
                    }
                    self.userName =  nameData
                    self.userGender = genderData
                    self.userDOB = dobData
                    self.userEducation = educationData
                    self.userEmail = emailData
        
                    let object = PFObject(className: "UserData")
                    object.setObject(self.userName!, forKey: "userName")
                    object.setObject(Int(self.userDOB!)!, forKey: "userAge")
                    object.setObject(self.userGender!, forKey: "userGender")
                    object.setObject(self.userEmail!, forKey: "userEmailAddress")
                    object.setObject(self.userEducation!, forKey: "userEducation")
                    object.saveInBackground()
                }
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
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!){
        //method only here to satisfy Facebook delegate method, when users at this view they must have already logged in so dont care about login button
    }
    
    // Function to handle what happens when a user logs out
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("User Logged Out")
        
        //segue to loging screen
        let viewController = self.storyboard!.instantiateViewController(withIdentifier: "loginView") as UIViewController
        self.present(viewController, animated: true, completion: nil)
        
        //display logout message
       // let murmur = Murmur(title: "\(userName!) logged out")
        //show(murmur, sender: .Show(0.5))
        //Whistle(murmur)
    }
}
