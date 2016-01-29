//
//  RatingViewController.swift
//  hitch
//
//  Created by Toby Applegate on 28/01/2016.
//  Copyright © 2016 Toby Applegate. All rights reserved.
//

import UIKit
import Cosmos
import MK

class RatingViewController: UIViewController {

    @IBOutlet weak var starRating: CosmosView!
    private var rating: Double?
    var objectId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Cosmos star rating config
        starRating.rating = 2.5
        starRating.settings.minTouchRating = 0
        starRating.didFinishTouchingCosmos = didFinishTouchingCosmos
        
        let rateButton: RaisedButton = RaisedButton(frame: CGRectMake(185, 700, 414, 60)) //CGRectMake(300, 475, 200, 30))
        rateButton.setTitle("Rate!", forState: .Normal)
        rateButton.setTitleColor(MaterialColor.white, forState: .Normal)
        rateButton.titleLabel!.font = RobotoFont.mediumWithSize(20) //UIFont(name: "System", size: 15)
        rateButton.addTarget(self, action: "rate:", forControlEvents: UIControlEvents.TouchUpInside)
        rateButton.backgroundColor = MaterialColor.deepPurple.base
        view.addSubview(rateButton)

    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func didFinishTouchingCosmos(userRating: Double){
        rating = userRating
        print(rating!)
        print(objectId)
    }

    func rate(sender: UIButton) {
        navigationController?.popViewControllerAnimated(true)
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
