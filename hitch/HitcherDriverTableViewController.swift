//
//  HitcherDriverTableViewController.swift
//  hitch
//
//  Created by Toby Applegate on 14/01/2016.
//  Copyright © 2016 Toby Applegate. All rights reserved.
//

import UIKit
import Parse
import APParallaxHeader
import MessageUI

// Shows profile of other hithc users
class HitcherDriverTableViewController: UITableViewController, APParallaxViewDelegate, MFMailComposeViewControllerDelegate {
    
    var userAccount = RetrieveDataFromBackEnd()
    var updateData = UploadDataToBackEnd()
    var userData : String?
    var userDetails = [String]()
    var routeId : String?
    var showMatch : Bool?
    let currentUser = "\((PFUser.current()?.value(forKey: "objectId"))!)"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        
        if (userData! != currentUser && showMatch!) {
            let matchButton = UIBarButtonItem(title: "Match!", style: .done, target: self, action: #selector(HitcherDriverTableViewController.match))
            navigationItem.rightBarButtonItem = matchButton
        }
        
        
        // Changes colour scheme to purple to match rest of app, see class extentions for more details
        changeColorScheme()
        
        //get details of user, set these to global array then reload table view to show these
        if let userData = userData {
            userAccount.retrieveUserDetails(userData, resultHandler: ({results in
                self.userDetails += ["\(results["userName"]!)", "\(results["userAge"]!)", "\(results["userGender"]!)", "\(results["userEducation"]!)", "\(results["userEmailAddress"]!)"]
                
                if let picture = results["userDisplayPicture"] as! UIImage? {
                    //reloads tableview on main thread
                    DispatchQueue.main.async {
                        self.tableView.addParallax(with: picture, andHeight: 450, andShadow: true)
                        self.tableView.reloadData()
                    }
                }
                
                let params = ["objectId" : userData]
                PFCloud.callFunction(inBackground: "averageRating", withParameters: params) { ( response, error) -> Void in
                    if response != nil {
                        if error == nil {
                            self.userDetails.append("Hitch Rating  :  \(response!)")
                        }
                        else {
                            print(error!)
                        }
                    }
                    else {
                        print("no repsonse")
                        self.userDetails.append("Hitch Rating  :  2.5")
                    }
                    
                    //reloads tableview on main thread
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }))
        }
    }

    // Function activated from matchButton
    func match() {
        updateData.addMatchToRoute(routeId!, userId: userData!)
        navigationController?.popViewController(animated: true)
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
        return userDetails.count
        
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userCells", for: indexPath)
        
        // if current user loged in
        if (userData! == currentUser) {
            cell.selectionStyle = UITableViewCellSelectionStyle.none
        }
        else {
            cell.isUserInteractionEnabled = true
            cell.selectionStyle = UITableViewCellSelectionStyle.blue
        }
        
        cell.textLabel!.text = userDetails[indexPath.item] as String
        cell.textLabel!.textColor = purple
        cell.textLabel!.font = UIFont(name: "System", size: 20)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (userData! != currentUser) {
            print("touched")
            print(indexPath.row)
            print(userDetails[indexPath.item])
            
            //If user touched email address
            if indexPath.row == 4 {
                let mc: MFMailComposeViewController = MFMailComposeViewController()
                mc.mailComposeDelegate = self
                mc.setSubject("Your New Hitch Match!")
                mc.setMessageBody("Hey we just matched!", isHTML: false)
                mc.setToRecipients([(userDetails[indexPath.item])])
                self.present(mc, animated: true, completion: nil)
            }
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error:Error?) {
        switch result.rawValue {
        case MFMailComposeResultCancelled.rawValue:
            print("Mail cancelled")
        case MFMailComposeResultSaved.rawValue:
            print("Mail saved")
        case MFMailComposeResultSent.rawValue:
            print("Mail sent")
        case MFMailComposeResultFailed.rawValue:
            print("Mail sent failure: %@", [error!.localizedDescription])
        default:
            break
        }
        
        self.dismiss(animated: true, completion: nil)
    }

    func getAverageRating(_ usersObjectId : String) -> String? {
        let params = ["objectId" : usersObjectId]
        var rating: String?
        
        PFCloud.callFunction(inBackground: "averageRating", withParameters: params) { ( response, error) -> Void in
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
    
    func parallaxView(_ view: APParallaxView!, willChangeFrame frame: CGRect) {
        print("will change")
    }
    
    func parallaxView(_ view: APParallaxView!, didChangeFrame frame: CGRect) {
        print("did change")
    }

    
    
}

