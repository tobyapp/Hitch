//
//  HitcherDriverTableViewController.swift
//  hitch
//
//  Created by Toby Applegate on 14/01/2016.
//  Copyright © 2016 Toby Applegate. All rights reserved.
//

import UIKit
import Parse

class HitcherDriverTableViewController: UITableViewController {
    
    var userAccount = RetrieveDataFromBackEnd()
    var updateData = UploadDataToBackEnd()
    var userData : String?
    var userDetails = []
    var routeId : String?
    
    @IBOutlet weak var usersDisplayPictrueView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let currentUser = "\((PFUser.currentUser()?.valueForKey("objectId"))!)"
        print("route ID is:")
        print(routeId!)
        print("user ID is:")
        print(userData!)
        print("current user is:")
        print(currentUser)
        
        self.tableView.delegate = self
        if (userData! != currentUser) {
            let matchButton = UIBarButtonItem(title: "Match!", style: .Done, target: self, action: "match")
            navigationItem.rightBarButtonItem = matchButton
        }
        
        //get details of user, set these to global array then reload table view to show these
        if let userData = userData {
            userAccount.retrieveUserDetails(userData, resultHandler: ({results in
                self.userDetails = ["\(results["userName"]!)", "\(results["userAge"]!)", "\(results["userGender"]!)", "\(results["userEducation"]!)", "\(results["userEmailAddress"]!)"]
                if let picture = results["userDisplayPicture"] as! UIImage? {
                    self.usersDisplayPictrueView.image = picture
                }

                //reloads tableview on main thread
                dispatch_async(dispatch_get_main_queue()) {
                    self.tableView.reloadData()
                }
                
            }))
        }

        // Changes colour scheme to purple to match rest of app, see class extentions for more details
        changeColorScheme()

    }

    // Function activated from matchButton
    func match() {
        updateData.addMatchToRoute(routeId!, userId: userData!)
        
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

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("userCells", forIndexPath: indexPath)

        cell.textLabel!.text = userDetails[indexPath.item] as? String
        cell.textLabel!.textColor = purple
        cell.textLabel!.font = UIFont(name: "System", size: 20)
        //cell.userInteractionEnabled = false
        
        return cell
    }
    
    override func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("touched")
    }

}
