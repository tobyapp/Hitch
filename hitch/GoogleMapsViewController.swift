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
import Parse

class GoogleMapsViewController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate, SendDataBackProtocol  {

    @IBOutlet weak var mapView: GMSMapView!

    @IBAction func searchButton(sender: AnyObject) {
        presentSearchBar()
    }
    
    var userRoutes = RetrieveDataFromBackEnd()
    var account = UploadDataToBackEnd()
    var locationMarker: GMSMarker!
    let locationManager = CLLocationManager()
    var plottedByUser = false
    var delegate : SendDataBackProtocol?
    var userID : String?
    var destinationLatitude : Double?
    var destinationLongitude : Double?
    var originLatitude : Double?
    var originLongitude : Double?
    let keys = APIkeys()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Hitch Map View"
        self.title = "Hitch'n Map!"
        self.mapView.delegate = self
        
        // To make the compas button viewable
        if let navBarHeight = self.navigationController?.navigationBar.frame.height
        {
            let compasButtonHeight = UIApplication.sharedApplication().statusBarFrame.size.height
            mapView.padding = UIEdgeInsetsMake(navBarHeight+compasButtonHeight,0,0,0);
        }
        
//        let camera: GMSCameraPosition = GMSCameraPosition.cameraWithLatitude(48.857165, longitude: 2.354613, zoom: 8.0)
//        mapView.camera = camera
        
        mapView.settings.compassButton = true
        mapView.settings.myLocationButton = true
        
        // Draws routes on map from back end database (Parse)
        userRoutes.retrieveRoutes({results in
            for object in results! {
                let userType = ("\(object.objectForKey("UserType")!)")
                let route = ("\(object.objectForKey("UserRoute")!)")
                let userName = ("\(object.objectForKey("UserName")!)")
                let userID = ("\(object.objectForKey("UserID")!)")
                let destinationLatitude = Double("\(object.objectForKey("DestinationLatitude")!)")
                let destinationLongitude = Double("\(object.objectForKey("DestinationLongitude")!)")
                let timeOfRoute = ("\(object.objectForKey("TimeOfRoute")!)")
                
                let location = CLLocationCoordinate2D(latitude: destinationLatitude!, longitude: destinationLongitude!)
                
                self.drawRoute(route, userType: userType)
                self.plottedByUser = false
                self.placeMarker(location, userName: userName, userType: userType, userID: userID, timeOfRoute: timeOfRoute)
            }
        })
 
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
                showAlertController("Location services not enabled!", errorMessage: "Please enbale locaiotn services to Hitch!", showSettings: true)
            }
        }
        else {
            showAlertController("Allow Hitch to access your location!", errorMessage: "Please enbale location services to Hitch!", showSettings: true)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        let gpaViewController = GooglePlacesAutocomplete (
            apiKey: keys.googlePlacesAPIKey,
            placeType: .Address
        )
        gpaViewController.placeDelegate = self
    }
    
    //presents search bar for user to search, sets UI for search bar view
    func presentSearchBar(){
        let gpaViewController = GooglePlacesAutocomplete (
            apiKey: keys.googlePlacesAPIKey,
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
            originLatitude = locValue.latitude
            originLongitude = locValue.longitude
        }
        
        if let location = locations.first {
            mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
            locationManager.stopUpdatingLocation()
        }
    }
    
    // Function to display an Alert Controller
    func showAlertController(errorTitle: String, errorMessage: String, showSettings: Bool) {
        
        let alertController = UIAlertController(
            title: errorTitle,
            message: errorMessage,
            preferredStyle: .Alert)
        let cancelAction = UIAlertAction(
            title: "ok",
            style: UIAlertActionStyle.Destructive,
            handler: nil)
        alertController.addAction(cancelAction)
        
        if showSettings {
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
        }
        dispatch_async(dispatch_get_main_queue(), {
            self.presentViewController(alertController, animated: true, completion: nil)
        })

    }

}

// Extention of current class to incorportate wrapper for googlePlacesApi + other functionality
extension GoogleMapsViewController: GooglePlacesAutocompleteDelegate, UIPopoverPresentationControllerDelegate {
    
