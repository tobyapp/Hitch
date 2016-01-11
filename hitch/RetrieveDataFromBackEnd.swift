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
                            let userID = user?["objectId"]
                            let userRelation = PFObject (className: "UserRelations")
                        
                            userRelation.setObject(object.objectForKey("UserRoute")!, forKey: "UserRoute")
                            userRelation.setObject(object.objectForKey("UserType")!, forKey: "UserType")
                            userRelation.setObject(userName!, forKey: "userName")
                            userRelation.setObject(userID!, forKey: "userID")
                            // Appends all the required info to PFOject array
                        	routeAndUserObjects.append(userRelation)

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

}