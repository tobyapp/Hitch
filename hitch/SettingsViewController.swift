//
//  SettingsViewController.swift
//  hitch
//
//  Created by Toby Applegate on 30/12/2015.
//  Copyright © 2015 Toby Applegate. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import Whisper
import Parse
import ParseFacebookUtilsV4
import MK
import CoreData
import ASValueTrackingSlider
//import SMSegmentView


class SettingsViewController: UIViewController, SMSegmentViewDelegate {

    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var ageSlider: ASValueTrackingSlider!

    @IBAction func ageChanged(sender: ASValueTrackingSlider) {
        print(round(sender.value))
    }
    
    // managedObjectContext - Managed object to work with objects (Facebook data) in CoreData
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    var userName: String?
    var profileData = [UserProfileData]()
    var segmentView: SMSegmentView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addSideMenu(menuButton)

        // set UI elemtns for slider
        ageSlider.popUpViewWidthPaddingFactor = 1.5
        ageSlider.popUpViewHeightPaddingFactor = 1.5
        ageSlider.popUpViewArrowLength = 25
        ageSlider.popUpViewCornerRadius = 25
        ageSlider.setMaxFractionDigitsDisplayed(0)
        ageSlider.popUpViewColor = purple
        ageSlider.textColor = UIColor.whiteColor()
        ageSlider.font = RobotoFont.mediumWithSize(50)
        
        fetchProfileData()
        
        let segmentFrame = CGRect(x: 10.0, y: 50.0, width: 300.0, height: 40.0)
        segmentView = SMSegmentView(frame: segmentFrame,
            separatorColour: UIColor.blueColor(),
            separatorWidth: 1.0,
            segmentProperties: ["keySegmentTitleFont" : UIFont.systemFontOfSize(12.0),
                "keySegmentOnSelectionColour" : UIColor.blackColor(),
                "keySegmentOffSelectionColour" : UIColor.greenColor(),
                "keyContentVerticalMargin" : 5.0])
        
        segmentView.addSegmentWithTitle("1", onSelectionImage: nil, offSelectionImage: nil)
        segmentView.addSegmentWithTitle("2", onSelectionImage: nil, offSelectionImage: nil)
        segmentView.addSegmentWithTitle("3", onSelectionImage: nil, offSelectionImage: nil)
        
        segmentView.delegate = self
        
        // Create custom logout button for facebook
        let cardView: CardView = CardView()
        cardView.dividerInset.left = 0 // White line seperating loging button with text
        cardView.titleLabelInset.left = 150 // Top line of text
        cardView.detailLabelInset.left = 150 // Bottom line of text
        cardView.backgroundColor  = MaterialColor.deepPurple.base
        cardView.pulseColor = nil
        cardView.pulseFill = false
        cardView.pulseScale = false
        
        // Image.
        cardView.image = UIImage(named: "facebook-purple")
        cardView.contentsGravity = .TopLeft
        
        // Title label.
        let titleLabel: UILabel = UILabel()
        titleLabel.text = "Log Out"
        titleLabel.font = RobotoFont.mediumWithSize(24)
        titleLabel.textColor = MaterialColor.white
        cardView.titleLabel = titleLabel
        
        // Detail label.
        let detailLabel: UILabel = UILabel()
        detailLabel.text = "Click the button to logout of Hitch!"
        detailLabel.font = RobotoFont.mediumWithSize(20)
        detailLabel.textColor = MaterialColor.white
        detailLabel.numberOfLines = 0
        cardView.detailLabel = detailLabel
        
        // LEARN MORE button.
        let loginButton: RaisedButton = RaisedButton()
        loginButton.pulseColor = MaterialColor.deepPurple.base
        loginButton.pulseFill = true
        loginButton.pulseScale = true
        loginButton.setTitle("Log Out", forState: .Normal)
        loginButton.backgroundColor = MaterialColor.white
        loginButton.setTitleColor(MaterialColor.deepPurple.base, forState: .Normal)
        
        // Add buttons to right side.
        cardView.rightButtons = [loginButton]
        
        loginButton.addTarget(self, action: "logOutOfFb:", forControlEvents: UIControlEvents.TouchUpInside)
        
        // To support orientation changes, use MaterialLayout.
        view.addSubview(cardView)
        cardView.translatesAutoresizingMaskIntoConstraints = false
        MaterialLayout.alignFromTop(view, child: cardView, top: 100)
        MaterialLayout.alignToParentHorizontally(view, child: cardView, left: 20, right: 20)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func fetchProfileData() {
        let fetchRequest = NSFetchRequest(entityName: "UserProfileData")
        do {
            profileData = try (managedObjectContext.executeFetchRequest(fetchRequest) as? [UserProfileData])!
            let userData = profileData[0]
            self.userName = userData.userName!
        }
            
        catch let error as NSError {
            print("Fetch failed: \(error.localizedDescription)")
        }
    }
    
    func logOutOfFb(sender: UIButton) {
        let loginManager = FBSDKLoginManager()
        loginManager.logOut() // this is an instance function
        
        //segue to loging screen
        let viewController = self.storyboard!.instantiateViewControllerWithIdentifier("loginView") as UIViewController
        self.presentViewController(viewController, animated: true, completion: nil)
        
        //display logout message
        var murmur = Murmur(title: "\(userName!) logged out")
        murmur.duration = 100.0
        Whistle(murmur)
    }
    
    func segmentView(segmentView: SMSegmentView, didSelectSegmentAtIndex index: Int) {
        print(index)
    }
    

}
