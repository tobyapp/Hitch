//
//  UserAccount.swift
//  hitch
//
//  Created by Toby Applegate on 29/12/2015.
//  Copyright © 2015 Toby Applegate. All rights reserved.
//


// Use this class form the AppDelegate once the user has logged in to grab the user data, once this class has done this other class's can grab the data from this class


import Foundation
import Parse
import ParseFacebookUtilsV4

class UserAccount {
    
    var facebookProfileData = ParseFBData()
    
    var userName: String?
    var userGender: String?
    var userDOB: String?
    var userEducation: String?
    var userEmail: String?
    var displayPicture: NSData?
    var notUploadedData = true
    
    init() {
        grabFacebookData()
        grabFacebookPicture()
    }
    
    func grabFacebookPicture() {
        facebookProfileData.getProfilePicture {(pictureData, error) -> Void in
            if error != nil {
                print("login error: \(error!.localizedDescription)")
            }
            self.displayPicture = pictureData!
        }
    }
    
    func grabFacebookData() {
        facebookProfileData.getUserDetails { (nameData, genderData, dobData, educationData, emailData, error) -> Void in
            if error != nil {
                print("login error: \(error!.localizedDescription)")
            }
        
            self.userName =  nameData
            self.userGender = genderData
            self.userDOB = dobData
            self.userEducation = educationData
            self.userEmail = emailData
        }
    }
    
    func upLoadData() {
        
        facebookProfileData.getUserDetails { (nameData, genderData, dobData, educationData, emailData, error) -> Void in
            if error != nil {
                print("login error: \(error!.localizedDescription)")
            }
            self.userName =  nameData
            self.userGender = genderData
            self.userDOB = dobData
            self.userEducation = educationData
            self.userEmail = emailData
            
            PFUser.currentUser()!.setObject(self.userName!, forKey: "userName")
            PFUser.currentUser()!.setObject(Int(self.userDOB!)!, forKey: "userAge")
            PFUser.currentUser()!.setObject(self.userGender!, forKey: "userGender")
            PFUser.currentUser()!.setObject(self.userEmail!, forKey: "userEmailAddress")
            PFUser.currentUser()!.setObject(self.userEducation!, forKey: "userEducationN")
            PFUser.currentUser()!.saveInBackgroundWithBlock{ (succeeded: Bool, error: NSError?) -> Void in
                if succeeded {
                    print("Save successful")
                } else {
                    print("Save unsuccessful: \(error!.userInfo)")
                    //was error?.userInfo, got rid of ? for ! to get rid of optional in consol
                }
            }
        }
    }

    func addLocationData(route: String, userType: String) {
        let object = PFObject(className: "UserRoutes")
        let currentUser = PFUser.currentUser()
        object.setObject(route, forKey: "UserRoute")
        object.setObject(userType, forKey: "UserType")
        object.setObject(currentUser!, forKey: "User")
        object.saveInBackgroundWithBlock{ (succeeded: Bool, error: NSError?) -> Void in
            if succeeded {
                print("Save successful")
            } else {
                print("Save unsuccessful: \(error!.userInfo)")
            }
        }
    }
}

