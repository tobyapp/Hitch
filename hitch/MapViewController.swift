//
//  MapViewController.swift
//  hitch
//
//  Created by Toby Applegate on 21/12/2015.
//  Copyright © 2015 Toby Applegate. All rights reserved.
//

import UIKit
import MK
import CoreLocation

class MapViewController: UIViewController {

    @IBOutlet weak var mapImage: UIImageView!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    var userType: String?
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let drivingToButton: RaisedButton = RaisedButton(frame: CGRectMake(185, 700, 400, 60)) //CGRectMake(300, 475, 200, 30))
        drivingToButton.setTitle("Show Driving Routes..", forState: .Normal)
        drivingToButton.setTitleColor(MaterialColor.white, forState: .Normal)
        drivingToButton.titleLabel!.font = RobotoFont.mediumWithSize(20) //UIFont(name: "System", size: 15)
        drivingToButton.addTarget(self, action: "showDriverRoutes:", forControlEvents: UIControlEvents.TouchUpInside)
        drivingToButton.backgroundColor = MaterialColor.deepPurple.base
        //drivingToButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(drivingToButton)
        
        let hitchinToButton: RaisedButton = RaisedButton(frame: CGRectMake(185, 850, 400, 60)) //CGRectMake(110, 550, 200, 30))
        hitchinToButton.setTitle("Show Hitch'n Routes..", forState: .Normal)
        hitchinToButton.setTitleColor(MaterialColor.white, forState: .Normal)
        hitchinToButton.titleLabel!.font = RobotoFont.mediumWithSize(20) //UIFont(name: "System", size: 15)
        hitchinToButton.addTarget(self, action: "showHitchRoutes:", forControlEvents: UIControlEvents.TouchUpInside)
        hitchinToButton.backgroundColor = MaterialColor.deepPurple.base
        //hitchinToButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(hitchinToButton)
        
//        // Dictionary for buttons, to be used for auto layout
//        let buttonDictionary = [
//            "drivingToButton" : drivingToButton,
//            "hitchinToButton" : hitchinToButton
//            ]
//        
//        // Sizing constraints for driving button
//        let drivingToButtonHeightConstraints = NSLayoutConstraint.constraintsWithVisualFormat(
//            "H:[drivingToButton(200)]",
//            options: NSLayoutFormatOptions(rawValue: 0),
//            metrics: nil, views: buttonDictionary)
//        let drivingToButtonWidthConstraints = NSLayoutConstraint.constraintsWithVisualFormat(
//            "V:[drivingToButton(30)]",
//            options: NSLayoutFormatOptions(rawValue:0),
//            metrics: nil, views: buttonDictionary)
//        
//        drivingToButton.addConstraints(drivingToButtonHeightConstraints)
//        drivingToButton.addConstraints(drivingToButtonWidthConstraints)
//        
//        // Sizing constraints for hitching button
//        //view2
//        let hitchinToButtonHeightConstraints = NSLayoutConstraint.constraintsWithVisualFormat(
//            "H:[hitchinToButton(200)]",
//            options: NSLayoutFormatOptions(rawValue: 0),
//            metrics: nil, views: buttonDictionary)
//        let hitchinToButtonWidthConstraints = NSLayoutConstraint.constraintsWithVisualFormat(
//            "V:[hitchinToButton(30)]",
//            options: NSLayoutFormatOptions(rawValue:0),
//            metrics: nil, views: buttonDictionary)
//        
//        drivingToButton.addConstraints(hitchinToButtonHeightConstraints)
//        drivingToButton.addConstraints(hitchinToButtonWidthConstraints)
        
        
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .AuthorizedAlways, .AuthorizedWhenInUse:
                
                locationManager.desiredAccuracy = kCLLocationAccuracyBest
            case .NotDetermined:
                locationManager.requestAlwaysAuthorization()
                locationManager.requestWhenInUseAuthorization()
            case .Restricted, .Denied:
                break
            }
        }

        self.addSideMenu(menuButton) 
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showDriverRoutes(sender: UIButton){
        print("driver")
        userType = "driver"
        performSegueWithIdentifier("filterSegue", sender: nil)
    }
    
    func showHitchRoutes(sender: UIButton){
        print("hitcher")
        userType = "hitcher"
        performSegueWithIdentifier("filterSegue", sender: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "filterSegue") {
            if let destinationViewController = segue.destinationViewController as? FilterSelectionViewController {
                destinationViewController.userTypeFilter = userType
            }
        }
    }

}