//
//  ClassExtentions.swift
//  hitch
//
//  Created by Toby Applegate on 21/12/2015.
//  Copyright © 2015 Toby Applegate. All rights reserved.
//

import Foundation
import Material

// Edits description of error to display constraint id
extension NSLayoutConstraint {
    
    override open var description: String {
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
    func addSideMenu(_ menuButton : UIBarButtonItem!) {
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = Selector(("revealToggle:"))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            self.revealViewController().rearViewRevealWidth = CGFloat(200)
            self.revealViewController().frontViewShadowRadius = CGFloat(50)
            self.revealViewController().frontViewShadowOffset = CGSize(width: CGFloat(0), height: CGFloat(5))
            self.revealViewController().frontViewShadowOpacity = CGFloat(1)
            self.revealViewController().frontViewShadowColor = UIColor.darkGray
            changeColorScheme()
        }
    }
    
    func changeColorScheme(){
        self.navigationController?.navigationBar.barTintColor = purple
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        self.navigationController?.navigationBar.barStyle = UIBarStyle.black

    }
    
    func runCodeAfterDelay(_ delay: TimeInterval, block: @escaping ()->()) {
        let time = DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: time, execute: block)
    }
    
}

protocol SendDataBackProtocol {
    
    func sendRouteBack(_ route : String, userType: String, originLatitude: Double, originLongitude: Double, destinationLatitude: Double, destinationLongitude: Double, timeOfRoute: String, extraRideInfo: String)
    
}

extension String {
    var length: Int {
        return characters.count
    }
    
    func toBool() -> Bool{
        if (self == "1" || self == "true" || self == "True" || self == "Yes" || self == "yes" || self == "on" || self == "On") {
            return true
        } else{
            return false
        }
    }

}

extension Double {
    func format(_ f: String) -> String {
        return String(format: "%.3f", f)
    }
}


//struct agePreferences {
//    
//    var agePreference : Int
//    
//    init(setAgePreference agePreference: Int){
//        self.agePreference = agePreference
//    }
//}
//
//struct genderPreferences {
//    
//    var genderPreference : String
//    
//    init(setGenderPreference genderPreference: String){
//        self.genderPreference = genderPreference
//    }
//}


