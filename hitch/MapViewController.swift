//
//  MapViewController.swift
//  hitch
//
//  Created by Toby Applegate on 21/12/2015.
//  Copyright © 2015 Toby Applegate. All rights reserved.
//

import UIKit
import Material
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
        drivingToButton.addTarget(self, action: #selector(MapViewController.showDriverRoutes(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        drivingToButton.backgroundColor = MaterialColor.deepPurple.base
        //drivingToButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(drivingToButton)
        
        let hitchinToButton: RaisedButton = RaisedButton(frame: CGRectMake(185, 850, 400, 60)) //CGRectMake(110, 550, 200, 30))
        hitchinToButton.setTitle("Show Hitch'n Routes..", forState: .Normal)
        hitchinToButton.setTitleColor(MaterialColor.white, forState: .Normal)
        hitchinToButton.titleLabel!.font = RobotoFont.mediumWithSize(20) //UIFont(name: "System", size: 15)
        hitchinToButton.addTarget(self, action: #selector(MapViewController.showHitchRoutes(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        hitchinToButton.backgroundColor = MaterialColor.deepPurple.base
        //hitchinToButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(hitchinToButton)

        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .authorizedAlways, .authorizedWhenInUse:
                
                locationManager.desiredAccuracy = kCLLocationAccuracyBest
            case .notDetermined:
                locationManager.requestAlwaysAuthorization()
                locationManager.requestWhenInUseAuthorization()
            case .restricted, .denied:
                break
            }
        }

        self.addSideMenu(menuButton)
        
        let defaults = UserDefaults.standard
        guard let _ = defaults.string(forKey: "AgePreference") else {
            defaults.set(75, forKey: "AgePreference")
            return
        }
        guard let _ = defaults.string(forKey: "GenderPreference") else {
            defaults.set("either", forKey: "GenderPreference")
            return
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showDriverRoutes(_ sender: UIButton){
        print("driver")
        userType = "driver"
        performSegue(withIdentifier: "filterSegue", sender: nil)
    }
    
    func showHitchRoutes(_ sender: UIButton){
        print("hitcher")
        userType = "hitcher"
        performSegue(withIdentifier: "filterSegue", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        if (segue.identifier == "filterSegue") {
            if let destinationViewController = segue.destination as? FilterSelectionViewController {
                destinationViewController.userTypeFilter = userType
            }
        }
    }

}
