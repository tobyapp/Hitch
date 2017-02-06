//
//  RetrieveDataFromBackEnd.swift
//  hitch
//
//  Created by Toby Applegate on 11/01/2016.
//  Copyright © 2016 Toby Applegate. All rights reserved.
//

import Foundation
import Parse

class RetrieveDataFromBackEnd {
    
    // Retirve current logged in users own routes
    func retrieveUsersOwnRoutes(_ resultHandler: @escaping (_ routeObjects: [String: AnyObject]) -> ()) {
        
        var routeDict = [String: AnyObject]()
        resultHandler(routeDict)
        
//        // Gets current logged in users objectId and uses that to compare retieved objects
//        let currentUser = PFUser.current()?.value(forKey: "objectId")
//        let query = PFQuery(className:"UserRoutes")
//        
//        // Retirves all routes from Parse
//        query.findObjectsInBackground { (objects:[PFObject]?, error:Error?) in
//            if error == nil {
//                if let objects = objects {
//                    // Iterates through each PFObject in the query results
//                    for object in objects {
//                        let user: PFObject = object.object(forKey: "User") as! PFObject
//                        let userQuery = object["User"] as! PFObject
//                        
//                        // Querys FK in UserRoutes table and obtains user's details from who plotted the route
//                        userQuery.fetchIfNeededInBackground {
//                            (users: PFObject?, error: Error?) in
//                            let userName = user["userName"]
//                            let userID = (user as AnyObject).value(forKey: "objectId") //will act as objectID
//                            // Checks if the user's id from parse matches the id of the currently logged in user
//                            if ("\(userID!)" == "\(currentUser!)") {
//                                
//                                var routeDict = [String: AnyObject]()
//                                
//                                routeDict["DestinationLatitude"] = object.object(forKey: "DestinationLatitude")! as AnyObject?
//                                routeDict["DestinationLongitude"] = object.object(forKey: "DestinationLongitude")! as AnyObject?
//                                routeDict["UserType"] = object.object(forKey: "UserType")! as AnyObject?
//                                routeDict["UserName"] = userName! as AnyObject?
//                                routeDict["TimeOfRoute"] = object.object(forKey: "TimeOfRoute")! as AnyObject?
//                                routeDict["UserID"] = userID! as AnyObject?
//                                routeDict["UserRoute"] = object.object(forKey: "UserRoute")! as AnyObject?
//                                routeDict["ExtraRideInfo"] = object.object(forKey: "ExtraRideInfo")! as AnyObject?
//                                routeDict["RouteId"] = object.value(forKey: "objectId")! as AnyObject?
//                                
//                                resultHandler(routeDict)
//                            }
//                        }
//                    }
//                }
//            } else {
//            // Log details of the failure
//            print("Error: \(error!)")
//            }
//        }
    }
    
