//
//  HitcherDriverProfileViewController.swift
//  hitch
//
//  Created by Toby Applegate on 26/01/2016.
//  Copyright © 2016 Toby Applegate. All rights reserved.
//

import UIKit
import Material

class UserRoutesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var tableView2: UITableView!
    @IBOutlet weak var tableView1: UITableView!

    var userRoutes = RetrieveDataFromBackEnd()
    var usersOwnRoutes = [Dictionary<String, String>]()
    var usersMatchedRoutes = [Dictionary<String, String>]()
    var reviewedYet : Bool?
    var uploadData = UploadDataToBackEnd()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView1.delegate = self
        tableView1.dataSource = self
        tableView2.delegate = self
        tableView2.dataSource = self
        
        self.tableView1.register(UITableViewCell.self, forCellReuseIdentifier: "table1Cells")
        self.tableView2.register(UITableViewCell.self, forCellReuseIdentifier: "table2Cells")
        
        // Changes colour scheme to purple to match rest of app, see class extentions for more details
        changeColorScheme()
        self.addSideMenu(menuButton)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.usersMatchedRoutes.removeAll()
        self.usersOwnRoutes.removeAll()
        activityIndicatorView.startAnimating()
        
        userRoutes.retrieveUsersOwnRoutes({results in
            let location = CLLocation(latitude: results["DestinationLatitude"]! as! Double, longitude: results["DestinationLongitude"]! as! Double)
            CLGeocoder().reverseGeocodeLocation(location, completionHandler:
                {(places, error) in
                    if error == nil {
                        
                        let locations = places![0] as CLPlacemark
                        
                        guard let place = locations.thoroughfare else {
                            print("no place at \(location)")
                            return
                        }
                        
                        guard let city = locations.locality else {
                            print("no city at \(location)")
                            return
                        }
                        
                        guard let region = locations.administrativeArea else {
                            print("no region at \(location)")
                            return
                        }
                        
                        guard let country = locations.isoCountryCode else {
                            print ("no country at \(location)")
                            return
                        }
                        
                        self.usersOwnRoutes.append(["routeTo" : place, "routeId" : "\(results["RouteId"]!)", "message" : "Your Route to \(place), \(city), \(region), \(country) at \(results["TimeOfRoute"]!) as a \(results["UserType"]!) with the following extra ride information '\(results["ExtraRideInfo"]!)'"])
                    }
                    else {
                        print("reverse geodcode fail: \(error!.localizedDescription)")
                    }
                    
                    //reloads tableview on main thread after all data is got
                    DispatchQueue.main.async {
                        self.tableView1.reloadData()
                        self.activityIndicatorView.stopAnimating()
                        
                    }
            })
        })

        userRoutes.retrieveMatchedRoutes({results in
                let location = CLLocation(latitude: results["DestinationLatitude"]! as! Double, longitude: results["DestinationLongitude"]! as! Double)
                CLGeocoder().reverseGeocodeLocation(location, completionHandler:
                    {(places, error) in
                        if error == nil {
                            
                            let locations = places![0] as CLPlacemark
                            
                            guard let place = locations.thoroughfare else {
                                print("no place at \(location)")
                                return
                            }
                            
                            guard let city = locations.locality else {
                                print("no city at \(location)")
                                return
                            }
                            
                            guard let region = locations.administrativeArea else {
                                print("no region at \(location)")
                                return
                            }
                            
                            guard let country = locations.isoCountryCode else {
                                print ("no country at \(location)")
                                return
                            }
                            
                            // Adds objectId and content to be displayed in cell to dict
                            self.usersMatchedRoutes.append(["UserID": "\(results["UserID"]!)", "userName" : "\(results["UserName"]!)", "reviewedBool" : "\(results["Reviewed"]!)", "routeId" : "\(results["RouteId"]!)","objectId" : "\(results["UserID"]!)", "message" : "Your Route to \(place), \(city), \(region), \(country) at \(results["TimeOfRoute"]!) as a \(results["UserType"]!) from \(results["UserName"]!) with the following extra ride information '\(results["ExtraRideInfo"]!)'"])
                        }
                            
                        else {
                            print("reverse geodcode fail: \(error!.localizedDescription)")
                        }
                        
                        //reloads tableview on main thread after all data is got
                        DispatchQueue.main.async {
                            self.activityIndicatorView.stopAnimating()
                            self.tableView2.reloadData()
                        }
                })
        })

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Table view data source
    
     func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var numberOfRows: Int?
        
        if tableView == tableView1 {
            numberOfRows = usersOwnRoutes.count
        }
        
        if tableView == tableView2 {
            numberOfRows = usersMatchedRoutes.count
        }
        
        return numberOfRows!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell: UITableViewCell?
        
        if tableView == tableView1 {
            cell = tableView.dequeueReusableCell(withIdentifier: "table1Cells", for: indexPath)
            
            let routeDict = usersOwnRoutes[indexPath.row]
            cell!.textLabel!.text = routeDict["message"]
            cell!.textLabel!.textColor = purple
            cell!.textLabel!.font = UIFont(name: "System", size: 20)
            cell!.textLabel!.numberOfLines = 0
            
        }
        
        if tableView == tableView2 {
            tableView.rowHeight = UITableViewAutomaticDimension
            cell = tableView.dequeueReusableCell(withIdentifier: "table2Cells", for: indexPath)
            
            let routeDict = usersMatchedRoutes[indexPath.row]
            cell!.textLabel!.text = routeDict["message"]//usersMatchedRoutes[indexPath.item]
            cell!.textLabel!.textColor = purple
            cell!.textLabel!.font = UIFont(name: "System", size: 20)  //systemFontOfSize(20)
            cell!.textLabel!.numberOfLines = 0
        }
        
        return cell!
    }
    
     func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == tableView1 {
            let row = self.tableView1.indexPathForSelectedRow?.row
            let routeDict = usersOwnRoutes[row!]
            let routeId = routeDict["routeId"]
            //uploadData.deleteUserRoute(routeId!)
            let routeTo = routeDict["routeTo"]
            showAlertController(routeId: routeId!, routeTo: routeTo!, row: row!)
        }
        
        if tableView == tableView2 {
            
            let row = self.tableView2.indexPathForSelectedRow?.row
            print("row : \(row)")
            let routeDict = usersMatchedRoutes[row!]
            let reviewBool = routeDict["reviewedBool"]?.toBool()
            let userName = routeDict["userName"]
            
            if let reviewed = reviewBool {
                showAlertController(userName: userName!, reviewed: reviewed)
            }
        }
    }
    
    // Function to display an Alert Controller
    func showAlertController(userName : String, reviewed: Bool) {
        let alertController = UIAlertController(
            title: "Review or view the user \(userName)!",
            message: "You can either view thier profile or rate them (you can only do this one per trip!)",
            preferredStyle: .alert)
        let cancelAction = UIAlertAction(
            title: "Cancel",
            style: UIAlertActionStyle.cancel,
            handler: nil)
        
        let showAction = UIAlertAction (
            title: "Show Profile!",
            style: .default)
            { action in
                self.performSegue(withIdentifier: "segueToUsersProfile", sender: nil) }
        
        let rateAction: UIAlertAction = UIAlertAction (
            title: "Rate Hitcher!",
            style: .default)
            { action in
                self.performSegue(withIdentifier: "segueToRating", sender: nil) }
        
        alertController.addAction(cancelAction)
        if !reviewed {
            alertController.addAction(rateAction)
        }
        alertController.addAction(showAction)
        self.present(alertController, animated: true)
    }
    
    // Function to display an Alert Controller to delete user route
    func showAlertController(routeId : String, routeTo: String, row: Int) {
        let alertController = UIAlertController(
            title: "Are you sure you want to delete this route to \(routeTo)?",
            message: "By pressing the button below you will be deleting the route from yourself and all other hitchers!",
            preferredStyle: .alert)
        let cancelAction = UIAlertAction(
            title: "Cancel",
            style: UIAlertActionStyle.cancel,
            handler: nil)
        let deleteAction = UIAlertAction(
            title: "Delete Route!",
            style: UIAlertActionStyle.destructive)
            { action in
                self.uploadData.deleteUserRoute(routeId)
                self.usersOwnRoutes.remove(at: row)
                
                //reloads tableview on main thread
                DispatchQueue.main.async {
                    self.tableView1.reloadData()
                    print("reloading")
                }
            }
        
        alertController.addAction(cancelAction)
        alertController.addAction(deleteAction)
        self.present(alertController, animated: true, completion: nil)

    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        
        let row = self.tableView2.indexPathForSelectedRow?.row
        let routeDict = usersMatchedRoutes[row!]
        
        if segue.identifier == "segueToRating" {
            if let destinationViewController = segue.destination as? RatingViewController {
                // Gets the row seleted from the 2nd tableView and retireves the objectId corrisponding to that row from the routeDict
                destinationViewController.objectId = routeDict["objectId"]!
                destinationViewController.routeId = routeDict["routeId"]!
            }
        }
            
        else if segue.identifier == "segueToUsersProfile" {
            if let destinationViewController = segue.destination as? HitcherDriverTableViewController {
                destinationViewController.userData = routeDict["UserID"]!
                destinationViewController.routeId = routeDict["routeId"]!
                destinationViewController.showMatch = false
            }
        }
    }


}
