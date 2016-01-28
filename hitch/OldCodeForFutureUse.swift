//
//  OldCodeForFutureUse.swift
//  hitch
//
//  Created by Toby Applegate on 07/01/2016.
//  Copyright © 2016 Toby Applegate. All rights reserved.
//

import Foundation

// From GoogleMapsVieController:

//func mapView(mapView: GMSMapView!, didTapInfoWindowOfMarker marker: GMSMarker!) 

//    func presentationController(controller: UIPresentationController, viewControllerForAdaptivePresentationStyle style: UIModalPresentationStyle) -> UIViewController? {
//        let btnDone = UIBarButtonItem(title: "Done", style: .Done, target: self, action: "dismiss")
//        let nav = UINavigationController(rootViewController: controller.presentedViewController)
//        nav.topViewController!.navigationItem.leftBarButtonItem = btnDone
//        return nav
//    }
//
//    func dismiss() {
//        self.dismissViewControllerAnimated(true, completion: nil)
//    }

//    func mapView(mapView: GMSMapView!, didTapMarker marker: GMSMarker!) -> Bool {
//
//        print("hello world")
//        return true
//    }

//    func pressed(sender: UIButton) {
//        print("hello")
//    }



// From MapViewController

//        let heightConstraint = NSLayoutConstraint(item: drivingToButton,
//            attribute: NSLayoutAttribute.Height,
//            relatedBy: NSLayoutRelation.Equal,
//            toItem: mapImage,
//            attribute: NSLayoutAttribute.Height,
//            multiplier: 0.33, constant: 0)
//        self.view.addConstraint(heightConstraint)
//
//        let widthConstraint = NSLayoutConstraint(item: drivingToButton,
//            attribute: NSLayoutAttribute.Width,
//            relatedBy: NSLayoutRelation.Equal,
//            toItem: mapImage,
//            attribute: NSLayoutAttribute.Width,
//            multiplier: 0.33, constant: 0)
//
//        self.view.addConstraint(widthConstraint)



// From UserAcccount()

//            let object = PFObject(className: "UserData")
//            object.setObject(self.userName!, forKey: "userName")
//            object.setObject(Int(self.userDOB!)!, forKey: "userAge")
//            object.setObject(self.userGender!, forKey: "userGender")
//            object.setObject(self.userEmail!, forKey: "userEmailAddress")
//            object.setObject(self.userEducation!, forKey: "userEducation")
//            object.saveInBackgroundWithBlock{ (succeeded: Bool, error: NSError?) -> Void in
//                if succeeded {
//                    print("Save successful")
//                } else {
//                    print("Save unsuccessful: \(error!.userInfo)")
//                    //was error?.userInfo, got rid of ? for ! to get rid of optional in consol
//                }
//            }



// From GoogleMapsViewController (in the extention part which deals with markers and routes and directions etc

// excecutes when user taps on marker
//    func mapView(mapView: GMSMapView!, didTapMarker marker: GMSMarker!) -> Bool {
////        let myFirstButton = UIButton()
////        myFirstButton.setTitle("✸", forState: .Normal)
////        myFirstButton.setTitleColor(UIColor.blueColor(), forState: .Normal)
////        myFirstButton.frame = CGRectMake(15, -50, 300, 500)
////        myFirstButton.addTarget(self, action: "pressed:", forControlEvents: .TouchUpInside)
////
////        self.view.addSubview(myFirstButton)
//        return true
//    }



// Presents custom window info box above marker
//func mapView(mapView: GMSMapView!, markerInfoWindow marker: GMSMarker!) -> UIView! {
//    //        if plottedByUser {
//    let infoWindow: CustomInfoWindow = NSBundle.mainBundle().loadNibNamed("CustomInfoWindow", owner: self, options: nil).first! as! CustomInfoWindow
//    infoWindow.frame.size.width = 200
//    infoWindow.frame.size.height = 50
//    
//    let drivingToButton: RaisedButton = RaisedButton(frame: CGRectMake(0, 0, 200, 50))
//    drivingToButton.setTitle("Drive or Hitch here..", forState: .Normal)
//    drivingToButton.setTitleColor(MaterialColor.white, forState: .Normal)
//    drivingToButton.titleLabel!.font = UIFont(name: "System", size: 7)
//    drivingToButton.backgroundColor = MaterialColor.deepPurple.base
//    
//    infoWindow.addSubview(drivingToButton)
//    
//    return infoWindow
//    
//}

