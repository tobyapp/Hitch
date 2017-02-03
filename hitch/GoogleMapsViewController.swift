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
import Material
import Parse

class GoogleMapsViewController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate, SendDataBackProtocol  {

    @IBOutlet weak var mapView: GMSMapView!

    @IBAction func searchButton(_ sender: AnyObject) {
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
            let compasButtonHeight = UIApplication.shared.statusBarFrame.size.height
            mapView.padding = UIEdgeInsetsMake(navBarHeight+compasButtonHeight,0,0,0);
        }
        
        mapView.settings.compassButton = true
        mapView.settings.myLocationButton = true
        
        // Draws routes on map from back end database (Parse)
       getRoutesAndDisplayThem()
        
        // handles location auth globally and locally (locally as in for app, globally as in for whole phone through locaiotnservicesenabled())
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .authorizedAlways, .authorizedWhenInUse:
                locationManager.delegate = self
                locationManager.desiredAccuracy = kCLLocationAccuracyBest
            case .notDetermined:
                locationManager.requestAlwaysAuthorization()
                locationManager.requestWhenInUseAuthorization()
            case .restricted, .denied:
                showAlertController("Location services not enabled!", errorMessage: "Please enbale location services to Hitch!", showSettings: true, showProfile: false)
            }
        }
        else {
            showAlertController("Allow Hitch to access your location!", errorMessage: "Please enbale location services to Hitch!", showSettings: true, showProfile: false)
        }
        
        let refreshButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refreshMap))
        navigationItem.rightBarButtonItem = refreshButton
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let gpaViewController = GooglePlacesAutocomplete (
            apiKey: keys.googlePlacesAPIKey,
            placeType: .address
        )
        gpaViewController.placeDelegate = self
    }
    
    //presents search bar for user to search, sets UI for search bar view
    func presentSearchBar(){
        let gpaViewController = GooglePlacesAutocomplete (
            apiKey: keys.googlePlacesAPIKey,
            placeType: .address
        )
        
        gpaViewController.navigationBar.tintColor = UIColor.white
        gpaViewController.navigationBar.barTintColor = purple
        gpaViewController.navigationBar.barStyle = UIBarStyle.black
        gpaViewController.placeDelegate = self
        present(gpaViewController, animated: true, completion: nil)
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
        tappedByUser = true
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
            self.placeMarker(location, userName: userName, userType: userType, userID: userID, timeOfRoute: timeOfRoute, routeId: routeId, extraRideInfo: extraRideInfo, routePath: route)
        })
        
    }
    
    // Function to display an Alert Controller
    func showAlertController(_ errorTitle: String, errorMessage: String, showSettings: Bool, showProfile: Bool) {
        
        let alertController = UIAlertController(
            title: errorTitle,
            message: errorMessage,
            preferredStyle: .alert)
        let cancelAction = UIAlertAction(
            title: "Ok",
            style: UIAlertActionStyle.destructive,
            handler: nil)
        alertController.addAction(cancelAction)
        
        if showSettings {
            // Opens the phones settings application
            let openAction = UIAlertAction(
                title: "Open Settings",
                style: .default)
                { action in
                    if let url = URL(string:UIApplicationOpenSettingsURLString) {
                        UIApplication.shared.openURL(url)
                    }
                }
            alertController.addAction(openAction)
        }
        
        if showProfile {
            // Displays an action to user profile defined by userID 
            let profielAction = UIAlertAction(
                title:"Show Profile",
                style: .default,
                handler: { action in
                    self.performSegue(withIdentifier: "segueToUsersProfile", sender: self)
                }
            )
            alertController.addAction(profielAction)
        }
        DispatchQueue.main.async(execute: {
            self.present(alertController, animated: true, completion: nil)
        })
    }

    
}

// Extention of current class to incorportate wrapper for googlePlacesApi + other functionality
extension GoogleMapsViewController: GooglePlacesAutocompleteDelegate, UIPopoverPresentationControllerDelegate {
    
