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
    
    func retrieveRoutes(resultHandler: (routeObjects: [PFObject]?) -> ()) {
        //, userObjects: PFObject?
//resultHandler: (directions: String?) -> ()) -> ()

    let query = PFQuery(className:"UserRoutes")
    //query.whereKey("UserType", equalTo:"driver")
    query.findObjectsInBackgroundWithBlock {
        (objects: [PFObject]?, error: NSError?) -> Void in
    
        if error == nil {

            if let objects = objects {
                for object in objects {
                    
                    print(object.objectForKey("User"))
                    let user = object.objectForKey("User")
                    print(user)
                    
                    
                    let userQuery = object["User"] as! PFObject
                    userQuery.fetchIfNeededInBackgroundWithBlock {
                        (users: PFObject?, error: NSError?) -> Void in
                        let title = user?["userEmailAddress"]
                        print(title)
                        resultHandler(routeObjects: objects)
                    }
                    
                    
                    
                }
//                resultHandler(routeObjects: objects, userObjects: users)
            }
        } else {
            // Log details of the failure
            print("Error: \(error!) \(error!.userInfo)")
        }
    }
    }

}