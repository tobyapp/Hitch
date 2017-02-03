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
    var displayPicture: UIImageView?
    
    // managedObjectContext - Managed object to work with objects (Facebook data) in CoreData
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
    
    var profileData = [UserProfileData]()
    var userDataArray: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addSideMenu(menuButton)
        fetchProfileData()
        
    }

    func fetchProfileData() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "UserProfileData")
        do {
            profileData = try (managedObjectContext.fetch(fetchRequest) as? [UserProfileData])!
            let userData = profileData[0]
            userDataArray += [userData.userName!, userData.userAge!, userData.userGender!, userData.userEducation!]
            tableView.addParallax(with: UIImage(data: userData.userDisplayPicture! as Data), andHeight: 450, andShadow: true)
        }
            
        catch let error as NSError {
            print("Fetch failed: \(error.localizedDescription)")
        }
        
        let currentUser = PFUser.current()?.value(forKey: "objectId")
        let params = ["objectId" : "\(currentUser)"]
        PFCloud.callFunction(inBackground: "averageRating", withParameters: params) { ( response, error) -> Void in
            if response != nil {
                if error == nil {
                    self.userDataArray.append("Average User Rating  :  \(response!)")
                }
                else {
                    print(error!)
                }
            }
            else {
                self.userDataArray.append("Hitch Rating  :  2.5")
            }
            
            //reloads tableview on main thread
            DispatchQueue.main.async {
                self.tableView.reloadData()
                
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return userDataArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "profileCells", for: indexPath)

        cell.textLabel!.text = userDataArray[indexPath.item]
        cell.textLabel!.textColor = purple
        cell.textLabel!.font = UIFont(name: "System", size: 20)

        return cell
    }
    
    
    func parallaxView(_ view: APParallaxView!, willChangeFrame frame: CGRect) {
        print("will change")
    }
    
    func parallaxView(_ view: APParallaxView!, didChangeFrame frame: CGRect) {
        print("did change")
    }

}
