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
import CoreData

class UploadDataToBackEnd {
    
    var facebookProfileData = ParseFBData()
    
    var userName: String?
    var userGender: String?
    var userDOB: String?
    var userEducation: String?
    var userEmail: String?
    var displayPicture: NSData?
    var notUploadedData = true
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
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
            
            let moc = self.managedObjectContext
            
            self.facebookProfileData.getProfilePicture {(pictureData, error) -> Void in
                if error != nil {
                    print("login error: \(error!.localizedDescription)")
                }
                let displayPicture = UIImage(data: pictureData!)
                let imageData = UIImagePNGRepresentation(displayPicture!)
                
                // Fetches current object in CoreData
                let fetchRequest = NSFetchRequest(entityName: "UserProfileData")
                do {
                   var profileData = try (self.managedObjectContext.executeFetchRequest(fetchRequest) as? [UserProfileData])!
                    // If theres more then one object in CoreData, overwrite it with new user details
                    if profileData.count != 0 {
                        let managedObject = profileData[0]
                        managedObject.setValue(nameData!, forKey: "userName")
                        managedObject.setValue(dobData!, forKey: "userAge")
                        managedObject.setValue(genderData!, forKey: "userGender")
                        managedObject.setValue(educationData!, forKey: "userEducation")
                        managedObject.setValue(imageData!, forKey: "userDisplayPicture")
                        self.saveCoreData()
                    }
                    // If theres no objec tin coredata (first time apps been used), insert values and save
                    else if profileData.count == 0 {
                        UserProfileData.createInManagedObjectContext(moc, userName: nameData!, userAge: dobData!, userGender: genderData!, userEducation: educationData!, userDisplayPicture: imageData!)
                        self.saveCoreData()

                    }
                }
                    
                catch let error as NSError {
                    print("Fetch failed: \(error.localizedDescription)")
                }
//                UserProfileData.createInManagedObjectContext(moc, userName: nameData!, userAge: dobData!, userGender: genderData!, userEducation: educationData!, userDisplayPicture: imageData!)
//                self.saveCoreData()
            }
        }
    }
    
    func saveCoreData() {
        do {
            try managedObjectContext.save()
        }
        catch let error as NSError {
            print("Save failed: \(error.localizedDescription)")
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
            PFUser.currentUser()!.setObject(self.userEducation!, forKey: "userEducation")
            PFUser.currentUser()!.saveInBackgroundWithBlock{ (succeeded: Bool, error: NSError?) -> Void in
                if succeeded {
                    print("Save successful")
                } else {
                    print("Save unsuccessful: \(error!.userInfo)")
                    //was error?.userInfo, got rid of ? for ! to get rid of optional in consol
                }
            }
        }
        facebookProfileData.getProfilePicture {(pictureData, error) -> Void in
            if error != nil {
                print("login error: \(error!.localizedDescription)")
            }
            let displayPicture = UIImage(data: pictureData!)
            let imageData = UIImagePNGRepresentation(displayPicture!)
            let imageFile = PFFile(name:"image.png", data:imageData!)
            PFUser.currentUser()!.setObject(imageFile!, forKey: "UserDisplayPicture")
            PFUser.currentUser()!.saveInBackgroundWithBlock{ (succeeded: Bool, error: NSError?) -> Void in
                if succeeded {
                    print("Save successful")
                } else {
                    print("Save unsuccessful: \(error!.userInfo)")
                }
            }
        }

    }

    func addLocationData(route: String, userType: String, destinationLatitude: Double, destinationLongitude: Double, timeOfRoute: String) {
        let object = PFObject(className: "UserRoutes")
        let currentUser = PFUser.currentUser()
        object.setObject(route, forKey: "UserRoute")
        object.setObject(userType, forKey: "UserType")
        object.setObject(currentUser!, forKey: "User")
        object.setObject(destinationLatitude, forKey: "DestinationLatitude")
        object.setObject(destinationLongitude, forKey: "DestinationLongitude")
        object.setObject(timeOfRoute, forKey: "TimeOfRoute")
        object.saveInBackgroundWithBlock{ (succeeded: Bool, error: NSError?) -> Void in
            if succeeded {
                print("Save successful")
            } else {
                print("Save unsuccessful: \(error!.userInfo)")
            }
        }
    }
}



