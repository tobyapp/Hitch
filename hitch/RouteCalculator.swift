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
    
    let keys = APIkeys()
    let baseURL = "https://maps.googleapis.com/maps/api/directions/json?"
    
    func getDirectionsFromCoords(_ originLongitude: Double, originLatitude: Double, destinationLongitude: Double, destinationLatitude: Double, resultHandler: @escaping (_ directions: String?) -> ()) -> () {
        
        let requestURL = baseURL + "origin=" + "\(originLatitude),\(originLongitude)" + "&destination=" + "\(destinationLatitude),\(destinationLongitude)" + "&key=" + keys.googlePlacesAPIKey
        
        Alamofire.request(requestURL).responseJSON { response in
            switch response.result {
                
            case .success(let data):
                let json = JSON(data)
                let errornum = json["error"]
            
                if (errornum == true) {
                    
                    print("error with \(errornum)")
                    
                }
                
                else {
                    let routes = json["routes"].array
                    let status = json["status"]
                    
                    if routes != nil{
                        if status != "ZERO_RESULTS" {
                        let overViewPolyLine = routes![0]["overview_polyline"]["points"].string
                        if overViewPolyLine != nil{
                            resultHandler(overViewPolyLine)
                            }
                        }
                            
                        else {
                            print("ROUTE ERROR : \(status)")
                            resultHandler("No directions found")
                            return
                        }
                    }
                }
                
            case .failure(let error):
                print("Request failed with error: \(error)")
            }
        }
    } 
}
