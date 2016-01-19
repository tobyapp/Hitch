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

    override func viewDidLoad() {
        super.viewDidLoad()

        // Used to display side menu (using SWRevealViewController)
        self.addSideMenu(menuButton)
        
        
        let params = ["usersOriginLat" : 37.33233141,  "usersOriginLon" : -122.0312186]
        PFCloud.callFunctionInBackground("routeProximity", withParameters: params) { ( response, error) -> Void in
            if error == nil {
                print(response)
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
