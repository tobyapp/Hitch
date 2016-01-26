//
//  UsersRoutesTableViewController.swift
//  hitch
//
//  Created by Toby Applegate on 26/01/2016.
//  Copyright © 2016 Toby Applegate. All rights reserved.
//

import UIKit
import Parse

class UsersRoutesTableViewController: UITableViewController {

    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    var userRoutes = RetrieveDataFromBackEnd()
    var userRoutesArray = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addSideMenu(menuButton)
        
        // Draws routes on map from back end database (Parse)
//        userRoutes.retrieveRoutes({results in
//            for object in results! {
//                let userType = ("\(object.objectForKey("UserType")!)")
//                let route = ("\(object.objectForKey("UserRoute")!)")
//                let userName = ("\(object.objectForKey("UserName")!)")
//                let userID = ("\(object.objectForKey("UserID")!)")
//                let destinationLatitude = Double("\(object.objectForKey("DestinationLatitude")!)")
//                let destinationLongitude = Double("\(object.objectForKey("DestinationLongitude")!)")
//                let timeOfRoute = ("\(object.objectForKey("TimeOfRoute")!)")
//                
//                let location = CLLocationCoordinate2D(latitude: destinationLatitude!, longitude: destinationLongitude!)
//                
//            }
//        })
        var positionInArray = 0
        userRoutes.retrieveUsersOwnRoutes({results in
            for object in results! {
            // cast elements of array to string as setArrayToGlobalVariable expecting [String]
                let message = ["\(results["userName"]!)", "\(results["userAge"]!)", "\(results["userGender"]!)", "\(results["userEducation"]!)", "\(results["userEmailAddress"]!)"]
                
                let details = ["\(results["userName"]!)", "\(results["userAge"]!)", "\(results["userGender"]!)", "\(results["userEducation"]!)", "\(results["userEmailAddress"]!)"]
                
                self.setArrayToGlobalVariable(details)
                positionInArray++
            }
        })
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}