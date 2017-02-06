//
//  FacebookLoginViewController.swift
//  hitch
//
//  Created by Toby Applegate on 21/12/2015.
//  Copyright © 2015 Toby Applegate. All rights reserved.
//

import UIKit
import Whisper
import Parse
import ParseFacebookUtilsV4
import Material

class FacebookLoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
         // Adds image to background

        let width = UIScreen.main.bounds.size.width
        let height = UIScreen.main.bounds.size.height
        let imageViewBackground = UIImageView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        
        imageViewBackground.image = UIImage(named: "Backpacker")
        imageViewBackground.contentMode = UIViewContentMode.scaleToFill
        
        self.view.addSubview(imageViewBackground)
        self.view.sendSubview(toBack: imageViewBackground)
        
        // Adds motion functionality to background image
        
        let horizontalMotionEffect = UIInterpolatingMotionEffect(keyPath: "center.x", type: .tiltAlongHorizontalAxis)
        horizontalMotionEffect.minimumRelativeValue = -25
        horizontalMotionEffect.maximumRelativeValue = 25
        
        let verticalMotionEffect = UIInterpolatingMotionEffect(keyPath: "center.y", type: .tiltAlongVerticalAxis)
        verticalMotionEffect.minimumRelativeValue = -25
        verticalMotionEffect.maximumRelativeValue = 25
        
        let motionEffectGroup = UIMotionEffectGroup()
        motionEffectGroup.motionEffects = [horizontalMotionEffect, verticalMotionEffect]
        
        imageViewBackground.addMotionEffect(motionEffectGroup)

        let cardView = Card() //CardView = CardView()
//        cardView.divider.alignment//dividerInset.left = 0 // White line seperating loging button with text
//        cardView.titleLabelInset.left = 150 // Top line of text
//        cardView.detailLabelInset.left = 150 // Bottom line of text
        cardView.backgroundColor  = Color.deepPurple.base
//        cardView.pulseColor = nil
//        cardView.pulse() //= false
        //cardView.pulseScale = false
        
        // Image.
        cardView.image = UIImage(named: "facebook-purple")
        //cardView.contentsGravity = .TopLeft
        
        // Title label.
        let titleLabel: UILabel = UILabel()
        titleLabel.text = "Facebook Log In"
        titleLabel.font = RobotoFont.medium(with: 24)//mediumWithSize(24)
        titleLabel.textColor = Color.white
//        cardView.titleLabel = titleLabel
        
        // Detail label.
        let detailLabel: UILabel = UILabel()
        detailLabel.text = "Click the button to login into Hitch!"
        detailLabel.font = RobotoFont.medium(with: 20)//medium(with: 20)//mediumWithSize(20)
        detailLabel.textColor = Color.white
        detailLabel.numberOfLines = 0
//        cardView.detailLabel = detailLabel
        
        // LEARN MORE button.
        let loginButton: RaisedButton = RaisedButton()
        loginButton.pulseColor = Color.deepPurple.base
        //loginButton.pulseFill = true
//        loginButton.pulseScale = true
        loginButton.setTitle("Log In", for: .normal)
        loginButton.backgroundColor = Color.white
        loginButton.setTitleColor(Color.deepPurple.base, for: .normal)
        
        // Add buttons to right side.
//        cardView.rightButtons = [loginButton]

        loginButton.addTarget(self, action: #selector(FacebookLoginViewController.loginToFb(_:)), for: UIControlEvents.touchUpInside)

        // To support orientation changes, use MaterialLayout.
        view.addSubview(cardView)
        cardView.translatesAutoresizingMaskIntoConstraints = false
//        MaterialLayout.alignFromTop(view, child: cardView, top: 100)
//        MaterialLayout.alignToParentHorizontally(view, child: cardView, left: 20, right: 20)
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // Function to display an Alert Controller
    func showAlertController(_ errorMessage: String) {
        let alertController = UIAlertController(
            title: "Error in loggining in",
            message: errorMessage,
            preferredStyle: .alert)
        let cancelAction = UIAlertAction(
            title: "ok",
            style: UIAlertActionStyle.destructive,
            handler: nil)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func loginToFb(_ sender: UIButton) {
        let permissions = ["public_profile", "email", "user_about_me", "user_birthday", "user_education_history", "user_location", "user_work_history"]
        //let permissions = ["email"]
//        PFFacebookUtils.logInInBackground(withReadPermissions: permissions) {
//            (user: PFUser?, error: NSError?) -> Void in
//            
//            if ((error) != nil) {
//                print("Error : \(error)")
//                self.showAlertController("\(error)")
//                return
//            }
//                
//            else {
//                if let user = user {
//                    if user.isNew {
//                        print("User signed up and logged in through Facebook!")
//                        //initalises UserAccount class whihc grabs all the facebook data ready for the app
//                        let user = UploadDataToBackEnd()
//                        //uncomment when want to add data to Parse
//                        DispatchQueue.main.async(execute: { //puts data upload on another thread
//                            user.upLoadData()
//                        })
//                        let viewController = self.storyboard!.instantiateViewController(withIdentifier: "homePage") as UIViewController
//                        self.present(viewController, animated: true, completion: nil)
//                        
//                    } else {
//                        print("User logged in through Facebook!")
//                        //initalises UserAccount class whihc grabs all the facebook data ready for the app
//                        let user = UploadDataToBackEnd()
//                        //uncomment when want to add data to Parse
//                        DispatchQueue.main.async(execute: { //puts data upload on another thread
//                            user.upLoadData()
//                        })
//                        let viewController = self.storyboard!.instantiateViewController(withIdentifier: "homePage") as UIViewController
//                        self.present(viewController, animated: true, completion: nil)
//                    }
//                } else {
//                    print("Uh oh. The user cancelled the Facebook login.")
//                }
//            }
//        }
 
    
    } // dont comment out
    
    
    
}
