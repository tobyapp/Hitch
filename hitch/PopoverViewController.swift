//
//  PopoverViewController.swift
//  hitch
//
//  Created by Toby Applegate on 07/01/2016.
//  Copyright © 2016 Toby Applegate. All rights reserved.
//

import UIKit
import MK

// Once user searches for point on map and selects it, this view will 'pop up' with option to either drive to the point, want to hitch to the point or cancel and go back to GoogleMapsViewController

class PopoverViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Changes colour scheme to purple to match rest of app, see class extentions for more details
        changeColorScheme()
        
        // Adds driving to button to view
        let drivingToButton: RaisedButton = RaisedButton(frame: CGRectMake(110, 200, 200, 30))
        drivingToButton.setTitle("I'm driving to..", forState: .Normal)
        drivingToButton.setTitleColor(MaterialColor.white, forState: .Normal)
        drivingToButton.titleLabel!.font = UIFont(name: "System", size: 15)
        drivingToButton.addTarget(self, action: "exampleAction:", forControlEvents: UIControlEvents.TouchUpInside)
        drivingToButton.backgroundColor = MaterialColor.deepPurple.base
        view.addSubview(drivingToButton)
        
        // Adds Hitch button to view
        let hitchinToButton: RaisedButton = RaisedButton(frame: CGRectMake(110, 400, 200, 30))
        hitchinToButton.setTitle("I'm Hitch'n to..", forState: .Normal)
        hitchinToButton.setTitleColor(MaterialColor.white, forState: .Normal)
        hitchinToButton.titleLabel!.font = UIFont(name: "System", size: 15)
        hitchinToButton.addTarget(self, action: "exampleAction:", forControlEvents: UIControlEvents.TouchUpInside)
        hitchinToButton.backgroundColor = MaterialColor.deepPurple.base
        view.addSubview(hitchinToButton)
        
        // Adds back button (cancel) to view
        let backButton:UIBarButtonItem = UIBarButtonItem(
            title: "Cancel",
            style: UIBarButtonItemStyle.Plain,
            target: self,
            action: "cancel:")
        
        self.navigationItem.setLeftBarButtonItem(backButton, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Example action, need to change
    func exampleAction(sender: UIButton){
        print("In exampleAction")
    }
    
    // Cancel button to go back to previous view (GoogleMapsViewController)
    func cancel(sender: UIButton){
        print("before dissmiss")
        self.dismissViewControllerAnimated(true, completion: nil)
        print("cancle")
    }
}
