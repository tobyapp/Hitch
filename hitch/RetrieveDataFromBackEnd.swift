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
    
    // Retireves route's from users + info about each user
    func retrieveRoutes(resultHandler: (routeObjects: [PFObject]?) -> ()) {

        var routeAndUserObjects = [PFObject]()
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
                            let userID = user?["username"] //will act as objectID
                            let userRelation = PFObject(className: "UserRelations")
                        
                            userRelation.setObject(object.objectForKey("DestinationLatitude")!, forKey: "DestinationLatitude")
                            userRelation.setObject(object.objectForKey("DestinationLongitude")!, forKey: "DestinationLongitude")
                            userRelation.setObject(object.objectForKey("UserRoute")!, forKey: "UserRoute")
                            userRelation.setObject(object.objectForKey("UserType")!, forKey: "UserType")
                            userRelation.setObject(userName!, forKey: "UserName")
                            userRelation.setObject(object.objectForKey("TimeOfRoute")!, forKey: "TimeOfRoute")
                            userRelation.setObject(userID!, forKey: "UserID")
                            
                            // Appends all the required info to PFOject array
                        	routeAndUserObjects.append(userRelation)
                            //print(userRelation)

                        	resultHandler(routeObjects: routeAndUserObjects)
                        }
                    }
                    // In case of errors above, this returns orignal data to plot routes
                    //resultHandler(routeObjects: objects)
                }
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
            }
        }
    }

    //retireve details from backend using parse object obtained from JS function in backend
//    func retrieveObjectFromPointer(userData : AnyObject, resultHandler: (userObject: [String:String]?) -> ()) {
//
//            var userDetails = [String: String]()
//            let users = userData as! [PFObject]
//        
//            for user in users {
//                user.fetchIfNeededInBackgroundWithBlock {
//                    (users: PFObject?, error: NSError?) -> Void in
//                        print(users)
//                    let userGender = users!["userGender"]
//                    let userName = users!["userName"]
//                    let userEmail = users!["userEmailAddress"]
//                    resultHandler(userObject: userDetails)
//                    print(userGender)
//            }
//        }
//
//    }
    
    // Retrive users accoutn details (age, uni, genrder, name and dp) and return in completion handler
    // Needed to set return dict as Anyobject to include UIImage, else set to string
    func retrieveUserDetails(userID: String, resultHandler: (userDetails: [String:AnyObject]) -> ()) {
        
        let query = PFUser.query()
        query!.whereKey("username", equalTo: userID)
        
        query!.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            var userDetails = [String: AnyObject]()
            if error == nil {
                if let objects = objects {
                    // Iterates through each PFObject in the query results
                    for object in objects {
                        
                        userDetails["userAge"] = ("\(object["userAge"])")
                        userDetails["userEducation"] = ("\(object["userEducation"])")
                        userDetails["userGender"] = ("\(object["userGender"])")
                        userDetails["userName"] = ("\(object["userName"])")
                        
                        if let userDisplayPicture = object["UserDisplayPicture"] as! PFFile? {
                            
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
                        //resultHandler(userDetails: userDetails)
                    }
                }
            }
        }
    }
    }
}