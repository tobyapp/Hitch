//
//  GoogleMapsViewController.swift
//  hitch
//
//  Created by Toby Applegate on 06/01/2016.
//  Copyright © 2016 Toby Applegate. All rights reserved.
//

import UIKit
import CoreLocation
import GoogleMaps

class GoogleMapsViewController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate {

    @IBOutlet weak var mapView: GMSMapView!

    @IBAction func searchButton(sender: AnyObject) {
        presentSearchBar()
    }
    
    var locationMarker: GMSMarker!
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Hitch Map View"
        self.title = "Hitch'n Map!"
        
        let camera: GMSCameraPosition = GMSCameraPosition.cameraWithLatitude(48.857165, longitude: 2.354613, zoom: 8.0)
        mapView.camera = camera
        
        mapView.settings.compassButton = true
        
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .AuthorizedAlways, .AuthorizedWhenInUse:
                locationManager.delegate = self
                locationManager.desiredAccuracy = kCLLocationAccuracyBest
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
        
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        let gpaViewController = GooglePlacesAutocomplete (
            apiKey: "AIzaSyBZM-uX4YyOaMd5Fpas8EPBG-zq_T2kRq8",
            placeType: .Address
        )
        
        gpaViewController.placeDelegate = self
        
        //presentViewController(gpaViewController, animated: true, completion: nil)
    }
    
    func presentSearchBar(){
        let gpaViewController = GooglePlacesAutocomplete (
            apiKey: "AIzaSyBZM-uX4YyOaMd5Fpas8EPBG-zq_T2kRq8",
            placeType: .Address
        )
        
        gpaViewController.navigationBar.tintColor = UIColor.whiteColor()
        gpaViewController.navigationBar.barTintColor = purple
        gpaViewController.navigationBar.barStyle = UIBarStyle.Black
        gpaViewController.placeDelegate = self
        
        presentViewController(gpaViewController, animated: true, completion: nil)
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .Denied {
            manager.stopUpdatingLocation()
            mapView.myLocationEnabled = false
        }
        
        else if status == .AuthorizedAlways || status == .AuthorizedWhenInUse {
            manager.startUpdatingLocation()
            mapView.myLocationEnabled = true
            mapView.settings.myLocationButton = true
        }
    }
    
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
            locationManager.stopUpdatingLocation()
        }
    }
    
    
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
        dispatch_async(dispatch_get_main_queue(), { 
        self.presentViewController(alertController, animated: true, completion: nil)
        })
        }

}

extension GoogleMapsViewController: GooglePlacesAutocompleteDelegate {
    func placeSelected(place: Place) {
        var latitude: Double = 0.0
        var longitude: Double = 0.0
        print("places: \(place.description)")
        place.getDetails { details in
            print(details.latitude)
            latitude = details.latitude
            longitude = details.longitude
            let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            self.mapView.camera = GMSCameraPosition(target: location, zoom: 15, bearing: 0, viewingAngle: 0)
            self.placeViewClosed()
            self.placeMarker(location)
        }
       
    }
    
    func placeMarker(coordinate: CLLocationCoordinate2D) {
        if locationMarker != nil {
            locationMarker.map = nil
        }
        locationMarker = GMSMarker(position: coordinate)
        
        locationMarker.icon = GMSMarker.markerImageWithColor(purple)
        //locationMarker.appearAnimation = kGMSMarkerAnimationPop
        locationMarker.snippet = "The best place on earth."
        locationMarker.map = mapView
    }
    
    func placeViewClosed() {
        dismissViewControllerAnimated(true, completion: nil)
    }
}
