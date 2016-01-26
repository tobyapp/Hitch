//
//  HitcherDriverProfileViewController.swift
//  hitch
//
//  Created by Toby Applegate on 26/01/2016.
//  Copyright © 2016 Toby Applegate. All rights reserved.
//

import UIKit

class HitcherDriverProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var userDisplaypicture: UIImageView!
    @IBOutlet weak var tableView: UITableView!

    var userAccount = RetrieveDataFromBackEnd()
    var userData : String?
    var userDetails = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "userCells")
        
        tableView.delegate = self
        //tableView.dataSource = self

        //get details of user, set these to global array then reload table view to show these
        if let userData = userData {
            userAccount.retrieveUserDetails(userData, resultHandler: ({results in
                // cast elements of array to string as setArrayToGlobalVariable expecting [String]
                let details = ["\(results["userName"]!)", "\(results["userAge"]!)", "\(results["userGender"]!)", "\(results["userEducation"]!)", "\(results["userEmailAddress"]!)"]
                self.setArrayToGlobalVariable(details)
                if let picture = results["userDisplayPicture"] as! UIImage? {
                    self.userDisplaypicture.image = picture
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // sets array form completion handler to a global variable
    func setArrayToGlobalVariable(userDetailsFromHandler: [String]) {
        userDetails = userDetailsFromHandler
    }
    
    // MARK: - Table view data source
    
     func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
     func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return userDetails.count
        
    }
    
     func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("userCells", forIndexPath: indexPath)
        
        cell.textLabel!.text = userDetails[indexPath.item] as? String
        cell.textLabel!.textColor = purple
        cell.textLabel!.font = UIFont(name: "System", size: 20)
        cell.userInteractionEnabled = false
        
        return cell
    }
    
     func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
     func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("touched")
    }

}
