//
//  SettingsViewController.swift
//  hitch
//
//  Created by Toby Applegate on 30/12/2015.
//  Copyright © 2015 Toby Applegate. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import Whisper
import Parse
import ParseFacebookUtilsV4
import MK
import CoreData


class SettingsViewController: UIViewController, FBSDKLoginButtonDelegate {

    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    // managedObjectContext - Managed object to work with objects (Facebook data) in CoreData
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    var userName: String?
    var profileData = [UserProfileData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        self.addSideMenu(menuButton)
        
        fetchProfileData()
        
        if (FBSDKAccessToken.currentAccessToken() != nil)
        {
            displayFBButton()
        }

        // Do any additional setup after loading the view.
    }
    
    func fetchProfileData() {
        let fetchRequest = NSFetchRequest(entityName: "UserProfileData")
        do {
            profileData = try (managedObjectContext.executeFetchRequest(fetchRequest) as? [UserProfileData])!
            let userData = profileData[0]
            self.userName = userData.userName!
        }
            
        catch let error as NSError {
            print("Fetch failed: \(error.localizedDescription)")
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
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        //method only here to satisfy Facebook delegate method, when users at this vie wthey must have already logged in so dont care about login button
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
