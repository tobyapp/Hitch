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

class FilterSelectionViewController: UIViewController, GMSMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: GMSMapView!
    
    var userRoutes = RetrieveDataFromBackEnd()
    var locationMarker: GMSMarker!
    var userTypeFilter: String?
    var userID : String?
    let locationManager = CLLocationManager()

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
                let routePath = ("\(object.objectForKey("UserRoute")!)")
                
                let location = CLLocationCoordinate2D(latitude: destinationLatitude!, longitude: destinationLongitude!)
                
                self.drawRoute(route, userType: userType)
                self.placeMarker(location, userName: userName, userType: userType, userID: userID, timeOfRoute: timeOfRoute, routePath: routePath)
            }
        })

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
        //mapView.clear()
        if userTypeFilter == userType {
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

// Places marker on map when address is selected from searching, called from placeSelected()
    func placeMarker(coordinate: CLLocationCoordinate2D, var userName: String, userType: String, userID: String, timeOfRoute: String, routePath: String) {
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
    }
    
   
    // Presents custom window info box above marker
    func mapView(mapView: GMSMapView!, markerInfoWindow marker: GMSMarker!) -> UIView! {
        
        let infoWindow: CustomInfoWindow = NSBundle.mainBundle().loadNibNamed("CustomInfoWindow", owner: self, options: nil).first! as! CustomInfoWindow
        infoWindow.frame.size.width = 200
        infoWindow.frame.size.height = 75
        infoWindow.layer.cornerRadius = 10
        infoWindow.backgroundColor = purple
        
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
        
        //drawRoute(userType: userTypeFilter)
            
            return infoWindow
        }
    
//    func drawRoute(route: String, userType: String) {
//        //mapView.clear()
//        if userTypeFilter == userType {
//            let path: GMSPath = GMSPath(fromEncodedPath: route)
//            let routePolyline = GMSPolyline(path: path)
//            routePolyline.strokeWidth = 5.0
//            switch userType {
//            case "driver":
//                let driverLine = GMSStrokeStyle.solidColor(UIColor.greenColor())
//                routePolyline.spans = [GMSStyleSpan(style: driverLine)]
//            case "hitcher":
//                let hitcherLine = GMSStrokeStyle.solidColor(purple)
//                routePolyline.spans = [GMSStyleSpan(style: hitcherLine)]
//            default:
//                let standardline = GMSStrokeStyle.solidColor(UIColor.blueColor())
//                routePolyline.spans = [GMSStyleSpan(style: standardline)]
//            }
//            routePolyline.map = mapView
//        }
//    }
    
    
    
    
    // executes when user taps custom window info above marker, presents PopooverViewController
    func mapView(mapView: GMSMapView!, didTapInfoWindowOfMarker marker: GMSMarker!) {
        userID = "\(marker.userData)"
        performSegueWithIdentifier("segueToUsersProfile", sender: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "segueToUsersProfile") {
            if let destinationViewController = segue.destinationViewController as? HitcherDriverTableViewController {
                destinationViewController.userData = userID
            }
        }
    }

}


