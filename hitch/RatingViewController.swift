//
//  RatingViewController.swift
//  hitch
//
//  Created by Toby Applegate on 28/01/2016.
//  Copyright © 2016 Toby Applegate. All rights reserved.
//

import UIKit
import Cosmos
import Material
import Parse

class RatingViewController: UIViewController {

    @IBOutlet weak var displayPicture: UIImageView!
    @IBOutlet weak var starRating: CosmosView!
    @IBOutlet weak var ratingMessage: UILabel!
    
    
    fileprivate var rating: Double?
    var objectId: String?
    var routeId: String?
    var uploadData = UploadDataToBackEnd()
    var retrieveData = RetrieveDataFromBackEnd()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Cosmos star rating config
        starRating.rating = 2.5
        starRating.settings.minTouchRating = 0
        starRating.didFinishTouchingCosmos = didFinishTouchingCosmos
        
        let rateButton: RaisedButton = RaisedButton(frame: CGRect(x: 185, y: 700, width: 414, height: 60)) //CGRectMake(300, 475, 200, 30))
        rateButton.setTitle("Rate!", for: .normal)
        rateButton.setTitleColor(Color.white, for: .normal)
        rateButton.titleLabel!.font = RobotoFont.medium(with: 20)//.mediumWithSize(20) //UIFont(name: "System", size: 15)
        rateButton.addTarget(self, action: #selector(RatingViewController.rate(_:)), for: UIControlEvents.touchUpInside)
        rateButton.backgroundColor = Color.deepPurple.base
        view.addSubview(rateButton)

        //get details of user, set these to global array then reload table view to show these
        if let objectId = objectId {
            retrieveData.retrieveUserDetails(objectId, resultHandler: ({results in
                self.ratingMessage.text! = "Rate \(results["userName"]!) on your trip!"
                self.ratingMessage.textColor = self.purple
               
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
    
    func didFinishTouchingCosmos(_ userRating: Double){
        rating = userRating
    }

    func rate(_ sender: UIButton) {
        
        navigationController?.popViewController(animated: true)
        if let rating = rating {
            uploadData.userReviewed(routeId!, userId: objectId!)
            uploadData.addRating(rating, userReviewed: objectId!)
        }
        else {
            uploadData.userReviewed(routeId!, userId: objectId!)
            uploadData.addRating(2.5, userReviewed: objectId!)
        }
    }
    
    
}

