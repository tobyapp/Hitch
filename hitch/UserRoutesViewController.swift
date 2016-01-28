//
//  HitcherDriverProfileViewController.swift
//  hitch
//
//  Created by Toby Applegate on 26/01/2016.
//  Copyright © 2016 Toby Applegate. All rights reserved.
//

import UIKit

class UserRoutesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var tableView2: UITableView!
    @IBOutlet weak var tableView1: UITableView!

    var userRoutes = RetrieveDataFromBackEnd()
    var usersOwnRoutes = [String]()
    var usersMatchedRoutes = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView1.delegate = self
        tableView1.dataSource = self
        tableView2.delegate = self
        tableView2.dataSource = self
        
        self.tableView1.registerClass(UITableViewCell.self, forCellReuseIdentifier: "table1Cells")
        self.tableView2.registerClass(UITableViewCell.self, forCellReuseIdentifier: "table2Ccells")
        
        // Changes colour scheme to purple to match rest of app, see class extentions for more details
        changeColorScheme()
         self.addSideMenu(menuButton)
        
        userRoutes.retrieveUsersOwnRoutes({results in
            //for object in results! {
                // cast elements of array to string as setArrayToGlobalVariable expecting [String]
                
                let location = CLLocation(latitude: results["DestinationLatitude"]! as! Double, longitude: results["DestinationLongitude"]! as! Double)
                CLGeocoder().reverseGeocodeLocation(location, completionHandler:
                    {(places, error) in
                        if error == nil {
                            let locations = places![0] as CLPlacemark
                            
                            let place = "\(locations.thoroughfare!)"
                            let city =  "\(locations.locality!)"
                            let region = "\(locations.administrativeArea!)"
                            let country = "\(locations.ISOcountryCode!)"
                            
                            self.usersOwnRoutes.append("Your Route to \(place), \(city), \(region), \(country) at \(results["TimeOfRoute"]!) as a \(results["UserType"]!)")
                            
                            //reloads tableview on main thread
                            dispatch_async(dispatch_get_main_queue()) {
                                self.tableView1.reloadData()
                            }
                        }
                        else {
                            print("reverse geodcode fail: \(error!.localizedDescription)")
                        }
                })
            //}
        })

        userRoutes.retrieveMatchedRoutes({results in
            print(results)
            print("nextone")
            //for object in results {

                let location = CLLocation(latitude: results["DestinationLatitude"]! as! Double, longitude: results["DestinationLongitude"]! as! Double)
                CLGeocoder().reverseGeocodeLocation(location, completionHandler:
                    {(places, error) in
                        if error == nil {
                            let locations = places![0] as CLPlacemark
                            
                            let place = "\(locations.thoroughfare!)"
                            let city =  "\(locations.locality!)"
                            let region = "\(locations.administrativeArea!)"
                            let country = "\(locations.ISOcountryCode!)"
                            
                            self.usersMatchedRoutes.append("Your Route to \(place), \(city), \(region), \(country) at \(results["TimeOfRoute"]!) as a \(results["UserType"]!)")
                            
                            //reloads tableview on main thread
                            dispatch_async(dispatch_get_main_queue()) {
                                self.tableView2.reloadData()
                            }
                        }
                        else {
                            print("reverse geodcode fail: \(error!.localizedDescription)")
                        }
                })
//            }
        })

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Table view data source
    
     func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
     func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var numberOfRows: Int?
        
        if tableView == tableView1 {
            numberOfRows = usersOwnRoutes.count
        }
        
        if tableView == tableView2 {
            numberOfRows = usersMatchedRoutes.count
        }
        
        return numberOfRows!
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell: UITableViewCell?
        
        if tableView == tableView1 {
            cell = tableView.dequeueReusableCellWithIdentifier("table1Cells", forIndexPath: indexPath)
            
            cell!.textLabel!.text = usersOwnRoutes[indexPath.item]
            cell!.textLabel!.textColor = purple
            cell!.textLabel!.font = UIFont(name: "System", size: 20)
            
            //return cell
        }
        
        if tableView == tableView2 {
            cell = tableView.dequeueReusableCellWithIdentifier("table2Ccells", forIndexPath: indexPath)
            
            cell!.textLabel!.text = usersMatchedRoutes[indexPath.item]
            cell!.textLabel!.textColor = purple
            cell!.textLabel!.font = UIFont(name: "System", size: 20)
            
            //return cell
        }
        
        return cell!
    }
    
     func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
     func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if tableView == tableView1 {
            print("touched 1")
        }
        
        if tableView == tableView2 {
            print("touched 2")
        }

    }
    

}
