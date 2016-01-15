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

