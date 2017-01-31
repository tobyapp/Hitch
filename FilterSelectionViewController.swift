//
//  FilterSelectionViewController.swift
//  
//
//  Created by Toby Applegate on 17/01/2016.
//
//

import UIKit
import GoogleMaps
import CoreLocation
import MK

// Shown after user selects either 'show driving routes' or 'show hitch'n routes'
class FilterSelectionViewController: UIViewController, GMSMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: GMSMapView!
    
    var userRoutes = RetrieveDataFromBackEnd()
    var locationMarker: GMSMarker!
    var userTypeFilter: String?
    var userID : String?
    let locationManager = CLLocationManager()
    var routeId : String?
    var routePath : GMSPolyline?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.mapView.delegate = self
        self.navigationItem.title = "Filter Map View"
        self.title = "\(userTypeFilter!) Map!"
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest

        // To make the compas button viewable
        if let navBarHeight = self.navigationController?.navigationBar.frame.height
        {
            let compasButtonHeight = UIApplication.sharedApplication().statusBarFrame.size.height
            mapView.padding = UIEdgeInsetsMake(navBarHeight+compasButtonHeight,0,0,0);
        }
        
        mapView.settings.compassButton = true
        mapView.settings.myLocationButton = true
        
        getRoutesAndDisplayThem()
        
        let refreshButton = UIBarButtonItem(barButtonSystemItem: .Refresh, target: self, action: #selector(FilterSelectionViewController.refreshMap))
        navigationItem.rightBarButtonItem = refreshButton

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        if let location = locations.first {
            mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
            locationManager.stopUpdatingLocation()
        }
    }

    // Draws route on map (colour changes depending on user type)
    func drawRoute(route: String, userType: String) {
        print("in draw route \(userType)")
//        print("user type : \(userType)")
//        print("userTypeFilter : \(userTypeFilter)")
        if userType == userTypeFilter || userType == "selected" {
            let path: GMSPath = GMSPath(fromEncodedPath: route)!
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

 //Places marker on map when address is selected from searching, called from placeSelected()
    func placeMarker(coordinate: CLLocationCoordinate2D, var userName: String, userType: String, userID: String, timeOfRoute: String, routeId : String, extraRideInfo: String, routePath: String) {
        
        if userTypeFilter == userType {
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
                    locationMarker.userData = ["userID": userID, "routeId" : routeId, "extraRideInfo" : extraRideInfo, "routePath" : routePath ]
                case "hitcher":
                    locationMarker.icon = GMSMarker.markerImageWithColor(purple)
                    locationMarker.title = "Hitcher : \(userName)"
                    locationMarker.snippet = "\(timeOfRoute)"
                    locationMarker.userData = ["userID": userID, "routeId" : routeId, "extraRideInfo" : extraRideInfo, "routePath" : routePath ]
                default:
                    locationMarker.icon = GMSMarker.markerImageWithColor(UIColor.blueColor())
                    locationMarker.title = "Driver/Hitcher : unkown"
            }
            locationMarker.map = mapView
        }
    }
    // Presents custom window info box above marker
    func mapView(mapView: GMSMapView!, markerInfoWindow marker: GMSMarker!) -> UIView! {
        
        let infoWindow: CustomInfoWindow = NSBundle.mainBundle().loadNibNamed("CustomInfoWindow", owner: self, options: nil).first! as! CustomInfoWindow
        infoWindow.backgroundColor = purple
        infoWindow.layer.cornerRadius = 10
        let routeData = marker.userData as! [String: AnyObject] //marker.userData["routePath"] as! String
        
        if "\(routeData["extraRideInfo"])" != "" {
            
            //info window dimensions, demsions increase if there are extra info
            infoWindow.frame.size.width = 300
            infoWindow.frame.size.height = 150
                
            let extraInfoLabel = UILabel(frame: CGRectMake(0, 50, infoWindow.frame.size.width , 100))
            extraInfoLabel.numberOfLines = 0
            extraInfoLabel.textAlignment = .Center
            extraInfoLabel.text = "Extra info : \(routeData["extraRideInfo"])"
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
        print("draw")
        
        let routePathData = marker.userData as! [String: AnyObject] //marker.userData["routePath"] as! String

        self.drawRoute("\(routePathData["routePath"])", userType: "selected")
        
        return infoWindow
        
    }

    // When user taps the map (not the info marker or anything)
    func mapView(mapView: GMSMapView!, didTapAtCoordinate coordinate: CLLocationCoordinate2D) {
        if let routePath = routePath {
            // removes previously plotted line from the map
            routePath.map = nil
        }
    }

    // executes when user taps custom window info above marker, presents PopooverViewController
    func mapView(mapView: GMSMapView!, didTapInfoWindowOfMarker marker: GMSMarker!) {
        let routeData = marker.userData as! [String: AnyObject] //marker.userData["routePath"] as! String
        userID = "\(routeData["userID"])"
        routeId = "\(routeData["routeId"])"
        performSegueWithIdentifier("segueToUsersProfile", sender: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if let destinationViewController = segue.destinationViewController as? HitcherDriverTableViewController {
            destinationViewController.userData = userID!
            if let routeId = routeId {
                destinationViewController.routeId = routeId
            }
        }
    }
    
    // Clears the map of all routes and retrievs the latest oens
    func refreshMap(){
        mapView.clear()
        getRoutesAndDisplayThem()
    }
    
    func getRoutesAndDisplayThem(){
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
            self.placeMarker(location, userName: userName, userType: userType, userID: userID, timeOfRoute: timeOfRoute, routeId: routeId, extraRideInfo: extraRideInfo, routePath: route)
        })

    }
    
}


