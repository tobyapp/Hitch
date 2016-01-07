//
//  UserAccount.swift
//  hitch
//
//  Created by Toby Applegate on 29/12/2015.
//  Copyright © 2015 Toby Applegate. All rights reserved.
//


// Use this class form the AppDelegate once the user has logged in to grab the user data, once this class has done this other class's can grab the data from this class


import Foundation

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
            
            let object = PFObject(className: "UserData")
            object.setObject(self.userName!, forKey: "userName")
            object.setObject(Int(self.userDOB!)!, forKey: "userAge")
            object.setObject(self.userGender!, forKey: "userGender")
            object.setObject(self.userEmail!, forKey: "userEmailAddress")
            object.setObject(self.userEducation!, forKey: "userEducation")
            object.saveInBackgroundWithBlock{ (succeeded: Bool, error: NSError?) -> Void in
                if succeeded {
                    print("Save successful")
                } else {
                    print("Save unsuccessful: \(error!.userInfo)")
                    //was error?.userInfo, got rid of ? for ! to get rid of optional in consol
                }
            }
        }
    }


}

