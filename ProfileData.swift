//
//  ProfileData.swift
//  
//
//  Created by Toby Applegate on 22/12/2015.
//
//

import Foundation
import CoreData

class ProfileData: NSManagedObject {

    class func createInManagedObjectContext(moc: NSManagedObjectContext, userAge: String, userEducation: [String], userEmailAddress: String, userGender: String, userName: String) -> ProfileData {
        
        let newItem = NSEntityDescription.insertNewObjectForEntityForName("ProfileData", inManagedObjectContext: moc) as! ProfileData
        newItem.userAge = userAge
        newItem.userEducation = userEducation
        newItem.userEmailAddress = userEmailAddress
        newItem.userGender = userGender
        newItem.userName = userName
        //newItem.likeDate = likeDate
        //newItem.pageLiked = pageLiked
        
        return newItem
    }


}
