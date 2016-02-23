//
//  ProfileTableViewController.swift
//  hitch
//
//  Created by Toby Applegate on 22/12/2015.
//  Copyright © 2015 Toby Applegate. All rights reserved.
//

import UIKit
import CoreData
import APParallaxHeader

class ProfileTableViewController: UITableViewController, APParallaxViewDelegate {
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet var tableviewOutlet: UITableView!
    
    // managedObjectContext - Managed object to work with objects (Facebook data) in CoreData
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    var profileData = [UserProfileData]()
    var userDataArray: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addSideMenu(menuButton)
        fetchProfileData()
        
    }
    
    func fetchProfileData() {
        let fetchRequest = NSFetchRequest(entityName: "UserProfileData")
        do {
            profileData = try (managedObjectContext.executeFetchRequest(fetchRequest) as? [UserProfileData])!
            let userData = profileData[0]
            userDataArray += [userData.userName!, userData.userAge!, userData.userGender!, userData.userEducation!]
            tableView.addParallaxWithImage(UIImage(data: userData.userDisplayPicture!), andHeight: 450, andShadow: true)
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

        cell.textLabel!.text = userDataArray[indexPath.item]
        cell.textLabel!.textColor = purple
        cell.textLabel!.font = UIFont(name: "System", size: 20)

        return cell
    }
    
    
    func parallaxView(view: APParallaxView!, willChangeFrame frame: CGRect) {
        print("will change")
    }
    
    func parallaxView(view: APParallaxView!, didChangeFrame frame: CGRect) {
        print("did change")
    }

}
