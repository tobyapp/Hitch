//
//  MapKitViewController.swift
//  hitch
//
//  Created by Toby Applegate on 03/01/2016.
//  Copyright © 2016 Toby Applegate. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapKitViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!

    @IBAction func currentLocation(sender: AnyObject) {
        let location = self.locationManager.location
        if let locationValue = location?.coordinate {
            let region = MKCoordinateRegion(center: locationValue, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            self.mapView.setRegion(region, animated: true)
        }
        else {
            showAlertController("No location data just yet!", errorMessage: "Give Hitch a minute and we'll find your location!")
        }
    }
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Hitch Map View"
        self.title = "Hitch'n Map!"
        
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .AuthorizedAlways, .AuthorizedWhenInUse:
                locationManager.delegate = self
                locationManager.desiredAccuracy = kCLLocationAccuracyBest
                locationManager.startUpdatingLocation()
            case .NotDetermined:
                locationManager.requestAlwaysAuthorization()
                locationManager.requestWhenInUseAuthorization()
            case .Restricted, .Denied:
                showAlertController("Location services not enabled!", errorMessage: "Please enbale locaiotn services to Hitch!")
            }
        }
        else {
            showAlertController("Allow Hitch to access your location!", errorMessage: "Please enbale location services to Hitch!")
        }
        
        mapView.delegate = self
        mapView.showsUserLocation = true

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedAlways || status == .AuthorizedWhenInUse {
            manager.startUpdatingLocation()
            mapView.showsUserLocation = true
        }
    }
    
    // constantly update locaiton (follow blue dot while it drives round)
//    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        let locationValue = manager.location!.coordinate
//        let region = MKCoordinateRegion(center: locationValue, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
//        self.mapView.setRegion(region, animated: true)
//    }
    
    // Function to display an Alert Controller (for test purposes)
    func showAlertController(errorTitle: String, errorMessage: String) {
        let alertController = UIAlertController(
            title: errorTitle,
            message: errorMessage,
            preferredStyle: .Alert)
        let cancelAction = UIAlertAction(
            title: "ok",
            style: UIAlertActionStyle.Destructive,
            handler: nil)
        alertController.addAction(cancelAction)
        
        // Opens the phones settings application
        let openAction = UIAlertAction(
            title: "Open Settings",
            style: .Default)
            { (action) in
                if let url = NSURL(string:UIApplicationOpenSettingsURLString) {
                    UIApplication.sharedApplication().openURL(url)
                }
        }
        alertController.addAction(openAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