    // Retireves route's from users + info about each user
    func retrieveRoutes(_ resultHandler: @escaping (_ routeObjects: [String: AnyObject]) -> ()) {

        let query = PFQuery(className:"UserRoutes")
        let defaults = UserDefaults.standard
        var routeDict = [String: AnyObject]()
        resultHandler(routeDict)
        
        // Retirves all routes from Parse
//        query.findObjectsInBackground {
//            (objects: [PFObject]?, error: Error?) in
//            
//            if error == nil {
//                if let objects = objects {
//                    // Iterates through each PFObject in the query results
//                    for object in objects {
//                        
//                        // checkes to see if routes are already booked or not
//                        if (object["match"] == nil) {
//                            
//                            let user = object.object(forKey: "User")
//                            let userQuery = object["User"] as! PFObject
//                            let routeObjectId = object.value(forKey: "objectId")
//
//                            // Querys FK in UserRoutes table and obtains user's details from who plotted the route
//                            userQuery.fetchIfNeededInBackground {
//                                (users: PFObject?, error: Error?) in
//
//                                let userName = user?["userName"] as [String:AnyObject]
//                                
//                                //let userID = user!.value(forKey: "objectId")
//                                
//                                var routeDict = [String: AnyObject]()
//                                
//                                let agePreference = Int(defaults.string(forKey: "AgePreference")!)
//                                let genderPreference = defaults.string(forKey: "GenderPreference")!
//      
//                                // if users age is equal or less then users preffered age range of users and euqals the desired gender or either
//                                if (Int("\((user?["userAge"]!)!)")! <= agePreference! && ( "\((user?["userGender"]!)!)" == genderPreference || genderPreference == "either") ) {
//                                
//                                    routeDict["DestinationLatitude"] = object.object(forKey: "DestinationLatitude")! as AnyObject?
//                                    routeDict["DestinationLongitude"] = object.object(forKey: "DestinationLongitude")! as AnyObject?
//                                    routeDict["UserRoute"] = object.object(forKey: "UserRoute")! as AnyObject?
//                                    routeDict["UserType"] = object.object(forKey: "UserType")! as AnyObject?
//                                    routeDict["UserName"] = userName!
//                                    routeDict["TimeOfRoute"] = object.object(forKey: "TimeOfRoute")! as AnyObject?
//                                    routeDict["UserID"] = userID!
//                                    routeDict["RoutId"] = routeObjectId! as AnyObject?
//                                    routeDict["ExtraRideInfo"] = object.object(forKey: "ExtraRideInfo")! as AnyObject?
//                                
//                                    // Returns objects in completion handler
//                                    
//                                    resultHandler(routeDict)
//                                }
//                            }
//                        }
//                    }
//                }
//            } else {
//                // Log details of the failure
//                print("Error: \(error!) \(error!.userInfo)")
//            }
//        }
    }

    
    // Retireves route's from users + info about each user
    func retrieveMatchedRoutes(_ resultHandler: @escaping (_ matchedDict: [String: AnyObject]) -> ()) {
        
        var routeDict = [String: AnyObject]()
        resultHandler(routeDict)
//        // Gets current logged in users objectId and uses that to compare retieved objects
//        let currentUser = PFUser.current()?.value(forKey: "objectId")
//        let query = PFQuery(className:"UserRoutes")
//        
//        // Retirves all routes from Parse
//        query.findObjectsInBackground {
//            (objects: [PFObject]?, error: Error?) in
//            if error == nil {
//                if let objects = objects {
//                    // Iterates through each PFObject in the query results
//                    for object in objects {
//                        let user = object.object(forKey: "User")
//                        let userQuery = object["User"] as! PFObject
//                        
//                        // Querys FK in UserRoutes table and obtains user's details from who plotted the route
//                        userQuery.fetchIfNeededInBackground {
//                            (users: PFObject?, error: Error?) in
//                            let userName = user?["userName"] as! PFObject
//                            let userID = (user! as AnyObject).value(forKey: "objectId") //will act as objectID
//                            
//                            // if match isnt nil then get the value
//                            if let match = object.object(forKey: "match") {
//                                
//                                // Check if match's objectId (as match = pointer to User object) = current logged in user
//                                if ("\((match as AnyObject).value(forKey: "objectId")!)" == "\(currentUser!)") {
//                                    
//                                    var routeDict = [String: AnyObject]()
//                                    let user = object.object(forKey: "User")
//                                    
//                                    routeDict["DestinationLatitude"] = object.object(forKey: "DestinationLatitude")! as AnyObject?
//                                    routeDict["DestinationLongitude"] = object.object(forKey: "DestinationLongitude")! as AnyObject?
//                                    routeDict["UserType"] = object.object(forKey: "UserType")! as AnyObject?
//                                    routeDict["UserName"] = userName!
//                                    routeDict["TimeOfRoute"] = object.object(forKey: "TimeOfRoute")! as AnyObject?
//                                    routeDict["UserID"] = userID!
//                                    routeDict["ExtraRideInfo"] = object.object(forKey: "ExtraRideInfo")! as AnyObject?
//                                    routeDict["Reviewed"] = object.object(forKey: "Reviewed")! as AnyObject?
//                                    routeDict["RouteId"] = object.value(forKey: "objectId")! as AnyObject?
//                                    routeDict["UserID"] = (user! as AnyObject).value(forKey: "objectId")
//                                    
//                                    resultHandler(routeDict)
//                                }
//   
//                            }
//                        }
//                    }
//                }
//            } else {
//                // Log details of the failure
//                print("Error: \(error!)")
//            }
//        }
    }
    
    // Retrive users accoutn details (age, uni, genrder, name and dp) and return in completion handler
    // Needed to set return dict as Anyobject to include UIImage, else set to string
    func retrieveUserDetails(_ userID: String, resultHandler: @escaping (_ userDetails: [String:AnyObject]) -> ()) {
        
        
        var userDetails = [String: AnyObject]()
        resultHandler(userDetails)
        
        
//        // Searches User class on parse with User's ID
//        let query = PFQuery(className:"_User")
//        query.getObjectInBackground(withId: userID) {
//            (objects: PFObject?, error: Error?) in
//            var userDetails = [String: AnyObject]()
//            if error == nil {
//                if let objects = objects {
//                    userDetails["userAge"] = ("\(objects["userAge"])" as AnyObject?)
//                    userDetails["userEducation"] = ("\(objects["userEducation"])" as AnyObject?)
//                    userDetails["userGender"] = ("\(objects["userGender"])" as AnyObject?)
//                    userDetails["userName"] = ("\(objects["userName"])" as AnyObject?)
//                    userDetails["userEmailAddress"] = ("\(objects["userEmailAddress"])" as AnyObject?)
//                    
//                    if let userDisplayPicture = objects["UserDisplayPicture"] as! PFFile? {
//            
//                        //get users display picture from Parse
//                        userDisplayPicture.getDataInBackground {
//                            (imageData: Data?, error: Error?) in
//                            if error == nil {
//                                let image = UIImage(data: imageData!)
//                                userDetails["userDisplayPicture"] = image
//                                resultHandler(userDetails)
//                            }
//                            else {
//                                print("Error: \(error!)")
//                            }
//                        }
//                    }
//                }
//            }
//        }
    }
   
    
    
}
