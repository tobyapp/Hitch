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
        
        // Gets current logged in users objectId and uses that to compare retieved objects
        let currentUser = PFUser.current()?.value(forKey: "objectId")
        let query = PFQuery(className:"UserRoutes")
        
        // Retirves all routes from Parse 
        query.findObjectsInBackground {
            (objects: [PFObject]?, error: Error?) -> Void? in
            if error == nil {
                if let objects = objects {
                    // Iterates through each PFObject in the query results
                    for object in objects {
                        let user = object.object(forKey: "User")
                        let userQuery = object["User"] as! PFObject
                        
                        // Querys FK in UserRoutes table and obtains user's details from who plotted the route
                        userQuery.fetchIfNeededInBackground {
                            (users: PFObject?, error: NSError?) -> Void in
                            let userName = user?["userName"]
                            let userID = user!.value(forKey: "objectId") //will act as objectID
                            // Checks if the user's id from parse matches the id of the currently logged in user
                            if ("\(userID!)" == "\(currentUser!)") {
                                
                                var routeDict = [String: AnyObject]()
                                
                                routeDict["DestinationLatitude"] = object.object(forKey: "DestinationLatitude")!
                                routeDict["DestinationLongitude"] = object.object(forKey: "DestinationLongitude")!
                                routeDict["UserType"] = object.object(forKey: "UserType")!
                                routeDict["UserName"] = userName!
                                routeDict["TimeOfRoute"] = object.object(forKey: "TimeOfRoute")!
                                routeDict["UserID"] = userID!
                                routeDict["UserRoute"] = object.object(forKey: "UserRoute")!
                                routeDict["ExtraRideInfo"] = object.object(forKey: "ExtraRideInfo")!
                                routeDict["RouteId"] = object.value(forKey: "objectId")!
                                
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
    func retrieveRoutes(_ resultHandler: @escaping (_ routeObjects: [String: AnyObject]) -> ()) {

        let query = PFQuery(className:"UserRoutes")
        let defaults = UserDefaults.standard
        
        // Retirves all routes from Parse
        query.findObjectsInBackground {
            (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                if let objects = objects {
                    // Iterates through each PFObject in the query results
                    for object in objects {
                        
                        // checkes to see if routes are already booked or not
                        if (object["match"] == nil) {
                            
                            let user = object.object(forKey: "User")
                            let userQuery = object["User"] as! PFObject
                            let routeObjectId = object.value(forKey: "objectId")

                            // Querys FK in UserRoutes table and obtains user's details from who plotted the route
                            userQuery.fetchIfNeededInBackground {
                                (users: PFObject?, error: NSError?) -> Void in

                                let userName = user?["userName"]
                                let userID = user!.value(forKey: "objectId")
                                
                                var routeDict = [String: AnyObject]()
                                
                                let agePreference = Int(defaults.string(forKey: "AgePreference")!)
                                let genderPreference = defaults.string(forKey: "GenderPreference")!
      
                                // if users age is equal or less then users preffered age range of users and euqals the desired gender or either
                                if (Int("\((user?["userAge"]!)!)")! <= agePreference! && ( "\((user?["userGender"]!)!)" == genderPreference || genderPreference == "either") ) {
                                
                                    routeDict["DestinationLatitude"] = object.object(forKey: "DestinationLatitude")!
                                    routeDict["DestinationLongitude"] = object.object(forKey: "DestinationLongitude")!
                                    routeDict["UserRoute"] = object.object(forKey: "UserRoute")!
                                    routeDict["UserType"] = object.object(forKey: "UserType")!
                                    routeDict["UserName"] = userName!
                                    routeDict["TimeOfRoute"] = object.object(forKey: "TimeOfRoute")!
                                    routeDict["UserID"] = userID!
                                    routeDict["RoutId"] = routeObjectId!
                                    routeDict["ExtraRideInfo"] = object.object(forKey: "ExtraRideInfo")!
                                
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
    func retrieveMatchedRoutes(_ resultHandler: @escaping (_ matchedDict: [String: AnyObject]) -> ()) {
        
        // Gets current logged in users objectId and uses that to compare retieved objects
        let currentUser = PFUser.current()?.value(forKey: "objectId")
        let query = PFQuery(className:"UserRoutes")
        
        // Retirves all routes from Parse
        query.findObjectsInBackground {
            (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                if let objects = objects {
                    // Iterates through each PFObject in the query results
                    for object in objects {
                        let user = object.object(forKey: "User")
                        let userQuery = object["User"] as! PFObject
                        
                        // Querys FK in UserRoutes table and obtains user's details from who plotted the route
                        userQuery.fetchIfNeededInBackground {
                            (users: PFObject?, error: NSError?) -> Void in
                            let userName = user?["userName"]
                            let userID = user!.value(forKey: "objectId") //will act as objectID
                            
                            // if match isnt nil then get the value
                            if let match = object.object(forKey: "match") {
                                
                                // Check if match's objectId (as match = pointer to User object) = current logged in user
                                if ("\(match.value(forKey: "objectId")!)" == "\(currentUser!)") {
                                    
                                    var routeDict = [String: AnyObject]()
                                    let user = object.object(forKey: "User")
                                    
                                    routeDict["DestinationLatitude"] = object.object(forKey: "DestinationLatitude")!
                                    routeDict["DestinationLongitude"] = object.object(forKey: "DestinationLongitude")!
                                    routeDict["UserType"] = object.object(forKey: "UserType")!
                                    routeDict["UserName"] = userName!
                                    routeDict["TimeOfRoute"] = object.object(forKey: "TimeOfRoute")!
                                    routeDict["UserID"] = userID!
                                    routeDict["ExtraRideInfo"] = object.object(forKey: "ExtraRideInfo")!
                                    routeDict["Reviewed"] = object.object(forKey: "Reviewed")!
                                    routeDict["RouteId"] = object.value(forKey: "objectId")!
                                    routeDict["UserID"] = user!.value(forKey: "objectId")
                                    
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
    func retrieveUserDetails(_ userID: String, resultHandler: @escaping (_ userDetails: [String:AnyObject]) -> ()) {
        
        // Searches User class on parse with User's ID
        let query = PFQuery(className:"_User")
        query.getObjectInBackground(withId: userID) {
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
                        userDisplayPicture.getDataInBackground {
                            (imageData: Data?, error: NSError?) -> Void in
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
