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
    var routeId : String?
    var destinationLatitude : Double?
    var destinationLongitude : Double?
    var originLatitude : Double?
    var originLongitude : Double?
    let keys = APIkeys()
    var routePath : GMSPolyline?
    var calledFromAlertController = false
    var tappedByUser = true

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
        
        mapView.settings.compassButton = true
        mapView.settings.myLocationButton = true
        
        // Draws routes on map from back end database (Parse)
       getRoutesAndDisplayThem()
        
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
                showAlertController("Location services not enabled!", errorMessage: "Please enbale location services to Hitch!", showSettings: true, showProfile: false)
            }
        }
        else {
            showAlertController("Allow Hitch to access your location!", errorMessage: "Please enbale location services to Hitch!", showSettings: true, showProfile: false)
        }
        
        let refreshButton = UIBarButtonItem(barButtonSystemItem: .Refresh, target: self, action: "refreshMap")
        navigationItem.rightBarButtonItem = refreshButton

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
    
    // Clears the map of all routes and retrievs the latest oens
    func refreshMap(){
        mapView.clear()
        getRoutesAndDisplayThem()
    }
    
    func getRoutesAndDisplayThem() {
        // Draws routes on map from back end database (Parse)
        userRoutes.retrieveRoutes({results in
            
            let userType = ("\(results["UserType"]!)")
            let route = ("\(results["UserRoute"]!)")
            let userName = ("\(results["UserName"]!)")
            let userID = ("\(results["UserID"]!)")
            let destinationLatitude = Double("\(results["DestinationLatitude"]!)")
            let destinationLongitude = Double("\(results["DestinationLongitude"]!)")
            let timeOfRoute = ("\(results["TimeOfRoute"]!)")
            let routeId = ("\(results["RoutId"]!)")
            let extraRideInfo = ("\(results["ExtraRideInfo"]!)")
            
            let location = CLLocationCoordinate2D(latitude: destinationLatitude!, longitude: destinationLongitude!)
            
            self.drawRoute(route, userType: userType)
            self.plottedByUser = false
            self.placeMarker(location, userName: userName, userType: userType, userID: userID, timeOfRoute: timeOfRoute, routeId: routeId, extraRideInfo: extraRideInfo, routePath: route)
        })
    }
    
    // Function to display an Alert Controller
    func showAlertController(errorTitle: String, errorMessage: String, showSettings: Bool, showProfile: Bool) {
        
        let alertController = UIAlertController(
            title: errorTitle,
            message: errorMessage,
            preferredStyle: .Alert)
        let cancelAction = UIAlertAction(
            title: "Ok",
            style: UIAlertActionStyle.Destructive,
            handler: nil)
        alertController.addAction(cancelAction)
        
        if showSettings {
            // Opens the phones settings application
            let openAction = UIAlertAction(
                title: "Open Settings",
                style: .Default)
                { action in
                    if let url = NSURL(string:UIApplicationOpenSettingsURLString) {
                        UIApplication.sharedApplication().openURL(url)
                    }
                }
            alertController.addAction(openAction)
        }
        
        if showProfile {
            // Displays an action to user profile defined by userID 
            let profielAction = UIAlertAction(
                title:"Show Profile",
                style: .Default,
                handler: { action in
                    self.performSegueWithIdentifier("segueToUsersProfile", sender: self)
                }
            )
            alertController.addAction(profielAction)
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
        place.getDetails { details in
            self.destinationLongitude = details.longitude
            self.destinationLatitude = details.latitude
            let location = CLLocationCoordinate2D(latitude: details.latitude, longitude: details.longitude)
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
        if let routePath = routePath {
            // removes previously plotted line from the map
            routePath.map = nil
        }
        locationMarker = GMSMarker(position: coordinate)
        locationMarker.icon = GMSMarker.markerImageWithColor(purple)
        locationMarker.map = mapView
        locationMarker.userData = ["longitude" : coordinate.longitude, "latitude" : coordinate.latitude]
        plottedByUser = true
    }
    
    // Places marker on map when address is selected from searching, called from placeSelected()
    func placeMarker(coordinate: CLLocationCoordinate2D, var userName: String, userType: String, userID: String, timeOfRoute: String, routeId : String, extraRideInfo: String, routePath: String) {
        
        let currentUser = PFUser.currentUser()?.valueForKey("objectId")
        
        if userID == currentUser! as! String {
            userName = "You"
        }
        
        locationMarker = GMSMarker(position: coordinate)
        switch userType {
        case "driver":
            locationMarker.icon = GMSMarker.markerImageWithColor(UIColor.greenColor())
            locationMarker.title = "Driver : \(userName)"
            locationMarker.snippet = "\(timeOfRoute)"
            locationMarker.userData = ["userID" : userID, "routeId" : routeId, "extraRideInfo" : extraRideInfo, "routePath" : routePath ]
        case "hitcher":
            locationMarker.icon = GMSMarker.markerImageWithColor(purple)
            locationMarker.title = "Hitcher : \(userName)"
            locationMarker.snippet = "\(timeOfRoute)"
            locationMarker.userData = ["userID" : userID, "routeId" : routeId, "extraRideInfo" : extraRideInfo, "routePath" : routePath ]
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
        infoWindow.backgroundColor = purple
        infoWindow.layer.cornerRadius = 10
        if marker.snippet == nil{
            //info window dimensions, change depending if there is extra info from user on lift
            infoWindow.frame.size.width = 200
            infoWindow.frame.size.height = 75
            
            let drivingToButton: RaisedButton = RaisedButton(frame: CGRectMake(0, 0, 200, 75))
            drivingToButton.setTitle("Drive or Hitch here..", forState: .Normal)
            drivingToButton.setTitleColor(MaterialColor.white, forState: .Normal)
            drivingToButton.titleLabel!.font = UIFont(name: "System", size: 7)
            drivingToButton.layer.cornerRadius = 10
            drivingToButton.backgroundColor = MaterialColor.deepPurple.base
            infoWindow.addSubview(drivingToButton)
        }
        else {
            if locationMarker != nil {
                locationMarker.map = nil
            }
            
            if "\(marker.userData["extraRideInfo"])" != "" {
                
                //info window dimensions, demsions increase if there are extra info
                infoWindow.frame.size.width = 300
                infoWindow.frame.size.height = 150
                
                let extraInfoLabel = UILabel(frame: CGRectMake(0, 50, infoWindow.frame.size.width , 100))
                extraInfoLabel.numberOfLines = 0
                extraInfoLabel.textAlignment = .Center
                extraInfoLabel.text = "Extra info : \(marker.userData["extraRideInfo"])"
                extraInfoLabel.textColor = UIColor.whiteColor()
                extraInfoLabel.layer.cornerRadius = 10
                infoWindow.addSubview(extraInfoLabel)
            }
            
            else {
                //info window dimensions
                infoWindow.frame.size.width = 200
                infoWindow.frame.size.height = 75
            }
            
            let userLabel = UILabel(frame: CGRectMake(0, 0, infoWindow.frame.size.width , 50))
            userLabel.textAlignment = .Center
            userLabel.text = marker.title
            userLabel.textColor = UIColor.whiteColor()
            userLabel.layer.cornerRadius = 10
            infoWindow.addSubview(userLabel)
            
            let timeLabel = UILabel(frame: CGRectMake(0, 25, infoWindow.frame.size.width , 50))
            timeLabel.textAlignment = .Center
            timeLabel.text = "At : \(marker.snippet)"
            timeLabel.textColor = UIColor.whiteColor()
            timeLabel.layer.cornerRadius = 10
            infoWindow.addSubview(timeLabel)
            
            // Clears the last plotted route from global var
            if let routePath = routePath {
                // removes previously plotted line form the map
                routePath.map = nil
            }
            
            //draws red route over selected route so user can see it
            self.drawRoute("\(marker.userData["routePath"])", userType: "selected")
            plottedByUser = false
        }
        return infoWindow
    }
    
    // When user taps the map (not the info marker or anything)
    func mapView(mapView: GMSMapView!, didTapAtCoordinate coordinate: CLLocationCoordinate2D) {
        
        plottedByUser = false
        
        // removes previously plotted line from the map
        if let routePath = routePath {
            routePath.map = nil
            if locationMarker != nil {
                locationMarker.map = nil
            }
        }
        
        // Allows user to tap area on map to plot route there, also allows user to tap map to deselect route they previously plotted or pinned
        if tappedByUser {
            
            //Deletes marker placed on map by user
            if locationMarker != nil {
                locationMarker.map = nil
            }
            
            let currentZoom = self.mapView.camera.zoom
            destinationLongitude = coordinate.longitude
            destinationLatitude = coordinate.latitude
            mapView.camera = GMSCameraPosition(target: coordinate, zoom: currentZoom, bearing: 0, viewingAngle: 0)
            plottedByUser = true
            placeMarker(coordinate)
            tappedByUser = false
        }
        else {
            if locationMarker != nil {
                locationMarker.map = nil
            }
            plottedByUser = false
            tappedByUser = true
        }
    }
    
    // executes when user taps custom window info above marker, presents PopooverViewController
    func mapView(mapView: GMSMapView!, didTapInfoWindowOfMarker marker: GMSMarker!) {

        if plottedByUser {
            performSegueWithIdentifier("segueToHitchOrDriveOption", sender: nil)
            marker.map = nil
        }
            
        else if !plottedByUser {
            if calledFromAlertController {
                calledFromAlertController = false
                performSegueWithIdentifier("segueToUsersProfile", sender: nil)
            }
                
            else if !calledFromAlertController{
                userID = "\(marker.userData["userID"])"
                routeId = "\(marker.userData["routeId"])"
                performSegueWithIdentifier("segueToUsersProfile", sender: nil)
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "segueToUsersProfile") {
            if let destinationViewController = segue.destinationViewController as? HitcherDriverTableViewController {
                destinationViewController.userData = userID!
                if let routeId = routeId {
                    destinationViewController.routeId = routeId
                }
            }
        }
        
        if (segue.identifier == "segueToHitchOrDriveOption") {
            if let destinationViewController = segue.destinationViewController as? HtichOrDrivePopupViewController {
                destinationViewController.destinationLatitude = destinationLatitude
                destinationViewController.destinationLongitude = destinationLongitude
                destinationViewController.originLatitude = originLatitude
                destinationViewController.originLongitude = originLongitude
                let vc = segue.destinationViewController as! HtichOrDrivePopupViewController
                vc.delegate = self
            }
        }
    }
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return .Popover
    }
    
    // Recieves route back from the the PopoverVC (and from RouteCalculator.swift)
    func sendRouteBack(route: String, userType: String, originLatitude: Double, originLongitude: Double, destinationLatitude: Double, destinationLongitude: Double, timeOfRoute: String, extraRideInfo: String) {
        if route == "No directions found" {
            showAlertController("No route found", errorMessage: "No route found, please try another location", showSettings: false, showProfile: false)
            return
        } else {
            routeProximity(originLatitude, usersOriginLongitude: originLongitude, usersDestLatitude: destinationLatitude, usersDestLongitude: destinationLongitude)

            //delayed as other wise the route would get saved to the backend before it can be searched for users going same area, this means that the back end search would show a user is travling to the same location (but would really just be the orignal user as thier route is being searched against thier own route), increae number as records get bigger.
            runCodeAfterDelay(2) {
                self.account.addLocationData(route, userType: userType, originLatitude: originLatitude, originLongitude: originLongitude, destinationLatitude: destinationLatitude, destinationLongitude: destinationLongitude, timeOfRoute: timeOfRoute, extraRideInfo: extraRideInfo)
            }
            
            drawRoute(route, userType: userType)
            plottedByUser = false
        }
    }
    
    // Calculate route proximity then present alert to show user that another user is trvaling to this location
    func routeProximity(usersOriginLatitude : Double, usersOriginLongitude : Double, usersDestLatitude : Double, usersDestLongitude : Double) {
        
        // co-ord params to pass to back end function "routeProximity" (see parse cloud code)
        let params = ["usersOriginLatitude" : usersOriginLatitude,  "usersOriginLongitude" : usersOriginLongitude, "usersDestLatitude" : usersDestLatitude,  "usersDestLongitude" : usersDestLongitude]
        PFCloud.callFunctionInBackground("routeProximity", withParameters: params) { ( response, error) -> Void in

            if response != nil {
                if error == nil {
                    if let userObject = response as! PFObject? {
                        
                        let currentUser = PFUser.currentUser()?.valueForKey("objectId")
                        let userName = userObject["userName"]
                        self.calledFromAlertController = true
                        self.userID = ("\(userObject.valueForKey("objectId")!)")
                        
                        if "\(currentUser!)" == self.userID! {
                            self.showAlertController("Your already going there!", errorMessage: "Your already going to a location in this vicinity!", showSettings: false, showProfile: false)
                        }
                        else if "\(currentUser!)" != self.userID! {
                             self.showAlertController("Somebody is already going that way, why not drop them a message?", errorMessage: "The user \(userName) is already going there!", showSettings: false, showProfile: true)
                        }
                    }
                }
                else {
                    print(error)
                }
            }
        }
    }
    
    // Draws route on map (colour changes depending on user type)
    func drawRoute(route: String, userType: String) {
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
            case "selected":
                let selectedLine = GMSStrokeStyle.solidColor(UIColor.redColor())
                routePolyline.spans = [GMSStyleSpan(style: selectedLine)]
                routePath = routePolyline
            default:
                let standardline = GMSStrokeStyle.solidColor(UIColor.blueColor())
                routePolyline.spans = [GMSStyleSpan(style: standardline)]
        }
        routePolyline.map = mapView
    }

    
    
}
