//
//  ClassExtentions.swift
//  hitch
//
//  Created by Toby Applegate on 21/12/2015.
//  Copyright © 2015 Toby Applegate. All rights reserved.
//

import Foundation
import MK

// Edits description of error to display constraint id
extension NSLayoutConstraint {
    
    override public var description: String {
        let id = identifier ?? ""
        return "id: \(id), constant: \(constant)"
    }
}

// Add side menu to view controllers
extension UIViewController {
    var purple: UIColor {
        return UIColor(red: 103/255, green: 58/255, blue: 183/255, alpha: 1)
    }
    // Adds side menu to view controllers
    func addSideMenu(menuButton : UIBarButtonItem!) {
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            self.revealViewController().rearViewRevealWidth = CGFloat(200)
            self.revealViewController().frontViewShadowRadius = CGFloat(50)
            self.revealViewController().frontViewShadowOffset = CGSizeMake(CGFloat(0), CGFloat(5))
            self.revealViewController().frontViewShadowOpacity = CGFloat(1)
            self.revealViewController().frontViewShadowColor = UIColor.darkGrayColor()
            changeColorScheme()
        }
    }
    
    func changeColorScheme(){
        self.navigationController?.navigationBar.barTintColor = purple
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.navigationController?.navigationBar.barStyle = UIBarStyle.Black
    }
    
    func runCodeAfterDelay(delay: NSTimeInterval, block: dispatch_block_t) {
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay * Double(NSEC_PER_SEC)))
        dispatch_after(time, dispatch_get_main_queue(), block)
    }
    
}

protocol SendDataBackProtocol {
    
    func sendRouteBack(route : String, userType: String, originLatitude: Double, originLongitude: Double, destinationLatitude: Double, destinationLongitude: Double, timeOfRoute: String)
    
}

