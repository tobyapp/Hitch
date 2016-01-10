//
//  RouteCalculator.swift
//  hitch
//
//  Created by Toby Applegate on 10/01/2016.
//  Copyright © 2016 Toby Applegate. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class RouteCalculator {
    
    let baseURL = "https://maps.googleapis.com/maps/api/directions/json?"
    
    func getDirectionsFromCoords(originLongitude: Double, originLatitude: Double, destinationLongitude: Double, destinationLatitude: Double, resultHandler: (data: String?) -> ()) -> () {
        
        let requestURL = baseURL + "origin=" + "\(originLatitude),\(originLongitude)" + "&destination=" + "\(destinationLatitude),\(destinationLongitude)" + "&key=" + "AIzaSyBZM-uX4YyOaMd5Fpas8EPBG-zq_T2kRq8"

        
        Alamofire.request(.GET, requestURL, parameters: nil).responseJSON { response in
            switch response.result {
                
            case .Success(let data):
                let json = JSON(data)
                let errornum = json["error"]
            
                if (errornum == true) {
                    
                    print("error with \(errornum)")
                    
                } else {
                    let routes = json["routes"].array
                    //print(routes)
                    if routes != nil{
                        let overViewPolyLine = routes![0]["overview_polyline"]["points"].string
                        if overViewPolyLine != nil{
                            resultHandler(data: overViewPolyLine)
                        //NSUserDefaults.standardUserDefaults().setObject(overViewPolyLine, forKey: "polyLines")
                    
                        }
                    }
                }
                
            case .Failure(let error):
                print("Request failed with error: \(error)")
            }
        }
    }
 
//    func convertCoordsToLocation(coordLocation: CLLocation) {
//        
//        CLGeocoder().reverseGeocodeLocation(coordLocation, completionHandler: {(readableLocation, error) -> Void in
//            print(coordLocation)
//            
//            if error != nil {
//                print("Reverse geocoder failed with error" + error!.localizedDescription)
//                return
//            }
//            
//            if readableLocation!.count > 0 {
//                let rl = readableLocation![0]
//                print(rl.locality)
//                print(rl)
//                
//                // Use completion handler to return variables on completion
//                //completionHandler(readableLocation, error)
//            }
//                
//            else {
//                print("Problem with the data received from geocoder")
//            }
//        })
//
//    }
//    
//    func getDirectionsFromAddress() {
//        
//    }
//    
//    
}