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
    func retrieveUsersOwnRoutes(resultHandler: (routeObjects: [String: AnyObject]) -> ()) {
        
        // Gets current logged in users objectId and uses that to compare retieved objects
        let currentUser = PFUser.currentUser()?.valueForKey("objectId")
        let query = PFQuery(className:"UserRoutes")
        
        // Retirves all routes from Parse 
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                if let objects = objects {
                    // Iterates through each PFObject in the query results
                    for object in objects {
                        let user = object.objectForKey("User")
                        let userQuery = object["User"] as! PFObject
                        
                        // Querys FK in UserRoutes table and obtains user's details from who plotted the route
                        userQuery.fetchIfNeededInBackgroundWithBlock {
                            (users: PFObject?, error: NSError?) -> Void in
                            let userName = user?["userName"]
                            let userID = user!.valueForKey("objectId") //will act as objectID
                            // Checks if the user's id from parse matches the id of the currently logged in user
                            if ("\(userID!)" == "\(currentUser!)") {
                                
                                var routeDict = [String: AnyObject]()
                                
                                routeDict["DestinationLatitude"] = object.objectForKey("DestinationLatitude")!
                                routeDict["DestinationLongitude"] = object.objectForKey("DestinationLongitude")!
                                routeDict["UserType"] = object.objectForKey("UserType")!
                                routeDict["UserName"] = userName!
                                routeDict["TimeOfRoute"] = object.objectForKey("TimeOfRoute")!
                                routeDict["UserID"] = userID!
                                routeDict["UserRoute"] = object.objectForKey("UserRoute")!
                                routeDict["ExtraRideInfo"] = object.objectForKey("ExtraRideInfo")!
                                routeDict["RouteId"] = object.valueForKey("objectId")!
                                
                                resultHandler(routeObjects: routeDict)
                            }
                        }
                    }
                }
            } else {
            // Log details of the failure
            print("Error: \(error!) \(error!.userInfo)")
            }
        }
    }
    
    // Retireves route's from users + info about each user
    func retrieveRoutes(resultHandler: (routeObjects: [String: AnyObject]) -> ()) {

        let query = PFQuery(className:"UserRoutes")
        let defaults = NSUserDefaults.standardUserDefaults()
        
        // Retirves all routes from Parse
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                if let objects = objects {
                    // Iterates through each PFObject in the query results
                    for object in objects {
                        
                        // checkes to see if routes are already booked or not
                        if (object["match"] == nil) {
                            
                            let user = object.objectForKey("User")
                            let userQuery = object["User"] as! PFObject
                            let routeObjectId = object.valueForKey("objectId")

                            // Querys FK in UserRoutes table and obtains user's details from who plotted the route
                            userQuery.fetchIfNeededInBackgroundWithBlock {
                                (users: PFObject?, error: NSError?) -> Void in

                                let userName = user?["userName"]
                                let userID = user!.valueForKey("objectId")
                                
                                var routeDict = [String: AnyObject]()
                                
                                let agePreference = Int(defaults.stringForKey("AgePreference")!)
                                let genderPreference = defaults.stringForKey("GenderPreference")!
      
                                // if users age is equal or less then users preffered age range of users and euqals the desired gender or either
                                if (Int("\((user?["userAge"]!)!)")! <= agePreference! && ( "\((user?["userGender"]!)!)" == genderPreference || genderPreference == "either") ) {
                                
                                    routeDict["DestinationLatitude"] = object.objectForKey("DestinationLatitude")!
                                    routeDict["DestinationLongitude"] = object.objectForKey("DestinationLongitude")!
                                    routeDict["UserRoute"] = object.objectForKey("UserRoute")!
                                    routeDict["UserType"] = object.objectForKey("UserType")!
                                    routeDict["UserName"] = userName!
                                    routeDict["TimeOfRoute"] = object.objectForKey("TimeOfRoute")!
                                    routeDict["UserID"] = userID!
                                    routeDict["RoutId"] = routeObjectId!
                                    routeDict["ExtraRideInfo"] = object.objectForKey("ExtraRideInfo")!
                                
                                    // Returns objects in completion handler
                                    resultHandler(routeObjects: routeDict)
                                }
                            }
                        }
                    }
                }
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
            }
        }
    }

    
    // Retireves route's from users + info about each user
    func retrieveMatchedRoutes(resultHandler: (matchedDict: [String: AnyObject]) -> ()) {
        
        // Gets current logged in users objectId and uses that to compare retieved objects
        let currentUser = PFUser.currentUser()?.valueForKey("objectId")
        let query = PFQuery(className:"UserRoutes")
        
        // Retirves all routes from Parse
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                if let objects = objects {
                    // Iterates through each PFObject in the query results
                    for object in objects {
                        let user = object.objectForKey("User")
                        let userQuery = object["User"] as! PFObject
                        
                        // Querys FK in UserRoutes table and obtains user's details from who plotted the route
                        userQuery.fetchIfNeededInBackgroundWithBlock {
                            (users: PFObject?, error: NSError?) -> Void in
                            let userName = user?["userName"]
                            let userID = user!.valueForKey("objectId") //will act as objectID
                            
                            // if match isnt nil then get the value
                            if let match = object.objectForKey("match") {
                                
                                // Check if match's objectId (as match = pointer to User object) = current logged in user
                                if ("\(match.valueForKey("objectId")!)" == "\(currentUser!)") {
                                    
                                    var routeDict = [String: AnyObject]()
                                    let user = object.objectForKey("User")
                                    
                                    routeDict["DestinationLatitude"] = object.objectForKey("DestinationLatitude")!
                                    routeDict["DestinationLongitude"] = object.objectForKey("DestinationLongitude")!
                                    routeDict["UserType"] = object.objectForKey("UserType")!
                                    routeDict["UserName"] = userName!
                                    routeDict["TimeOfRoute"] = object.objectForKey("TimeOfRoute")!
                                    routeDict["UserID"] = userID!
                                    routeDict["ExtraRideInfo"] = object.objectForKey("ExtraRideInfo")!
                                    routeDict["Reviewed"] = object.objectForKey("Reviewed")!
                                    routeDict["RouteId"] = object.valueForKey("objectId")!
                                    routeDict["UserID"] = user!.valueForKey("objectId")
                                    
                                    resultHandler(matchedDict: routeDict)
                                }
   
                            }
                        }
                    }
                }
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
            }
        }
    }
    
    // Retrive users accoutn details (age, uni, genrder, name and dp) and return in completion handler
    // Needed to set return dict as Anyobject to include UIImage, else set to string
    func retrieveUserDetails(userID: String, resultHandler: (userDetails: [String:AnyObject]) -> ()) {
        
        // Searches User class on parse with User's ID
        let query = PFQuery(className:"_User")
        query.getObjectInBackgroundWithId(userID) {
            (objects: PFObject?, error: NSError?) -> Void in
            var userDetails = [String: AnyObject]()
            if error == nil {
                if let objects = objects {
                    userDetails["userAge"] = ("\(objects["userAge"])")
                    userDetails["userEducation"] = ("\(objects["userEducation"])")
                    userDetails["userGender"] = ("\(objects["userGender"])")
                    userDetails["userName"] = ("\(objects["userName"])")
                    userDetails["userEmailAddress"] = ("\(objects["userEmailAddress"])")
                    
                    if let userDisplayPicture = objects["UserDisplayPicture"] as! PFFile? {
            
                        //get users display picture from Parse
                        userDisplayPicture.getDataInBackgroundWithBlock {
                            (imageData: NSData?, error: NSError?) -> Void in
                            if error == nil {
                                let image = UIImage(data: imageData!)
                                userDetails["userDisplayPicture"] = image
                                resultHandler(userDetails: userDetails)
                            }
                            else {
                                print("Error: \(error!)")
                            }
                        }
                    }
                }
            }
        }
    }
   
    
    
}