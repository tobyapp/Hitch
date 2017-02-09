//
//  FacebookLoginViewController.swift
//  hitch
//
//  Created by Toby Applegate on 21/12/2015.
//  Copyright © 2015 Toby Applegate. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class FacebookLoginViewController: UIViewController, FBSDKLoginButtonDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
    
            let permissions = ["public_profile", "email", "user_about_me", "user_birthday", "user_education_history", "user_location", "user_work_history"]
            
            let loginView: FBSDKLoginButton = FBSDKLoginButton()
            loginView.center = self.view.center
            self.view.addSubview(loginView)
            loginView.readPermissions = permissions
            loginView.delegate = self
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        
        print("User Logged In")
        
        
        let parameters: Parameters = [
                "userName":"Jack Smith",
                "userAge":30,
                "userEducation":"Test School",
                "userGender":"Male",
                "userEmailAddress":"test@test.com"
        ]
        
        Alamofire.request("http://192.241.239.178:3000/createUser", method: .post, parameters: parameters, encoding: JSONEncoding.default).response(completionHandler: {response in
            print("")
            print("response : \(response)")
            print("")
            if #available(iOS 10.0, *) {
                print("response.metrics : \(response.metrics)")
            }
            print("")
            print("response.data : \(response.data!)")
            print("")
            print("response.error : \(response.error)")
            let str = NSString(data: response.data!, encoding: String.Encoding.utf8.rawValue)
            let json = JSON(data: response.data!)
            print("JSON : \(json)")
            print("")
            print("STR : \(str)")
            print("")
            print("response.request : \(response.request)")
            print("")
            print("response.response : \(response.response)")
            print("")
            print("response.timeline : \(response.timeline)")
            print("")
        })
        
        if ((error) != nil)
        {
            print("log in error : \(error)")
        }
//        else if result.isCancelled {
//            // Handle cancellations
//        }
            
        else {

            if result.grantedPermissions.contains("") // loop through permissions array
            {
                // save permissions to backend
            }
            
            performSegue(withIdentifier: "logedInSegue", sender: nil)
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("User Logged Out")
    }
    
}
