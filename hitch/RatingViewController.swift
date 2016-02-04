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
import Parse

class RatingViewController: UIViewController {

    @IBOutlet weak var displayPicture: UIImageView!
    @IBOutlet weak var starRating: CosmosView!
    @IBOutlet weak var ratingMessage: UILabel!
    
    
    private var rating: Double?
    var objectId: String?
    var routeId: String?
    var uploadData = UploadDataToBackEnd()
    var retrieveData = RetrieveDataFromBackEnd()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getAverageRating(objectId!)
        
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

        //get details of user, set these to global array then reload table view to show these
        if let objectId = objectId {
            retrieveData.retrieveUserDetails(objectId, resultHandler: ({results in
                self.ratingMessage.text! = "Rate \(results["userName"]!) on your trip!"
               
                if let picture = results["userDisplayPicture"] as! UIImage? {
                    self.displayPicture.image = picture
                }
            }))
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func didFinishTouchingCosmos(userRating: Double){
        rating = userRating
    }

    func rate(sender: UIButton) {
        
        navigationController?.popViewControllerAnimated(true)
        if let rating = rating {
            uploadData.userReviewed(routeId!, userId: objectId!)
            uploadData.addRating(rating, userReviewed: objectId!)
            
            print("user :   \(objectId!)   on  route   :   \(routeId!)")

        }
        else {
            uploadData.userReviewed(routeId!, userId: objectId!)
            uploadData.addRating(2.5, userReviewed: objectId!)
        }
    }
    
    func getAverageRating(usersObjectId : String){
        let params = ["objectId" : usersObjectId]
        PFCloud.callFunctionInBackground("averageRating", withParameters: params) { ( response, error) -> Void in
            
            if response != nil {
                if error == nil {
                        print("rating is : \(response!)")
                }
                else {
                    print(error)
                }
            }
            else {
                print("no repsonse")
            }
        }
    }
    
    
    
}

