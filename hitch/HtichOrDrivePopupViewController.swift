//
//  PopoverViewController.swift
//  hitch
//
//  Created by Toby Applegate on 07/01/2016.
//  Copyright © 2016 Toby Applegate. All rights reserved.
//

import UIKit
import Material
import JVFloatLabeledTextField

// Once user searches for point on map and selects it, this view will 'pop up' with option to either drive to the point, want to hitch to the point or cancel and go back to GoogleMapsViewController

class HtichOrDrivePopupViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate {
 
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var textField: JVFloatLabeledTextField!
    
    @IBAction func datePickerAction(_ sender: AnyObject) {
        let currentDate = Date()
        datePicker.minimumDate = currentDate.addingTimeInterval(60)
        datePicker.maximumDate = currentDate.addingTimeInterval(259200)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm - dd/MM/yyyy"
        let dateString = dateFormatter.string(from: datePicker.date)
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
        textField.delegate = self
        
        // Changes colour scheme to purple to match rest of app, see class extentions for more details
        changeColorScheme()
        
        // Adds driving to button to view
        let drivingToButton: RaisedButton = RaisedButton(frame: CGRectMake(185, 600, 400, 60)) //CGRectMake(110, 400, 200, 30)
        drivingToButton.setTitle("I'm driving to..", forState: .Normal)
        drivingToButton.setTitleColor(MaterialColor.white, forState: .Normal)
        drivingToButton.titleLabel!.font = RobotoFont.mediumWithSize(20) //UIFont(name: "System", size: 15)
        drivingToButton.addTarget(self, action: #selector(HtichOrDrivePopupViewController.drivingTo(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        drivingToButton.backgroundColor = MaterialColor.deepPurple.base
        view.addSubview(drivingToButton)
        
        // Adds Hitch button to view
        let hitchinToButton: RaisedButton = RaisedButton(frame: CGRectMake(185, 800, 400, 60)) //CGRectMake(110, 400, 200, 30)
        hitchinToButton.setTitle("I'm Hitch'n to..", forState: .Normal)
        hitchinToButton.setTitleColor(MaterialColor.white, forState: .Normal)
        hitchinToButton.titleLabel!.font = RobotoFont.mediumWithSize(20) //UIFont(name: "System", size: 15)
        hitchinToButton.addTarget(self, action: #selector(HtichOrDrivePopupViewController.hitchTo(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        hitchinToButton.backgroundColor = MaterialColor.deepPurple.base
        view.addSubview(hitchinToButton)
        
        // Create notifications on when keyboard is displayed/hidden
        NotificationCenter.default.addObserver(self, selector: #selector(HtichOrDrivePopupViewController.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(HtichOrDrivePopupViewController.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func addPlaceHolderText(_ textField: UITextField, placeholderText: String) {
        // make it look (initially) like a placeholder
        textField.textColor = UIColor.lightGray
        textField.text = placeholderText
    }
    
    func textViewShouldBeginEditing(_ aTextView: UITextView) -> Bool {
        if textField.text != nil {
            textField.text = ""
            textField.textColor = purple
            print("began")
        }
        return true
    }
    
    // To dismiss keyboard when users finished typing
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //self.view.endEditing(true)
        textField.resignFirstResponder()
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Go back to previous VC (google maps vc)
    func cancel() {
        self.navigationController?.popViewController(animated: true)
    }
    
    // calculate route and return this to previous vc along with user type (driver)
    func drivingTo(_ sender: UIButton) {
        
        // If user does not change date then its nil as they have not interacted with it (so therefor will be nil), this changes that to current time
        if self.dateString == nil {
            let currentDate = Date()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm - dd/MM/yyyy"
           dateFormatter.string(from: currentDate)
            let dateString = dateFormatter.string(from: currentDate)
            self.dateString = dateString
        }
        
        
        routeCalc.getDirectionsFromCoords(originLongitude!, originLatitude: originLatitude!, destinationLongitude: destinationLongitude!, destinationLatitude: destinationLatitude!, resultHandler: {results in
            if self.textField.text == "Enter your extra information for your ride here..." {
                self.textField.text = ""
            }
            self.delegate?.sendRouteBack(results!, userType: "driver", originLatitude: self.originLatitude!, originLongitude: self.originLongitude!, destinationLatitude: self.destinationLatitude!, destinationLongitude: self.destinationLongitude!, timeOfRoute: self.dateString!, extraRideInfo : self.textField.text!)
            self.cancel()
        })
    }
    
    // calculate route and return this to previous vc along with user type (hitcher)
    func hitchTo(_ sender: UIButton) {
        
        // If user does not change date then its nil as they have not interacted with it (so therefor will be nil), this changes that to current time
        if self.dateString == nil {
            let currentDate = Date()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm - dd/MM/yyyy"
            dateFormatter.string(from: currentDate)
            let dateString = dateFormatter.string(from: currentDate)
            self.dateString = dateString
        }
        
        routeCalc.getDirectionsFromCoords(originLongitude!, originLatitude: originLatitude!, destinationLongitude: destinationLongitude!, destinationLatitude: destinationLatitude!, resultHandler: {results in
            if self.textField.text == "Enter your extra information for your ride here..." {
                self.textField.text = ""
            }
            self.delegate?.sendRouteBack(results!, userType: "hitcher", originLatitude: self.originLatitude!, originLongitude: self.originLongitude!, destinationLatitude: self.destinationLatitude!, destinationLongitude: self.destinationLongitude!, timeOfRoute: self.dateString!, extraRideInfo : self.textField.text!)
            self.cancel()
        })
    }
    
    //Move UIView up when keyboard is displayed (shown)
    func keyboardWillShow(_ notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            self.view.frame.origin.y -= keyboardSize.height
        }
        
    }
    
    //Move UIView down when keyboard is retracted (hidden)
    func keyboardWillHide(_ notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            self.view.frame.origin.y += keyboardSize.height
        }
    }
}
