//
//  ProfileTableViewController.swift
//  hitch
//
//  Created by Toby Applegate on 22/12/2015.
//  Copyright © 2015 Toby Applegate. All rights reserved.
//

import UIKit
import CoreData

class ProfileTableViewController: UITableViewController {
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet var tableviewOutlet: UITableView!
    @IBOutlet weak var displayPicture: UIImageView!
    
    // managedObjectContext - Managed object to work with objects (Facebook data) in CoreData
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    var profileData = [UserProfileData]()
    var userDataArray: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("")
        print("in profile")
        print("")
        
        userDataArray.append("test 1")
        userDataArray.append("test2")
        userDataArray.append("what ever")
        userDataArray.append("fuck it")
        self.addSideMenu(menuButton)

        fetchProfileData()
        
    }
    
    func fetchProfileData() {
        let fetchRequest = NSFetchRequest(entityName: "UserProfileData")
        do {
            profileData = try (managedObjectContext.executeFetchRequest(fetchRequest) as? [UserProfileData])!
            let userData = profileData[0]
            userDataArray += [userData.userName!, userData.userAge!, userData.userGender!, userData.userEducation!]
            self.displayPicture.image = UIImage(data: userData.userDisplayPicture!)
        }
            
        catch let error as NSError {
            print("Fetch failed: \(error.localizedDescription)")
        }
        
        let currentUser = PFUser.currentUser()?.valueForKey("objectId")
        let params = ["objectId" : "\(currentUser)"]
        PFCloud.callFunctionInBackground("averageRating", withParameters: params) { ( response, error) -> Void in
            if response != nil {
                if error == nil {
                    self.userDataArray.append("Average User Rating  :  \(response!)")
                }
                else {
                    print(error)
                }
            }
            else {
                print("no repsonse")
                self.userDataArray.append("Hitch Rating  :  2.5")
            }
            
            //reloads tableview on main thread
            dispatch_async(dispatch_get_main_queue()) {
                self.tableView.reloadData()
                
            }
        }
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        tableviewOutlet.reloadData()
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
        return userDataArray.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("profileCells", forIndexPath: indexPath)

        //let userData = profileData[indexPath.row]
        
        cell.textLabel!.text = userDataArray[indexPath.item]
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
