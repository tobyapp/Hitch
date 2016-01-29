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
    
    var facebookProfileData = ObtainFBData()
    var notUploadedData = true
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    init() {
        grabFacebookData()
    }
    
    func grabFacebookData() {
        facebookProfileData.getUserDetails { (nameData, genderData, dobData, educationData, emailData, error) -> Void in
            if error != nil {
                print("login error: \(error!.localizedDescription)")
            }
            
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

            PFUser.currentUser()!.setObject(nameData!, forKey: "userName")
            PFUser.currentUser()!.setObject(Int(dobData!)!, forKey: "userAge")
            PFUser.currentUser()!.setObject(genderData!, forKey: "userGender")
            PFUser.currentUser()!.setObject(emailData!, forKey: "userEmailAddress")
            PFUser.currentUser()!.setObject(educationData!, forKey: "userEducation")
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

    func addRating(rating: Double, userReviewed: String) {
        print("You gave \(userReviewed) \(rating) our of 5")
        
    }
    
    func addLocationData(route: String, userType: String, originLatitude: Double, originLongitude: Double, destinationLatitude: Double, destinationLongitude: Double, timeOfRoute: String) {
        let query = PFObject(className: "UserRoutes")
        let currentUser = PFUser.currentUser()
        query.setObject(route, forKey: "UserRoute")
        query.setObject(userType, forKey: "UserType")
        query.setObject(currentUser!, forKey: "User")
        query.setObject(originLatitude, forKey: "OriginLatitude")
        query.setObject(originLongitude, forKey: "OriginLongitude")
        query.setObject(destinationLatitude, forKey: "DestinationLatitude")
        query.setObject(destinationLongitude, forKey: "DestinationLongitude")
        query.setObject(timeOfRoute, forKey: "TimeOfRoute")
        query.saveInBackgroundWithBlock{ (succeeded: Bool, error: NSError?) -> Void in
            if succeeded {
                print("Save successful")
            } else {
                print("Save unsuccessful: \(error!.userInfo)")
            }
        }
    }
    
    func addMatchToRoute(routeId : String, userId : String) {
        let query = PFQuery(className:"UserRoutes")
        let currentUser = PFUser.currentUser()?.valueForKey("objectId")
        query.getObjectInBackgroundWithId(routeId) {
            (route: PFObject?, error: NSError?) -> Void in
                print(route)
            if error != nil {
                print("Save failed: \(error!.localizedDescription)")
            } else if let route = route {
                
                // create pointer to user object and store that in 'match' coloumn
                let pointer = PFObject(withoutDataWithClassName: "_User", objectId: "\(currentUser!)")
                route["match"] = pointer
                
                route.saveInBackgroundWithBlock{ (succeeded: Bool, error: NSError?) -> Void in
                    if succeeded {
                        print("Save successful")
                    } else {
                        print("Save unsuccessful: \(error!.userInfo)")
                    }
                }
            }
        }
    }
    
    
}

