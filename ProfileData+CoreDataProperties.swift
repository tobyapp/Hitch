//
//  ProfileData+CoreDataProperties.swift
//  
//
//  Created by Toby Applegate on 22/12/2015.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension ProfileData {

    @NSManaged var userAge: String?
    @NSManaged var userEducation: String?
    @NSManaged var userEmailAddress: String?
    @NSManaged var userGender: String?
    @NSManaged var userName: String?

}
