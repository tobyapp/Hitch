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