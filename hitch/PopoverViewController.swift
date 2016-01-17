//
//  PopoverViewController.swift
//  hitch
//
//  Created by Toby Applegate on 07/01/2016.
//  Copyright © 2016 Toby Applegate. All rights reserved.
//

import UIKit
import MK

// Once user searches for point on map and selects it, this view will 'pop up' with option to either drive to the point, want to hitch to the point or cancel and go back to GoogleMapsViewController

class PopoverViewController: UIViewController {
 
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBAction func datePickerAction(sender: AnyObject) {
        let currentDate = NSDate()
        datePicker.minimumDate = currentDate.dateByAddingTimeInterval(60)
        datePicker.maximumDate = currentDate.dateByAddingTimeInterval(259200)
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "HH:mm - dd/MM/yyyy"
        let dateString = dateFormatter.stringFromDate(datePicker.date)
        self.dateString = dateString
    }
    
    var dateString : String?
    var routeCalc = RouteCalculator()
    var delegate : SendDataBackProtocol?
    var destinationLongitude : Double?
    var destinationLatitude : Double?
    var originLongitude : Double?
    var originLatitude : Double?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        datePicker.setValue(purple, forKey: "textColor")
        // Changes colour scheme to purple to match rest of app, see class extentions for more details
        changeColorScheme()
        
        // Adds driving to button to view
        let drivingToButton: RaisedButton = RaisedButton(frame: CGRectMake(110, 400, 200, 30))
        drivingToButton.setTitle("I'm driving to..", forState: .Normal)
        drivingToButton.setTitleColor(MaterialColor.white, forState: .Normal)
        drivingToButton.titleLabel!.font = UIFont(name: "System", size: 15)
        drivingToButton.addTarget(self, action: "drivingTo:", forControlEvents: UIControlEvents.TouchUpInside)
        drivingToButton.backgroundColor = MaterialColor.deepPurple.base
        view.addSubview(drivingToButton)
        
        // Adds Hitch button to view
        let hitchinToButton: RaisedButton = RaisedButton(frame: CGRectMake(110, 600, 200, 30))
        hitchinToButton.setTitle("I'm Hitch'n to..", forState: .Normal)
        hitchinToButton.setTitleColor(MaterialColor.white, forState: .Normal)
        hitchinToButton.titleLabel!.font = UIFont(name: "System", size: 15)
        hitchinToButton.addTarget(self, action: "hitchTo:", forControlEvents: UIControlEvents.TouchUpInside)
        hitchinToButton.backgroundColor = MaterialColor.deepPurple.base
        view.addSubview(hitchinToButton)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Go back to previous VC (google maps vc)
    func cancel() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    // calculate route and return this to previous vc along with user type (driver)
    func drivingTo(sender: UIButton) {
        
        // If user does not change date then its nil as they have not interacted with it (so therefor will be nil), this changes that to current time
        if self.dateString == nil {
            let currentDate = NSDate()
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "HH:mm - dd/MM/yyyy"
           dateFormatter.stringFromDate(currentDate)
            let dateString = dateFormatter.stringFromDate(currentDate)
            self.dateString = dateString
        }
        
        routeCalc.getDirectionsFromCoords(originLongitude!, originLatitude: originLatitude!, destinationLongitude: destinationLongitude!, destinationLatitude: destinationLatitude!, resultHandler: {results in
            self.delegate?.sendRouteBack(results!, userType: "driver", destinationLatitude: self.destinationLatitude!, destinationLongitude: self.destinationLongitude!, timeOfRoute: self.dateString!)
            self.cancel()
        })
    }
    
    // calculate route and return this to previous vc along with user type (hitcher)
    func hitchTo(sender: UIButton) {
        
        // If user does not change date then its nil as they have not interacted with it (so therefor will be nil), this changes that to current time
        if self.dateString == nil {
            let currentDate = NSDate()
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "HH:mm - dd/MM/yyyy"
            dateFormatter.stringFromDate(currentDate)
            let dateString = dateFormatter.stringFromDate(currentDate)
            self.dateString = dateString
        }
        
        routeCalc.getDirectionsFromCoords(originLongitude!, originLatitude: originLatitude!, destinationLongitude: destinationLongitude!, destinationLatitude: destinationLatitude!, resultHandler: {results in
            self.delegate?.sendRouteBack(results!, userType: "hitcher", destinationLatitude: self.destinationLatitude!, destinationLongitude: self.destinationLongitude!, timeOfRoute: self.dateString!)
            self.cancel()
        })
    }
    
}
