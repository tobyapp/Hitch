//
//  FacebookLoginViewController.swift
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
import SWRevealViewController
import MK

class FacebookLoginViewController: UIViewController, FBSDKLoginButtonDelegate {

    @IBAction func signInButton(sender: AnyObject) {
        let permissions = ["public_profile", "email", "user_about_me", "user_birthday", "user_education_history", "user_location", "user_work_history"]
        //let permissions = ["email"]
        PFFacebookUtils.logInInBackgroundWithReadPermissions(permissions) {
            (user: PFUser?, error: NSError?) -> Void in
            
            if ((error) != nil) {
                print("Error : \(error)")
                self.showAlertController("\(error)")
                return
            }
                
            else {
            if let user = user {
                if user.isNew {
                    print("User signed up and logged in through Facebook!")
                } else {
                    print("User logged in through Facebook!")
                }
            } else {
                print("Uh oh. The user cancelled the Facebook login.")
            }
        }
            let viewController = self.storyboard!.instantiateViewControllerWithIdentifier("homePage") as UIViewController
            self.presentViewController(viewController, animated: true, completion: nil)
            
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Function to load the Facebook login/logout button
        func displayFBButton() {
            let loginView : FBSDKLoginButton = FBSDKLoginButton()
            self.view.addSubview(loginView)
            loginView.center = self.view.center
            loginView.readPermissions = ["public_profile", "email", "user_about_me", "user_birthday", "user_education_history", "user_location", "user_work_history"]

            loginView.delegate = self
            print("accessed displayFBButton()")
        }
        
        if (FBSDKAccessToken.currentAccessToken() != nil)
        {
            // User is already logged in, display logout button
            displayFBButton()
            let viewController = self.storyboard!.instantiateViewControllerWithIdentifier("homePage") as UIViewController
            self.presentViewController(viewController, animated: true, completion: nil)
        }
        else
        {
            // User isn't logged in, sdisplay login button
            displayFBButton()
        }

        let cardView: CardView = CardView()
        cardView.dividerInset.left = 100
        cardView.titleLabelInset.left = 100
        cardView.detailLabelInset.left = 100
        cardView.backgroundColor  = MaterialColor.deepPurple.base
        cardView.pulseColor = nil
        cardView.pulseFill = false
        cardView.pulseScale = false
        
        // Image.
        cardView.image = UIImage(named: "facebook-purple")
        cardView.contentsGravity = .TopLeft
        
        // Title label.
        let titleLabel: UILabel = UILabel()
        titleLabel.text = "Facebook Log In"
        titleLabel.font = RobotoFont.mediumWithSize(24)
        titleLabel.textColor = MaterialColor.white
        cardView.titleLabel = titleLabel
        
        // Detail label.
        let detailLabel: UILabel = UILabel()
        detailLabel.text = "Click to login to into Hitch!"
        detailLabel.font = RobotoFont.mediumWithSize(20)
        detailLabel.textColor = MaterialColor.white
        detailLabel.numberOfLines = 0
        cardView.detailLabel = detailLabel
        
        // LEARN MORE button.
        let loginButton: RaisedButton = RaisedButton()
        loginButton.pulseColor = MaterialColor.deepPurple.base
        loginButton.pulseFill = true
        loginButton.pulseScale = true
        loginButton.setTitle("Log In", forState: .Normal)
        loginButton.backgroundColor = MaterialColor.white
        loginButton.setTitleColor(MaterialColor.deepPurple.base, forState: .Normal)
        
        // Add buttons to right side.
        cardView.rightButtons = [loginButton]

        loginButton.addTarget(self, action: "loginToFb:", forControlEvents: UIControlEvents.TouchUpInside)

        // To support orientation changes, use MaterialLayout.
        view.addSubview(cardView)
        cardView.translatesAutoresizingMaskIntoConstraints = false
        MaterialLayout.alignFromTop(view, child: cardView, top: 100)
        MaterialLayout.alignToParentHorizontally(view, child: cardView, left: 20, right: 20)
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // Facebook delegate method, check if user logged in successfully
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        
        if ((error) != nil)
        {
            print("Error : \(error)")
            showAlertController("\(error)")
            return
        }
            
        else if result.isCancelled {
            // User cancelled to log in, stay at same page
            print("cancelled")
        }
        else {
            print("logged in")
            //self.performSegueWithIdentifier("loggedInSegue2", sender: nil) //was used to perform segue, keeping it for refference

            let viewController = self.storyboard!.instantiateViewControllerWithIdentifier("homePage") as UIViewController
            self.presentViewController(viewController, animated: true, completion: nil)
        }
    }
    
    // Function to handle what happens when a user logs out
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print("User Logged Out")
    }
    
    // Function to display an Alert Controller (for test purposes)
    func showAlertController(errorMessage: String) {
        let alertController = UIAlertController(
            title: "Error in loggining in",
            message: errorMessage,
            preferredStyle: .Alert)
        let cancelAction = UIAlertAction(
            title: "ok",
            style: UIAlertActionStyle.Destructive,
            handler: nil)
        alertController.addAction(cancelAction)
        
        // Opens the phones settings application
        let openAction = UIAlertAction(
            title: "Open Settings",
            style: .Default)
            { (action) in
                if let url = NSURL(string:UIApplicationOpenSettingsURLString) {
                    UIApplication.sharedApplication().openURL(url)
                }
        }
        alertController.addAction(openAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func loginToFb(sender: UIButton) {
        let permissions = ["public_profile", "email", "user_about_me", "user_birthday", "user_education_history", "user_location", "user_work_history"]
        //let permissions = ["email"]
        PFFacebookUtils.logInInBackgroundWithReadPermissions(permissions) {
            (user: PFUser?, error: NSError?) -> Void in
            
            if ((error) != nil) {
                print("Error : \(error)")
                self.showAlertController("\(error)")
                return
            }
                
            else {
                if let user = user {
                    if user.isNew {
                        print("User signed up and logged in through Facebook!")
                        //initalises UserAccount class whihc grabs all the facebook data ready for the app
                        let user = UserAccount()
                        //uncomment when want to add data to Parse
                        dispatch_async(dispatch_get_main_queue(), { //puts data upload on another thread
                            user.upLoadData()
                        })
                        let viewController = self.storyboard!.instantiateViewControllerWithIdentifier("homePage") as UIViewController
                        self.presentViewController(viewController, animated: true, completion: nil)
                        
                    } else {
                        print("User logged in through Facebook!")
                        //initalises UserAccount class whihc grabs all the facebook data ready for the app
                        let user = UserAccount()
                        //uncomment when want to add data to Parse
                        dispatch_async(dispatch_get_main_queue(), { //puts data upload on another thread
                            user.upLoadData()
                        })
                        let viewController = self.storyboard!.instantiateViewControllerWithIdentifier("homePage") as UIViewController
                        self.presentViewController(viewController, animated: true, completion: nil)
                    }
                } else {
                    print("Uh oh. The user cancelled the Facebook login.")
                }
            }
        }
    }
}