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
import Material
import CoreData
import ASValueTrackingSlider


class SettingsViewController: UIViewController, SMSegmentViewDelegate {

    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var ageSlider: ASValueTrackingSlider!

    @IBAction func ageChanged(_ sender: ASValueTrackingSlider) {
        let defaults = UserDefaults.standard
        defaults.set(round(sender.value), forKey: "AgePreference")
    }
    
    // managedObjectContext - Managed object to work with objects (Facebook data) in CoreData
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
    var userName: String?
    var profileData = [UserProfileData]()
    var segmentView: SMSegmentView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let defaults = UserDefaults.standard
        
        self.addSideMenu(menuButton)

        // set UI elemtns for slider
        ageSlider.popUpViewWidthPaddingFactor = 1.5
        ageSlider.popUpViewHeightPaddingFactor = 1.5
        ageSlider.popUpViewArrowLength = 25
        ageSlider.popUpViewCornerRadius = 25
        ageSlider.setMaxFractionDigitsDisplayed(0)
        ageSlider.popUpViewColor = purple
        ageSlider.textColor = UIColor.white
        ageSlider.font = RobotoFont.mediumWithSize(50)
        
        //set value of slider
        if let agePreference = Int(defaults.string(forKey: "AgePreference")!) {
            ageSlider.setValue(Float(agePreference), animated: false)
        }
        else {
            ageSlider.setValue(46.5, animated: true)
        }

        fetchProfileData()
        
        let frame = UIScreen.main.bounds
        let segmentFrame = CGRect(x: frame.minX + 20,
            y: frame.minY + 750,
            width: frame.width - 40,
            height: 65.0)
        segmentView = SMSegmentView(frame: segmentFrame,
            separatorColour: purple,
            separatorWidth: 1.0,
            segmentProperties: [keySegmentTitleFont : UIFont.systemFont(ofSize: 21.0),
                keySegmentOnSelectionColour : UIColor.white,
                keySegmentOffSelectionColour : purple,
                keyContentVerticalMargin : 5.0 as AnyObject])
        
        segmentView.segmentOnSelectionTextColour = purple
        segmentView.segmentOffSelectionTextColour = UIColor.white
        segmentView.addSegmentWithTitle("Male", onSelectionImage: UIImage(named: "male-purple"), offSelectionImage: UIImage(named: "male-white"))
        segmentView.addSegmentWithTitle("Female", onSelectionImage: UIImage(named: "female-purple"), offSelectionImage: UIImage(named: "female-white"))
        segmentView.addSegmentWithTitle("Either", onSelectionImage: nil, offSelectionImage: nil)
        segmentView.delegate = self
        segmentView.layer.cornerRadius = 10.0
        segmentView.layer.borderColor = purple.cgColor
        segmentView.layer.borderWidth = 1.0
        
        //set value of gender seelctor
        if let genderPreference = defaults.string(forKey: "GenderPreference") {
            switch genderPreference {
            case "male":
                segmentView.selectSegmentAtIndex(0)
            case "female":
                segmentView.selectSegmentAtIndex(1)
            case "either":
                segmentView.selectSegmentAtIndex(2)
            default:
                segmentView.selectSegmentAtIndex(2)
            }
        }
        else {
            segmentView.selectSegmentAtIndex(2)
        }

        
        view.addSubview(segmentView)
        
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
        
        loginButton.addTarget(self, action: #selector(SettingsViewController.logOutOfFb(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        
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
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "UserProfileData")
        do {
            profileData = try (managedObjectContext.fetch(fetchRequest) as? [UserProfileData])!
            let userData = profileData[0]
            self.userName = userData.userName!
        }
            
        catch let error as NSError {
            print("Fetch failed: \(error.localizedDescription)")
        }
    }
    
    func logOutOfFb(_ sender: UIButton) {
        let loginManager = FBSDKLoginManager()
        loginManager.logOut() // this is an instance function
        
        //segue to loging screen
        let viewController = self.storyboard!.instantiateViewController(withIdentifier: "loginView") as UIViewController
        self.present(viewController, animated: true, completion: nil)
        
        //display logout message
        var murmur = Murmur(title: "\(userName!) logged out")
        show(whistle: murmur, action: .Show(0.5))
    }
    
    func segmentView(_ segmentView: SMBasicSegmentView, didSelectSegmentAtIndex index: Int) {
        let defaults = UserDefaults.standard
        switch index {
        case 0:
             defaults.set("male", forKey: "GenderPreference")
             print("male")
        case 1:
            defaults.set("female", forKey: "GenderPreference")
            print("female")
        case 2:
            defaults.set("either", forKey: "GenderPreference")
            print("either")
        default:
            defaults.set("either", forKey: "GenderPreference")
            print("either")
        }
    }
    
    

}