//func mapView(mapView: GMSMapView!, didTapInfoWindowOfMarker marker: GMSMarker!) {
//    
//    if plottedByUser {
//        //            let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//        //            let popoverContent : PopoverViewController = storyboard.instantiateViewControllerWithIdentifier("HitchOrDriveHereView") as! PopoverViewController
//        //            let nav = UINavigationController(rootViewController: popoverContent)
//        //            nav.modalPresentationStyle = UIModalPresentationStyle.Popover
//        //            let popover = nav.popoverPresentationController
//        //            popoverContent.preferredContentSize = CGSizeMake(250,300)
//        //            popover!.delegate = self
//        //            popover!.sourceView = self.view
//        //            popover!.sourceRect = CGRectMake(100,100,0,0)
//        //            //popover!.delegate = self
//        //            popoverContent.delegate = self
//        //            plottedByUser = false
//        //            self.presentViewController(nav, animated: true, completion: nil)
//        //            marker.map = nil
//        //PopoverViewController.
//        performSegueWithIdentifier("segueToHitchOrDriveOption", sender: nil)
//        marker.map = nil
//        //print(marker.userData)
//        //segueToHitchOrDriveOption
//    }
//        
//    else if !plottedByUser {
//        userID = "\(marker.userData)"
//        performSegueWithIdentifier("segueToUsersProfile", sender: nil)
//    }
//}


//from profile data.swift

//import Foundation
//import CoreData
//
//class ProfileData: NSManagedObject {
//    
//    class func createInManagedObjectContext(moc: NSManagedObjectContext, userAge: String, userEducation: [String], userEmailAddress: String, userGender: String, userName: String) -> ProfileData {
//        
//        let newItem = NSEntityDescription.insertNewObjectForEntityForName("ProfileData", inManagedObjectContext: moc) as! ProfileData
//        newItem.userAge = userAge
//        newItem.userEducation = userEducation
//        newItem.userEmailAddress = userEmailAddress
//        newItem.userGender = userGender
//        newItem.userName = userName
//        //newItem.likeDate = likeDate
//        //newItem.pageLiked = pageLiked
//        
//        return newItem
//    }  
//}


//ffrom profiledara+coredataproperties.swfit

//
//  ProfileData+CoreDataProperties.swift
//
//
//  Created by Toby Applegate on 22/12/2015.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

//import Foundation
//import CoreData
//
//extension ProfileData {
//    
//    @NSManaged var userAge: String?
//    @NSManaged var userEducation: String?
//    @NSManaged var userEmailAddress: String?
//    @NSManaged var userGender: String?
//    @NSManaged var userName: String?
//    
//}


//class FacebookLoginViewController //for fb login button

// Function to load the Facebook login/logout button
//        func displayFBButton() {
//            let loginView : FBSDKLoginButton = FBSDKLoginButton()
//            self.view.addSubview(loginView)
//            loginView.center = self.view.center
//            loginView.readPermissions = ["public_profile", "email", "user_about_me", "user_birthday", "user_education_history", "user_location", "user_work_history"]
//
//            loginView.delegate = self
//            print("accessed displayFBButton()")
//        }
//
//        if (FBSDKAccessToken.currentAccessToken() != nil)
//        {
//            // User is already logged in, display logout button
//            displayFBButton()
//            let viewController = self.storyboard!.instantiateViewControllerWithIdentifier("homePage") as UIViewController
//            self.presentViewController(viewController, animated: true, completion: nil)
//        }
//        else
//        {
//            // User isn't logged in, sdisplay login button
//            displayFBButton()
//        }


// From popoverivewcontroller.swift file

// Adds back button (cancel) to view
//        let backButton:UIBarButtonItem = UIBarButtonItem(
//            title: "Cancel",
//            style: UIBarButtonItemStyle.Plain,
//            target: self,
//            action: "cancel:")
//
//        self.navigationItem.setLeftBarButtonItem(backButton, animated: true)

//NSUserDefaults.standardUserDefaults().setObject(longitude, forKey: "destinationLongitude")
//NSUserDefaults.standardUserDefaults().setObject(latitude, forKey: "destinationLatitude")
//
//// Origin + Destination Coords, need to change data passing between V/C's by using protocols
//let destinationLatitude:Double = NSUserDefaults.standardUserDefaults().objectForKey("destinationLatitude") as! Double
//let destinationLongitude:Double = NSUserDefaults.standardUserDefaults().objectForKey("destinationLongitude") as! Double
//let originLatitude:Double = NSUserDefaults.standardUserDefaults().objectForKey("originLatitude") as! Double
//let originLongitude:Double = NSUserDefaults.standardUserDefaults().objectForKey("originLongitude") as! Double


// from parseFBData.swift

