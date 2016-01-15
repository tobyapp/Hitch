//
//  ProfileTableViewController.swift
//  hitch
//
//  Created by Toby Applegate on 22/12/2015.
//  Copyright © 2015 Toby Applegate. All rights reserved.
//

import UIKit

class ProfileTableViewController: UITableViewController {
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    @IBOutlet var tableviewOutlet: UITableView!
    @IBOutlet weak var displayPicture: UIImageView!
    
    //var facebookProfileData = ParseFBData()
    var account = UserAccount()
    
    var userName: String?
    var userGender: String?
    var userAge: String?
    var userEducationArray: String?
    var userEmail: String?
    var fbarray: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addSideMenu(menuButton)
        
        if let dp = account.displayPicture {
            self.displayPicture.image = UIImage(data: dp)
        }
        
        
        self.userName = account.userName
        
        fbarray += [account.userName!, account.userDOB!, account.userGender!, account.userEducation!]
        
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
        return fbarray.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("example", forIndexPath: indexPath)

        cell.textLabel!.text = fbarray[indexPath.item]
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
