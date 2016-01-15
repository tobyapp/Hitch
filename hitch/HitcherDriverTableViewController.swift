//
//  HitcherDriverTableViewController.swift
//  hitch
//
//  Created by Toby Applegate on 14/01/2016.
//  Copyright © 2016 Toby Applegate. All rights reserved.
//

import UIKit

class HitcherDriverTableViewController: UITableViewController, SendDataBackProtocol {
    
    var userAccount = RetrieveDataFromBackEnd()
    var userData : String?
    var userDetails = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let userData = userData {
            print("user data: \(userData)")
            userAccount.retrieveUserDetails(userData, resultHandler: ({results in
                let details = [results["userName"]!, results["userAge"]!, results["userGender"]!, results["userEducation"]!]
                self.setArrayToGlobalVariable(details)
                //print(self.userDetails)
                //print(results)
                
                //reloads tableview on main thread
                dispatch_async(dispatch_get_main_queue()) {
                    self.tableView.reloadData()
                }
                
            }))
        }
        
        

        // Changes colour scheme to purple to match rest of app, see class extentions for more details
        changeColorScheme()
        print(userDetails)
    }
    
    // sets array form completion handler to a global variable
    func setArrayToGlobalVariable(userDetailsFromHandler: [String]) {
        userDetails = userDetailsFromHandler
        //self.tableView.reloadData()
        print(userDetails)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return userDetails.count
        
    }


    // Recieves user data from the the googlemapdVC
    func sendUserDataBack(userID: String) {
        print(userID)
    }
    
    func sendRouteBack(route: String, userType: String, destinationLatitude: Double, destinationLongitude: Double) {
        print("in sendRouteBack from data protocol")
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("userCells", forIndexPath: indexPath)

        cell.textLabel!.text = userDetails[indexPath.item] as? String
        cell.textLabel!.textColor = purple
        cell.textLabel!.font = UIFont(name: "System", size: 20)

        return cell
    }


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
