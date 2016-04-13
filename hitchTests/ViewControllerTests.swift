//
//  ViewControllerTests.swift
//  
//
//  Created by Toby Applegate on 28/02/2016.
//
//

import XCTest
@testable import hitch

class ViewControllerTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
//    func testExample() {
//        // This is an example of a functional test case.
//        // Use XCTAssert and related functions to verify your tests produce the correct results.
//    }
//    
//    func testPerformanceExample() {
//        // This is an example of a performance test case.
//        self.measureBlock {
//            // Put the code you want to measure the time of here.
//        }
//    }
    
    func testViewControllers() {
        
        let vcTestArray = [MenuTableViewController(), UserRoutesViewController(), RatingViewController(), ContactViewController(), FAQViewController(), SettingsViewController(), ProfileTableViewController(), FacebookLoginViewController(), FilterSelectionViewController(), HitcherDriverTableViewController(), HtichOrDrivePopupViewController(), GoogleMapsViewController(), MapViewController()]
        
        for vc in vcTestArray {
            XCTAssertNotNil(vc.view, "\(vc) did not load for ViewController")
            print("")
            print("DONE")
            print("")
        }
    }
    
}