    // Allows user to search in search box from googlePlacesApi, when place is selected marker is placed
    func placeSelected(_ place: Place) {
        place.getDetails { details in
            self.destinationLongitude = details.longitude
            self.destinationLatitude = details.latitude
            let location = CLLocationCoordinate2D(latitude: details.latitude, longitude: details.longitude)
            self.mapView.camera = GMSCameraPosition(target: location, zoom: 15, bearing: 0, viewingAngle: 0)
            self.placeViewClosed()
            self.placeMarker(location)
        }
    }
    
    // Places marker on map when address is selected from searching, called from placeSelected()
    func placeMarker(_ coordinate: CLLocationCoordinate2D) {
        if let routePath = routePath {
            // removes previously plotted line from the map
            routePath.map = nil
        }
        
        locationMarker = GMSMarker(position: coordinate)
        locationMarker.icon = GMSMarker.markerImage(with: purple)
        locationMarker.map = mapView
        locationMarker.userData = ["longitude" : coordinate.longitude, "latitude" : coordinate.latitude]
        plottedByUser = true
    }
    
    // Places marker on map when address is selected from searching, called from placeSelected()
    func placeMarker(_ coordinate: CLLocationCoordinate2D, userName: String, userType: String, userID: String, timeOfRoute: String, routeId : String, extraRideInfo: String, routePath: String) {
        var userName = userName
        
        let currentUser = PFUser.current()?.value(forKey: "objectId")
        
        if userID == currentUser! as! String {
            userName = "You"
        }
        
        locationMarker = GMSMarker(position: coordinate)
        
        switch userType {
        case "driver":
            locationMarker.icon = GMSMarker.markerImage(with: UIColor.green)
            locationMarker.title = "Driver : \(userName)"
            locationMarker.snippet = "\(timeOfRoute)"
            locationMarker.userData = ["userID" : userID, "routeId" : routeId, "extraRideInfo" : extraRideInfo, "routePath" : routePath ]
        case "hitcher":
            locationMarker.icon = GMSMarker.markerImage(with: purple)
            locationMarker.title = "Hitcher : \(userName)"
            locationMarker.snippet = "\(timeOfRoute)"
            locationMarker.userData = ["userID" : userID, "routeId" : routeId, "extraRideInfo" : extraRideInfo, "routePath" : routePath ]
        default:
            locationMarker.icon = GMSMarker.markerImage(with: UIColor.blue)
            locationMarker.title = "Driver/Hitcher : unkown"
        }
        locationMarker.map = mapView
    }
    
    func placeViewClosed() {
        dismiss(animated: true, completion: nil)
    }
    
