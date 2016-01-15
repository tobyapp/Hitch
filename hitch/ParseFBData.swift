//
//  ParseFBData.swift
//  hitch
//
//  Created by Toby Applegate on 21/12/2015.
//  Copyright © 2015 Toby Applegate. All rights reserved.
//

import Foundation
import SwiftyJSON


class ParseFBData {
    
    // managedObjectContext - Managed object to work with objects (Facebook data) in CoreData
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    // Function to obtain users Facebook profile picture
    func getProfilePicture(completion: (pictureData: NSData?, error: NSError?) -> Void) {
        
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"picture.type(large)"])
        
        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
            
            var pictureData: NSData?
            
            if error != nil {
                print("login error: \(error!.localizedDescription)")
                return
            }
            
            // Parses data using SwiftyJSON
            let json = JSON(result)
            let profilePicture = json["picture"]["data"]["url"].stringValue
            
            // Assigns users profile picture to varibale to be returned
            if let url = NSURL(string: profilePicture) {
                pictureData = NSData(contentsOfURL: url)
            }
            
            // Use completion handler to return variables on completion
            completion(pictureData: pictureData, error: error)
        })
    }
    
    // Function to obtain users name form Facebook profile
    func getUserDetails(completion: (nameData: String?, genderData: String?, dobData: String?, educationData: String?, emailData: String?, error: NSError?) -> Void) {
        //let moc = self.managedObjectContext
        //print(moc)
        print("getting data form fb")
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"first_name, gender, birthday, education, email"])
        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
            
            if error != nil {
                print("login error: \(error!.localizedDescription)")
                return
            }
            else {
            // Parses data using SwiftyJSON
            let json = JSON(result)
            
            //print(result)
            
            var userEducation: String?
            let userName = json["first_name"].stringValue
            let userGender = json["gender"].stringValue
            let userAge = self.calculateAge(json["birthday"].stringValue)
            let userEmail = json["email"].stringValue
                
            
            //var userEducationArray = ""
            if let uniArray = json["education"].array {
                for uni in uniArray {
                    if uni["type"].stringValue == "College" {
                        //print(uni["school"]["name"].stringValue)
                        userEducation = uni["school"]["name"].stringValue
                    }
                    else if uni["type"].stringValue == "High School" {
                        userEducation = uni["school"]["name"].stringValue
                    }
                    else {
                        userEducation = ""
                    }
                }
            }
            // Use completion handler to return variables on completion
            completion(nameData: userName, genderData: userGender, dobData: userAge, educationData: userEducation, emailData: userEmail, error: error)
            }
        })
        
    }
    
//    // Function to obtain users name form Facebook profile
//    func getUserName(completion: (nameData: String?, error: NSError?) -> Void) {
//
//        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"first_name"])
//        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
//            
//            if error != nil {
//                print("login error: \(error!.localizedDescription)")
//                return
//            }
//            else {
//                // Parses data using SwiftyJSON
//                let json = JSON(result)
//                
//                //print(result)
//                
//                let userName = json["first_name"].stringValue
//                
//                // Use completion handler to return variables on completion
//                completion(nameData: userName, error: error)
//            }
//        })
//        
//    }

    func calculateAge(dob: String?) -> String {
        if dob != nil {
        let splitDOB  = dob!.componentsSeparatedByString("/")
        let formattedDOB = "\(splitDOB[2])-\(splitDOB[1])-\(splitDOB[0]) 00:00:00 +0000"
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        let formattedDate = dateFormatter.dateFromString(formattedDOB)
        return "\(NSCalendar.currentCalendar().components(.Year, fromDate: formattedDate!, toDate: NSDate(), options: []).year)"
        }
        return ""
    }
}