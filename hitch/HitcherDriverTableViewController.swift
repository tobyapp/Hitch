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
    var userDetails = [String]()
    var routeId : String?
    
    @IBOutlet weak var usersDisplayPictrueView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let currentUser = "\((PFUser.currentUser()?.valueForKey("objectId"))!)"
        
        self.tableView.delegate = self
        
        if (userData! != currentUser) {
            let matchButton = UIBarButtonItem(title: "Match!", style: .Done, target: self, action: "match")
            navigationItem.rightBarButtonItem = matchButton
        }
        
        //get details of user, set these to global array then reload table view to show these
        if let userData = userData {
            userAccount.retrieveUserDetails(userData, resultHandler: ({results in
                self.userDetails += ["\(results["userName"]!)", "\(results["userAge"]!)", "\(results["userGender"]!)", "\(results["userEducation"]!)", "\(results["userEmailAddress"]!)"]
                if let picture = results["userDisplayPicture"] as! UIImage? {
                    self.usersDisplayPictrueView.image = picture
                }
                
                let params = ["objectId" : userData]
                PFCloud.callFunctionInBackground("averageRating", withParameters: params) { ( response, error) -> Void in
                    if response != nil {
                        if error == nil {
                            
                            let roundedRating = Double(round(100*Double(response! as! NSNumber))/100)
                            
                            print("rating is : \(response! as! Double)")
                            self.userDetails.append("Average User Rating  :  \(roundedRating)")
                        }
                        else {
                            print(error)
                        }
                    }
                    else {
                        print("no repsonse")
                        self.userDetails.append("Average User Rating  :  2.5")
                    }
                    
                    //reloads tableview on main thread
                    dispatch_async(dispatch_get_main_queue()) {
                        self.tableView.reloadData()
                        
                    }
                }
            }))
        }
        
        // Changes colour scheme to purple to match rest of app, see class extentions for more details
        changeColorScheme()
       
    }

    // Function activated from matchButton
    func match() {
        updateData.addMatchToRoute(routeId!, userId: userData!)
        navigationController?.popViewControllerAnimated(true)
        
        
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

    func getAverageRating(usersObjectId : String) -> String? {
        let params = ["objectId" : usersObjectId]
        var rating: String?
        
        PFCloud.callFunctionInBackground("averageRating", withParameters: params) { ( response, error) -> Void in
            
            if response != nil {
                if error == nil {
                    print("rating is : \(response!)")
                    rating = response! as? String
                }
                else {
                    print(error)
                }
            }
            else {
                print("no repsonse")
                rating = "2.5"
            }
        }
         return rating
    }
    
    
}


class CustomTableViewCell: UITableViewCell {
    
    let imgUser = UIImageView()
    let labUerName = UILabel()
    let labMessage = UILabel()
    let labTime = UILabel()
    let starView = UIView()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        imgUser.backgroundColor = UIColor.blueColor()
        
        imgUser.translatesAutoresizingMaskIntoConstraints = false
        labUerName.translatesAutoresizingMaskIntoConstraints = false
        labMessage.translatesAutoresizingMaskIntoConstraints = false
        labTime.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(imgUser)
        contentView.addSubview(labUerName)
        contentView.addSubview(labMessage)
        contentView.addSubview(labTime)
        
        let viewsDict = [
            "image" : imgUser,
            "username" : labUerName,
            "message" : labMessage,
            "labTime" : labTime,
        ]
        
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-[image(10)]", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[labTime]-|", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-[username]-[message]-|", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-[username]-[image(10)]-|", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-[message]-[labTime]-|", options: [], metrics: nil, views: viewsDict))
    }
    
}