    // Presents custom window info box above marker
    func mapView(_ mapView: GMSMapView!, markerInfoWindow marker: GMSMarker!) -> UIView! {

        let infoWindow: CustomInfoWindow = Bundle.main.loadNibNamed("CustomInfoWindow", owner: self, options: nil)!.first! as! CustomInfoWindow
        infoWindow.backgroundColor = purple
        infoWindow.layer.cornerRadius = 10
        
        // If snippet from marker is nil then means is plotting a new route, snippet contains date and time info so only applicable to previously plotted oruts
        if marker.snippet == nil {
            
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
            plottedByUser = true
        }
            
        else {
            
            plottedByUser = false
            let routeData = marker.userData as! [String: AnyObject] //marker.userData["routePath"] as! String
            
            if "\(routeData["extraRideInfo"])" != "" {

                //info window dimensions, demsions increase if there are extra info
                infoWindow.frame.size.width = 300
                infoWindow.frame.size.height = 150
                
                let extraInfoLabel = UILabel(frame: CGRect(x: 0, y: 50, width: infoWindow.frame.size.width , height: 100))
                extraInfoLabel.numberOfLines = 0
                extraInfoLabel.textAlignment = .center
                extraInfoLabel.text = "Extra info : \((routeData["extraRideInfo"])!)"
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
            
            // removes previously plotted line form the map
            if let routePath = routePath {
                routePath.map = nil
            }
            
            //draws red route over selected route so user can see it
            self.drawRoute("\((routeData["routePath"])!)", userType: "selected")

        }
        return infoWindow
    }
    
    // When user taps the map (not the info marker or anything)
    func mapView(_ mapView: GMSMapView!, didTapAt coordinate: CLLocationCoordinate2D) {

        // removes previously plotted line from the map
        if let routePath = routePath {
            print("in route path")
            routePath.map = nil
        }
        
        // Allows user to tap area on map to plot route there, also allows user to tap map to deselect route they previously plotted or pinned
        if tappedByUser {
            let currentZoom = self.mapView.camera.zoom
            destinationLongitude = coordinate.longitude
            destinationLatitude = coordinate.latitude
            mapView.camera = GMSCameraPosition(target: coordinate, zoom: currentZoom, bearing: 0, viewingAngle: 0)
            placeMarker(coordinate)
            tappedByUser = false
        }
        else {
            if locationMarker != nil {
                locationMarker.map = nil
            }
            tappedByUser = true
        }
    }
    
    // executes when user taps custom window info above marker, presents PopooverViewController
    func mapView(_ mapView: GMSMapView!, didTapInfoWindowOf marker: GMSMarker!) {
        
        let routeData = marker.userData as! [String: AnyObject]
        
        if plottedByUser {
            performSegue(withIdentifier: "segueToHitchOrDriveOption", sender: nil)
            marker.map = nil
        }
            
        else if !plottedByUser {
            if calledFromAlertController {
                calledFromAlertController = false
                performSegue(withIdentifier: "segueToUsersProfile", sender: nil)
            }
                
            else if !calledFromAlertController {
                
                //print((routeData["extraRideInfo"])!)
                print("route is : \((routeData["routePath"])!)")
                
                userID = "\((routeData["userID"])!)"
                routeId = "\(routeData["routeId"]!)"
                performSegue(withIdentifier: "segueToUsersProfile", sender: nil)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        if (segue.identifier == "segueToUsersProfile") {
            if let destinationViewController = segue.destination as? HitcherDriverTableViewController {
                destinationViewController.userData = userID!
                if let routeId = routeId {
                    destinationViewController.routeId = routeId
                }
                destinationViewController.showMatch = true
            }
        }
        
        if (segue.identifier == "segueToHitchOrDriveOption") {
            if let destinationViewController = segue.destination as? HtichOrDrivePopupViewController {
                destinationViewController.destinationLatitude = destinationLatitude
                destinationViewController.destinationLongitude = destinationLongitude
                destinationViewController.originLatitude = originLatitude
                destinationViewController.originLongitude = originLongitude
                let vc = segue.destination as! HtichOrDrivePopupViewController
                vc.delegate = self
            }
        }
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .popover
    }
    
    // Recieves route back from the the PopoverVC (and from RouteCalculator.swift)
    func sendRouteBack(_ route: String, userType: String, originLatitude: Double, originLongitude: Double, destinationLatitude: Double, destinationLongitude: Double, timeOfRoute: String, extraRideInfo: String) {
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
            
            //add marker to plotted route, may not need it
            let location = CLLocationCoordinate2D(latitude: destinationLatitude, longitude: destinationLongitude)
            let currentUser = PFUser.current()?.value(forKey: "objectId")
            self.placeMarker(location, userName: "You", userType: userType, userID: "\(currentUser!)", timeOfRoute: timeOfRoute, routeId: "", extraRideInfo: "", routePath: route)
            
            plottedByUser = false
        }
    }
    
    // Calculate route proximity then present alert to show user that another user is trvaling to this location
    func routeProximity(_ usersOriginLatitude : Double, usersOriginLongitude : Double, usersDestLatitude : Double, usersDestLongitude : Double) {
        
        // co-ord params to pass to back end function "routeProximity" (see parse cloud code)
        let params = ["usersOriginLatitude" : usersOriginLatitude,  "usersOriginLongitude" : usersOriginLongitude, "usersDestLatitude" : usersDestLatitude,  "usersDestLongitude" : usersDestLongitude]
        PFCloud.callFunction(inBackground: "routeProximity", withParameters: params) { ( response, error) -> Void in

            if response != nil {
                if error == nil {
                    if let userObject = response as! PFObject? {
                        
                        let currentUser = PFUser.current()?.value(forKey: "objectId")
                        let userName = userObject["userName"]
                        self.calledFromAlertController = true
                        self.userID = ("\(userObject.value(forKey: "objectId")!)")
                        
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
    func drawRoute(_ route: String, userType: String) {

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