    // Allows user to search in search box from googlePlacesApi, when place is selected marker is placed
    func placeSelected(place: Place) {
        var latitude: Double = 0.0
        var longitude: Double = 0.0
        place.getDetails { details in
            latitude = details.latitude
            longitude = details.longitude
            self.destinationLongitude = details.longitude
            self.destinationLatitude = details.latitude
            let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            self.mapView.camera = GMSCameraPosition(target: location, zoom: 15, bearing: 0, viewingAngle: 0)
            self.placeViewClosed()
            self.plottedByUser = true
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
        plottedByUser = true
    }
    
    // Places marker on map when address is selected from searching, called from placeSelected()
    func placeMarker(coordinate: CLLocationCoordinate2D, var userName: String, userType: String, userID: String, timeOfRoute: String) {
        
        let currentUser = PFUser.currentUser()?.valueForKey("userName")
        
        if userName == currentUser! as! String {
            userName = "You"
        }
        
        locationMarker = GMSMarker(position: coordinate)
        switch userType {
        case "driver":
            locationMarker.icon = GMSMarker.markerImageWithColor(UIColor.greenColor())
            locationMarker.title = "Driver : \(userName)"
            locationMarker.snippet = "\(timeOfRoute)"
            locationMarker.userData = userID
        case "hitcher":
            locationMarker.icon = GMSMarker.markerImageWithColor(purple)
            locationMarker.title = "Hitcher : \(userName)"
            locationMarker.snippet = "\(timeOfRoute)"
            locationMarker.userData = userID
        default:
            locationMarker.icon = GMSMarker.markerImageWithColor(UIColor.blueColor())
            locationMarker.title = "Driver/Hitcher : unkown"
        }
        locationMarker.map = mapView
    }
    
    func placeViewClosed() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // Presents custom window info box above marker
    func mapView(mapView: GMSMapView!, markerInfoWindow marker: GMSMarker!) -> UIView! {

        let infoWindow: CustomInfoWindow = NSBundle.mainBundle().loadNibNamed("CustomInfoWindow", owner: self, options: nil).first! as! CustomInfoWindow
        infoWindow.frame.size.width = 200
        infoWindow.frame.size.height = 75
        infoWindow.layer.cornerRadius = 10
        infoWindow.backgroundColor = purple
        
        if plottedByUser {
            let drivingToButton: RaisedButton = RaisedButton(frame: CGRectMake(0, 0, 200, 75))
            drivingToButton.setTitle("Drive or Hitch here..", forState: .Normal)
            drivingToButton.setTitleColor(MaterialColor.white, forState: .Normal)
            drivingToButton.titleLabel!.font = UIFont(name: "System", size: 7)
            drivingToButton.backgroundColor = MaterialColor.deepPurple.base
            infoWindow.addSubview(drivingToButton)
        }
            
        else if !plottedByUser {
            let userLabel = UILabel(frame: CGRectMake(0, 0, 200, 50))
            userLabel.textAlignment = .Center
            userLabel.text = marker.title
            userLabel.textColor = UIColor.whiteColor()
            userLabel.layer.cornerRadius = 10
            infoWindow.addSubview(userLabel)
            
            let timeLabel = UILabel(frame: CGRectMake(0, 25, 200, 50))
            timeLabel.textAlignment = .Center
            timeLabel.text = "At : \(marker.snippet)"
            timeLabel.textColor = UIColor.whiteColor()
            timeLabel.layer.cornerRadius = 10
            infoWindow.addSubview(timeLabel)
         
        }
        return infoWindow
    }
    
    // executes when user taps custom window info above marker, presents PopooverViewController
    func mapView(mapView: GMSMapView!, didTapInfoWindowOfMarker marker: GMSMarker!) {

        if plottedByUser {
            performSegueWithIdentifier("segueToHitchOrDriveOption", sender: nil)
            marker.map = nil
        }
            
        else if !plottedByUser {
            userID = "\(marker.userData)"
            performSegueWithIdentifier("segueToUsersProfile", sender: nil)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "segueToUsersProfile") {
            if let destinationViewController = segue.destinationViewController as? HitcherDriverTableViewController {
                destinationViewController.userData = userID
            }
        }
        
        if (segue.identifier == "segueToHitchOrDriveOption") {
            if let destinationViewController = segue.destinationViewController as? PopoverViewController {
                destinationViewController.destinationLatitude = destinationLatitude
                destinationViewController.destinationLongitude = destinationLongitude
                destinationViewController.originLatitude = originLatitude
                destinationViewController.originLongitude = originLongitude
                let vc = segue.destinationViewController as! PopoverViewController
                vc.delegate = self
            }
        }
    }
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return .Popover
    }
    
    // Recieves route back from the the PopoverVC (and from RouteCalculator.swift)
    func sendRouteBack(route: String, userType: String, destinationLatitude: Double, destinationLongitude: Double, timeOfRoute: String) {
        if route == "No directions found" {
            showAlertController("No route found", errorMessage: "No route found, please try another location", showSettings: false)
            return
        } else {
            account.addLocationData(route, userType: userType, destinationLatitude: destinationLatitude, destinationLongitude: destinationLongitude, timeOfRoute: timeOfRoute)
            drawRoute(route, userType: userType)
        }
    }
    
    // Draws route on map (colour changes depending on user type)
    func drawRoute(route: String, userType: String) {
        //mapView.clear()
        let path: GMSPath = GMSPath(fromEncodedPath: route)
        let routePolyline = GMSPolyline(path: path)
        routePolyline.strokeWidth = 5.0
        switch userType {
            case "driver":
                let driverLine = GMSStrokeStyle.solidColor(UIColor.greenColor())
                routePolyline.spans = [GMSStyleSpan(style: driverLine)]
        case "hitcher":
            let hitcherLine = GMSStrokeStyle.solidColor(purple)
            routePolyline.spans = [GMSStyleSpan(style: hitcherLine)]
            
        default:
            let standardline = GMSStrokeStyle.solidColor(UIColor.blueColor())
            routePolyline.spans = [GMSStyleSpan(style: standardline)]
        }
        routePolyline.map = mapView
    }
}
