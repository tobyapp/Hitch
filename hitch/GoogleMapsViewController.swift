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
import MK

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
        self.mapView.delegate = self
        
        let camera: GMSCameraPosition = GMSCameraPosition.cameraWithLatitude(48.857165, longitude: 2.354613, zoom: 8.0)
        mapView.camera = camera
        
        mapView.settings.compassButton = true
        
        // handles location auth globally and locally (locally as in for app, globally as in for whole phone through locaiotnservicesenabled())
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
    
    //presents search bar for user to search, sets UI for search bar view
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
    
    // handles when auth for locaiton is changed (see docs)
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
    
    // places view on users location
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let locValue:CLLocationCoordinate2D = manager.location!.coordinate {
            NSUserDefaults.standardUserDefaults().setObject(locValue.longitude, forKey: "originLongitude")
            NSUserDefaults.standardUserDefaults().setObject(locValue.latitude, forKey: "originLatitude")
        }
        
        if let location = locations.first {
            mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
            locationManager.stopUpdatingLocation()
        }
    }
    
    // Function to display an Alert Controller
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

// Extention of current class to incorportate wrapper for googlePlacesApi
extension GoogleMapsViewController: GooglePlacesAutocompleteDelegate, UIPopoverPresentationControllerDelegate, SendDataBackProtocol {

    // Allows user to search in search box from googlePlacesApi, when place is selected marker is placed
    func placeSelected(place: Place) {
        var latitude: Double = 0.0
        var longitude: Double = 0.0
        place.getDetails { details in
            latitude = details.latitude
            longitude = details.longitude
            NSUserDefaults.standardUserDefaults().setObject(longitude, forKey: "destinationLongitude")
            NSUserDefaults.standardUserDefaults().setObject(latitude, forKey: "destinationLatitude")
            let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            self.mapView.camera = GMSCameraPosition(target: location, zoom: 15, bearing: 0, viewingAngle: 0)
            self.placeViewClosed()
            self.placeMarker(location)
        }
    }
    
    // Places marker on map when address is selected from searching, called from placeSelected()
    func placeMarker(coordinate: CLLocationCoordinate2D) {
        if locationMarker != nil {
            locationMarker.map = nil
        }
        locationMarker = GMSMarker(position: coordinate)
        locationMarker.icon = GMSMarker.markerImageWithColor(purple)
        //locationMarker.appearAnimation = kGMSMarkerAnimationPop
        locationMarker.map = mapView
    }
    
    // excecutes when user taps on marker
//    func mapView(mapView: GMSMapView!, didTapMarker marker: GMSMarker!) -> Bool {
////        let myFirstButton = UIButton()
////        myFirstButton.setTitle("✸", forState: .Normal)
////        myFirstButton.setTitleColor(UIColor.blueColor(), forState: .Normal)
////        myFirstButton.frame = CGRectMake(15, -50, 300, 500)
////        myFirstButton.addTarget(self, action: "pressed:", forControlEvents: .TouchUpInside)
////        
////        self.view.addSubview(myFirstButton)
//        print("hello")
//        return true
//    }
    
    func placeViewClosed() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // Presents custom window info box above marker
    func mapView(mapView: GMSMapView!, markerInfoWindow marker: GMSMarker!) -> UIView! {
        let infoWindow: CustomInfoWindow = NSBundle.mainBundle().loadNibNamed("CustomInfoWindow", owner: self, options: nil).first! as! CustomInfoWindow
        infoWindow.frame.size.width = 200
        infoWindow.frame.size.height = 50
        
        let drivingToButton: RaisedButton = RaisedButton(frame: CGRectMake(0, 0, 200, 50))
        drivingToButton.setTitle("Drive or Hitch here..", forState: .Normal)
        drivingToButton.setTitleColor(MaterialColor.white, forState: .Normal)
        drivingToButton.titleLabel!.font = UIFont(name: "System", size: 7)
        drivingToButton.backgroundColor = MaterialColor.deepPurple.base
        infoWindow.addSubview(drivingToButton)

        return infoWindow
    }
    
    // executes when user taps custom window info above marker, presents PopooverViewController
    func mapView(mapView: GMSMapView!, didTapInfoWindowOfMarker marker: GMSMarker!) {

        
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let popoverContent : PopoverViewController = storyboard.instantiateViewControllerWithIdentifier("Popover") as! PopoverViewController
        let nav = UINavigationController(rootViewController: popoverContent)
        nav.modalPresentationStyle = UIModalPresentationStyle.Popover
        let popover = nav.popoverPresentationController
        popoverContent.preferredContentSize = CGSizeMake(250,300)
        popover!.delegate = self
        popover!.sourceView = self.view
        popover!.sourceRect = CGRectMake(100,100,0,0)
        //popover!.delegate = self
        popoverContent.delegate = self
        self.presentViewController(nav, animated: true, completion: nil)
    }
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return .Popover
    }
    
    func sendRouteBack(value: String, userType: String) {
        //print(value)
        //do something with userType
        //print(userType)
    }
    
    func drawRoute(route: String, UserType: String) {
        //let path = GMSMutablePath()
        
        let path: GMSPath = GMSPath(fromEncodedPath: route)
        let routePolyline = GMSPolyline(path: path)
        routePolyline.map = mapView
    }

}
