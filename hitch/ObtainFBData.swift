//
//  ParseFBData.swift
//  hitch
//
//  Created by Toby Applegate on 21/12/2015.
//  Copyright © 2015 Toby Applegate. All rights reserved.
//

import Foundation
import SwiftyJSON


class ObtainFBData {
    
    // managedObjectContext - Managed object to work with objects (Facebook data) in CoreData
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
    
    // Function to obtain users Facebook profile picture
    func getProfilePicture(_ completion: @escaping (_ pictureData: Data?, _ error: NSError?) -> Void) {
        
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"picture.type(large)"])
        
        graphRequest.start(completionHandler: { (connection, result, error) -> Void in
            
            var pictureData: Data?
            
            if error != nil {
                print("login error: \(error!.localizedDescription)")
                return
            }
            
            // Parses data using SwiftyJSON
            let json = JSON(result)
            let profilePicture = json["picture"]["data"]["url"].stringValue
            
            // Assigns users profile picture to varibale to be returned
//            if let url = URL(string: profilePicture) {
//                pictureData = try! Data(contentsOfURL: url)
//            }

            do {
                let url = try URL(string: profilePicture)

            } catch {
                // contents could not be loaded
            }
            
            // Use completion handler to return variables on completion
            completion(pictureData, error as NSError?)
        })
    }
    
    // Function to obtain users name form Facebook profile
    func getUserDetails(_ completion: @escaping (_ nameData: String?, _ genderData: String?, _ dobData: String?, _ educationData: String?, _ emailData: String?, _ error: NSError?) -> Void) {
        print("getting data form fb")
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"first_name, gender, birthday, education, email"])
        graphRequest.start(completionHandler: { (connection, result, error) -> Void in
            
            if error != nil {
                print("login error: \(error!.localizedDescription)")
                return
            }
            else {
            // Parses data using SwiftyJSON
            let json = JSON(result)
            
            var userEducation: String?
            let userName = json["first_name"].stringValue
            let userGender = json["gender"].stringValue
            let userAge = self.calculateAge(json["birthday"].stringValue)
            let userEmail = json["email"].stringValue
                
            
            //var userEducationArray = ""
            if let uniArray = json["education"].array {
                for uni in uniArray {
                    if uni["type"].stringValue == "College" {
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
            completion(userName, userGender, userAge, userEducation, userEmail, error as NSError?)
            }
        })
    }

    func calculateAge(_ dob: String?) -> String {
        if dob != nil {
        let splitDOB  = dob!.components(separatedBy: "/")
        let formattedDOB = "\(splitDOB[2])-\(splitDOB[1])-\(splitDOB[0]) 00:00:00 +0000"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        let formattedDate = dateFormatter.date(from: formattedDOB)
        return "\((Calendar.current as NSCalendar).components(.year, from: formattedDate!, to: Date(), options: []).year)"
        }
        return ""
    }
}
