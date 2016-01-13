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