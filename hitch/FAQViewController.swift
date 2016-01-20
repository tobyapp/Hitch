//
//  ProfileViewController.swift
//  hitch
//
//  Created by Toby Applegate on 21/12/2015.
//  Copyright © 2015 Toby Applegate. All rights reserved.
//

import UIKit
import Parse

class FAQViewController: UIViewController{

    @IBOutlet weak var menuButton: UIBarButtonItem!

    let account = RetrieveDataFromBackEnd()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Used to display side menu (using SWRevealViewController)
        self.addSideMenu(menuButton)
        
        
        let params = ["usersOriginLatitude" : 37.33074384,  "usersOriginLongitude" : -122.02322912, "usersDestLatitude" : 40.7747314,  "usersDestLongitude" : -73.96537339999999]
        PFCloud.callFunctionInBackground("routeProximity", withParameters: params) { ( response, error) -> Void in
            if error == nil {
                print(response)
                print("going to retireve objects")
                //self.account.retrieveObjectFromPointer(response!)
                
                //print(response)
                var count = 0
                let objects = response as! [PFObject]
                for object in objects {
                    count++
                    print("count for    \(object)   is \(count)")
                }
                
                
                
            }
            else {
                print(error)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
}
