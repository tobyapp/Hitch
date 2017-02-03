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
import Material

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
            let compasButtonHeight = UIApplication.shared.statusBarFrame.size.height
            mapView.padding = UIEdgeInsetsMake(navBarHeight+compasButtonHeight,0,0,0);
        }
        
        mapView.settings.compassButton = true
        mapView.settings.myLocationButton = true
        
        getRoutesAndDisplayThem()
        
        let refreshButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(FilterSelectionViewController.refreshMap))
        navigationItem.rightBarButtonItem = refreshButton

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // handles when auth for locaiton is changed (see docs)
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .denied {
            manager.stopUpdatingLocation()
            mapView.isMyLocationEnabled = false
        }
            
        else if status == .authorizedAlways || status == .authorizedWhenInUse {
            manager.startUpdatingLocation()
            mapView.isMyLocationEnabled = true
            mapView.settings.myLocationButton = true
        }
    }
    
    // places view on users location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
            locationManager.stopUpdatingLocation()
        }
    }

    // Draws route on map (colour changes depending on user type)
    func drawRoute(_ route: String, userType: String) {
        print("in draw route \(userType)")
//        print("user type : \(userType)")
//        print("userTypeFilter : \(userTypeFilter)")
        if userType == userTypeFilter || userType == "selected" {
            let path: GMSPath = GMSPath(fromEncodedPath: route)!
            let routePolyline = GMSPolyline(path: path)
            routePolyline.strokeWidth = 5.0
            switch userType {
                case "driver":
                    let driverLine = GMSStrokeStyle.solidColor(UIColor.green)
                    routePolyline.spans = [GMSStyleSpan(style: driverLine)]
                case "hitcher":
                    let hitcherLine = GMSStrokeStyle.solidColor(purple)
                    routePolyline.spans = [GMSStyleSpan(style: hitcherLine)]
                case "selected":
                    let selectedLine = GMSStrokeStyle.solidColor(UIColor.red)
                    routePolyline.spans = [GMSStyleSpan(style: selectedLine)]
                    routePath = routePolyline
                default:
                    let standardline = GMSStrokeStyle.solidColor(UIColor.blue)
                    routePolyline.spans = [GMSStyleSpan(style: standardline)]
            }
            routePolyline.map = mapView
        }
    }

 //Places marker on map when address is selected from searching, called from placeSelected()
    func placeMarker(_ coordinate: CLLocationCoordinate2D, userName: String, userType: String, userID: String, timeOfRoute: String, routeId : String, extraRideInfo: String, routePath: String) {
     var userName = userName
        
        if userTypeFilter == userType {
            let currentUser = PFUser.current()?.value(forKey: "userName")
    
            if userName == currentUser! as! String {
                userName = "You"
            }
    
            locationMarker = GMSMarker(position: coordinate)
            
            switch userType {
                case "driver":
                    locationMarker.icon = GMSMarker.markerImage(with: UIColor.green)
                    locationMarker.title = "Driver : \(userName)"
                    locationMarker.snippet = "\(timeOfRoute)"
                    locationMarker.userData = ["userID": userID, "routeId" : routeId, "extraRideInfo" : extraRideInfo, "routePath" : routePath ]
                case "hitcher":
                    locationMarker.icon = GMSMarker.markerImage(with: purple)
                    locationMarker.title = "Hitcher : \(userName)"
                    locationMarker.snippet = "\(timeOfRoute)"
                    locationMarker.userData = ["userID": userID, "routeId" : routeId, "extraRideInfo" : extraRideInfo, "routePath" : routePath ]
                default:
                    locationMarker.icon = GMSMarker.markerImage(with: UIColor.blue)
                    locationMarker.title = "Driver/Hitcher : unkown"
            }
            locationMarker.map = mapView
        }
    }
    // Presents custom window info box above marker
    func mapView(_ mapView: GMSMapView!, markerInfoWindow marker: GMSMarker!) -> UIView! {
        
        let infoWindow: CustomInfoWindow = Bundle.main.loadNibNamed("CustomInfoWindow", owner: self, options: nil)!.first! as! CustomInfoWindow
        infoWindow.backgroundColor = purple
        infoWindow.layer.cornerRadius = 10
        let routeData = marker.userData as! [String: AnyObject] //marker.userData["routePath"] as! String
        
        if "\(routeData["extraRideInfo"])" != "" {
            
            //info window dimensions, demsions increase if there are extra info
            infoWindow.frame.size.width = 300
            infoWindow.frame.size.height = 150
                
            let extraInfoLabel = UILabel(frame: CGRect(x: 0, y: 50, width: infoWindow.frame.size.width , height: 100))
            extraInfoLabel.numberOfLines = 0
            extraInfoLabel.textAlignment = .center
            extraInfoLabel.text = "Extra info : \(routeData["extraRideInfo"])"
            extraInfoLabel.textColor = UIColor.white
            extraInfoLabel.layer.cornerRadius = 10
            infoWindow.addSubview(extraInfoLabel)
        }
                
        else {
            //info window dimensions
            infoWindow.frame.size.width = 200
            infoWindow.frame.size.height = 75
        }
            
        let userLabel = UILabel(frame: CGRect(x: 0, y: 0, width: infoWindow.frame.size.width , height: 50))
        userLabel.textAlignment = .center
        userLabel.text = marker.title
        userLabel.textColor = UIColor.white
        userLabel.layer.cornerRadius = 10
        infoWindow.addSubview(userLabel)
            
        let timeLabel = UILabel(frame: CGRect(x: 0, y: 25, width: infoWindow.frame.size.width , height: 50))
        timeLabel.textAlignment = .center
        timeLabel.text = "At : \(marker.snippet)"
        timeLabel.textColor = UIColor.white
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
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        if let routePath = routePath {
            // removes previously plotted line from the map
            routePath.map = nil
        }
    }

    // executes when user taps custom window info above marker, presents PopooverViewController
    func mapView(_ mapView: GMSMapView!, didTapInfoWindowOf marker: GMSMarker!) {
        let routeData = marker.userData as! [String: AnyObject] //marker.userData["routePath"] as! String
        userID = "\(routeData["userID"])"
        routeId = "\(routeData["routeId"])"
        performSegue(withIdentifier: "segueToUsersProfile", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        if let destinationViewController = segue.destination as? HitcherDriverTableViewController {
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