//    // Function to obtain users name form Facebook profile
//    func getUserName(completion: (nameData: String?, error: NSError?) -> Void) {
//
//        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"first_name"])
//        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
//
//            if error != nil {
//                print("login error: \(error!.localizedDescription)")
//                return
//            }
//            else {
//                // Parses data using SwiftyJSON
//                let json = JSON(result)
//
//                //print(result)
//
//                let userName = json["first_name"].stringValue
//
//                // Use completion handler to return variables on completion
//                completion(nameData: userName, error: error)
//            }
//        })
//
//    }


// For retirving data from paarse
//From RetrieveDataFromBackEnd.swift

//retireve details from backend using parse object obtained from JS function in backend
//    func retrieveObjectFromPointer(userData : AnyObject, resultHandler: (userObject: [String:String]?) -> ()) {
//
//            var userDetails = [String: String]()
//            let users = userData as! [PFObject]
//
//            for user in users {
//                user.fetchIfNeededInBackgroundWithBlock {
//                    (users: PFObject?, error: NSError?) -> Void in
//                        print(users)
//                    let userGender = users!["userGender"]
//                    let userName = users!["userName"]
//                    let userEmail = users!["userEmailAddress"]
//                    resultHandler(userObject: userDetails)
//                    print(userGender)
//            }
//        }
//
//    }




//    // Retireves route's from users + info about each user
//    func retrieveMatchedRoutes(resultHandler: (matchedDict: [String: AnyObject]) -> ()) {
//
//        // Gets current logged in users objectId and uses that to compare retieved objects
//        let currentUser = PFUser.currentUser()?.valueForKey("objectId")
//        var routeAndUserObjects = [PFObject]()
//        let query = PFQuery(className:"UserRoutes")
//        var count = 0
//
//
//        // Retirves all routes from Parse
//        query.findObjectsInBackgroundWithBlock {
//            (objects: [PFObject]?, error: NSError?) -> Void in
//            if error == nil {
//                if let objects = objects {
//                    // Iterates through each PFObject in the query results
//                    for object in objects {
//                        let user = object.objectForKey("User")
//                        let userQuery = object["User"] as! PFObject
//
//                        // Querys FK in UserRoutes table and obtains user's details from who plotted the route
//                        userQuery.fetchIfNeededInBackgroundWithBlock {
//                            (users: PFObject?, error: NSError?) -> Void in
//                            let userName = user?["userName"]
//                            let userID = user!.valueForKey("objectId") //will act as objectID
//                            // if match isnt nil then get the value
//                            if let match = object.objectForKey("match") {
//                                // Check if match's objectId (as match = pointer to User object) = current logged in user
//                                if ("\(match.valueForKey("objectId")!)" == "\(currentUser!)") {
//                                    //print(count)
//                                    var routeDict = [String: AnyObject]()
//                                    var matchedDict = [String:[String: AnyObject]]()
//                                    let userRelation = PFObject(className: "UserRelations")
//                                    userRelation.setObject(object.objectForKey("DestinationLatitude")!, forKey: "DestinationLatitude")
//                                    userRelation.setObject(object.objectForKey("DestinationLongitude")!, forKey: "DestinationLongitude")
//                                    //userRelation.setObject(object.objectForKey("UserRoute")!, forKey: "UserRoute")
//                                    userRelation.setObject(object.objectForKey("UserType")!, forKey: "UserType")
//                                    userRelation.setObject(userName!, forKey: "UserName")
//                                    userRelation.setObject(object.objectForKey("TimeOfRoute")!, forKey: "TimeOfRoute")
//                                    userRelation.setObject(userID!, forKey: "UserID")
//                                    userRelation.setObject("\(match.valueForKey("objectId")!)", forKey: "match")
//
//                                    routeDict["DestinationLatitude"] = object.objectForKey("DestinationLatitude")!
//                                    routeDict["DestinationLongitude"] = object.objectForKey("DestinationLongitude")!
//                                    routeDict["UserType"] = object.objectForKey("UserType")!
//                                    routeDict["UserName"] = userName!
//                                    routeDict["TimeOfRoute"] = object.objectForKey("TimeOfRoute")!
//                                    routeDict["UserID"] = userID!
//                                    routeDict["match"] = match.valueForKey("objectId")!
//                                    matchedDict["\(count)"] = routeDict
//                                    count++
//                                    // Appends all the required info to PFOject array
//                                    routeAndUserObjects.append(userRelation)
//                                    resultHandler(matchedDict: routeDict)
//                                }
//
//                            }
//                        }
//                    }
//                }
//            } else {
//                // Log details of the failure
//                print("Error: \(error!) \(error!.userInfo)")
//            }
//        }
//    }
