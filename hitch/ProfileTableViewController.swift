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
   // @IBOutlet weak var displayPicture: UIImageView!
    
    // managedObjectContext - Managed object to work with objects (Facebook data) in CoreData
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    var profileData = [UserProfileData]()
    var userDataArray: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addSideMenu(menuButton)
        fetchProfileData()
        
        //add UI gesture
//        let swipeDown = UISwipeGestureRecognizer(target: self, action: "respondToSwipeGesture:")
//        //swipeDown.delegate = self
//        swipeDown.direction = UISwipeGestureRecognizerDirection.Down
//        displayPicture.userInteractionEnabled = true
//        self.displayPicture.addGestureRecognizer(swipeDown)
        
    }
    
    
    
    func fetchProfileData() {
        let fetchRequest = NSFetchRequest(entityName: "UserProfileData")
        do {
            profileData = try (managedObjectContext.executeFetchRequest(fetchRequest) as? [UserProfileData])!
            let userData = profileData[0]
            userDataArray += [userData.userName!, userData.userAge!, userData.userGender!, userData.userEducation!]
            //self.displayPicture.image = UIImage(data: userData.userDisplayPicture!)
            //self.displayPicture.contentMode = UIViewContentMode.Center
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
        //let userData = profileData[indexPath.row]
        
        cell.textLabel!.text = userDataArray[indexPath.item]
        cell.textLabel!.textColor = purple
        cell.textLabel!.font = UIFont(name: "System", size: 20)

        return cell
    }

    //handle when user swipes
//    func respondToGesture(gesture: UIGestureRecognizer){
//        print("swiped down")
//        UIView.animateWithDuration(0.35, animations: {
//            
//            self.displayPicture.frame = CGRectMake(self.displayPicture.frame.origin.x,
//                self.view.frame.height,
//                self.displayPicture.frame.size.width,
//                self.displayPicture.frame.size.height)
//        })
//        
//    }

}
