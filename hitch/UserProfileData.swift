//
//  UserProfileData.swift
//  
//
//  Created by Toby Applegate on 16/01/2016.
//
//

import Foundation
import CoreData


class UserProfileData: NSManagedObject {

// Insert code here to add functionality to your managed object subclass
    
    class func createInManagedObjectContext(moc: NSManagedObjectContext, userName: String, userAge: String, userGender: String, userEducation: String, userDisplayPicture: NSData) -> UserProfileData {
        let newProfile = NSEntityDescription.insertNewObjectForEntityForName("UserProfileData", inManagedObjectContext: moc) as! UserProfileData
        newProfile.userName = userName
        newProfile.userAge = userAge
        newProfile.userGender = userGender
        newProfile.userEducation = userEducation
        newProfile.userDisplayPicture = userDisplayPicture
        
        return newProfile
        
    }
}
