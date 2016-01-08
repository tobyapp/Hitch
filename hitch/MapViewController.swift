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
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let drivingToButton: RaisedButton = RaisedButton(frame: CGRectMake(110, 475, 200, 30))
        drivingToButton.setTitle("I'm driving to..", forState: .Normal)
        drivingToButton.setTitleColor(MaterialColor.white, forState: .Normal)
        drivingToButton.titleLabel!.font = UIFont(name: "System", size: 15)
        drivingToButton.addTarget(self, action: "exampleAction:", forControlEvents: UIControlEvents.TouchUpInside)
        drivingToButton.backgroundColor = MaterialColor.deepPurple.base
        view.addSubview(drivingToButton)
        
        let hitchinToButton: RaisedButton = RaisedButton(frame: CGRectMake(110, 550, 200, 30))
        hitchinToButton.setTitle("I'm Hitch'n to..", forState: .Normal)
        hitchinToButton.setTitleColor(MaterialColor.white, forState: .Normal)
        hitchinToButton.titleLabel!.font = UIFont(name: "System", size: 15)
        hitchinToButton.addTarget(self, action: "exampleAction:", forControlEvents: UIControlEvents.TouchUpInside)
        hitchinToButton.backgroundColor = MaterialColor.deepPurple.base
        view.addSubview(hitchinToButton)
        
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
    
    func exampleAction(sender: UIButton){
        print("In exampleAction")
    }
}
