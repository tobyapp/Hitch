//
//  PopoverViewController.swift
//  hitch
//
//  Created by Toby Applegate on 07/01/2016.
//  Copyright © 2016 Toby Applegate. All rights reserved.
//

import UIKit
import MK

class PopoverViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let drivingToButton: RaisedButton = RaisedButton(frame: CGRectMake(110, 200, 200, 30))
        drivingToButton.setTitle("I'm driving to..", forState: .Normal)
        drivingToButton.setTitleColor(MaterialColor.white, forState: .Normal)
        drivingToButton.titleLabel!.font = UIFont(name: "System", size: 15)
        drivingToButton.addTarget(self, action: "exampleAction:", forControlEvents: UIControlEvents.TouchUpInside)
        drivingToButton.backgroundColor = MaterialColor.deepPurple.base
        view.addSubview(drivingToButton)
        
        let hitchinToButton: RaisedButton = RaisedButton(frame: CGRectMake(110, 400, 200, 30))
        hitchinToButton.setTitle("I'm Hitch'n to..", forState: .Normal)
        hitchinToButton.setTitleColor(MaterialColor.white, forState: .Normal)
        hitchinToButton.titleLabel!.font = UIFont(name: "System", size: 15)
        hitchinToButton.addTarget(self, action: "exampleAction:", forControlEvents: UIControlEvents.TouchUpInside)
        hitchinToButton.backgroundColor = MaterialColor.deepPurple.base
        view.addSubview(hitchinToButton)

        // Do any additional setup after loading the view.
        
        let cancelButton: RaisedButton = RaisedButton(frame: CGRectMake(110, 400, 200, 30))
        cancelButton.setTitle("Cancel", forState: .Normal)
        cancelButton.setTitleColor(MaterialColor.white, forState: .Normal)
        cancelButton.titleLabel!.font = UIFont(name: "System", size: 15)
        cancelButton.addTarget(self, action: "cancel:", forControlEvents: UIControlEvents.TouchUpInside)
        cancelButton.backgroundColor = MaterialColor.deepPurple.base
        view.addSubview(hitchinToButton)
        
        // Menu button.
        let menuImage: UIImage? = UIImage(named: "menu")        
        let backButton: FlatButton = FlatButton()
        backButton.pulseColor = MaterialColor.white
        backButton.pulseFill = true
        backButton.pulseScale = true
        backButton.setImage(menuImage, forState: .Normal)
        backButton.setImage(menuImage, forState: .Highlighted)
        backButton.frame = CGRectMake(0, 0, 55, 44)
        backButton.tintColor = UIColor.whiteColor()
        backButton.addTarget(self.revealViewController(), action: "cancel:", forControlEvents: UIControlEvents.TouchUpInside)
        //        menuButton.target = self.revealViewController()
        //        menuButton.action = "revealToggle:"
        
        
        let item1 = UIBarButtonItem()
        item1.customView = backButton
        self.navigationItem.leftBarButtonItem = item1

        
        
        self.navigationController?.navigationBar.barTintColor = purple
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.navigationController?.navigationBar.barStyle = UIBarStyle.Black
    }

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func exampleAction(sender: UIButton){
        print("In exampleAction")
    }

    func cancel(sender: FlatButton){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}
