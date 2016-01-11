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
    
    func retrieveRoutes() {

    
    let query = PFQuery(className:"UserRoutes")
    //query.whereKey("UserType", equalTo:"driver")
    query.findObjectsInBackgroundWithBlock {
        (objects: [PFObject]?, error: NSError?) -> Void in
    
        if error == nil {
            // The find succeeded.
            print("Successfully retrieved \(objects!.count) objects.")
            // Do something with the found objects
            if let objects = objects {
                for object in objects {
                    
                    print(object.objectForKey("UserType"))
                    
                    
                    
                    
      
                    
                    
                    
                }
            }
        } else {
            // Log details of the failure
            print("Error: \(error!) \(error!.userInfo)")
        }
    }
    }

}