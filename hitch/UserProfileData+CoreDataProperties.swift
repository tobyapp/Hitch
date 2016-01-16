//
//  UserProfileData+CoreDataProperties.swift
//  
//
//  Created by Toby Applegate on 16/01/2016.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension UserProfileData {

    @NSManaged var userName: String?
    @NSManaged var userAge: String?
    @NSManaged var userGender: String?
    @NSManaged var userEducation: String?
    @NSManaged var userDisplayPicture: NSData?

}
