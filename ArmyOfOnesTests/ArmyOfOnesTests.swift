//
//  ArmyOfOnesTests.swift
//  ArmyOfOnesTests
//
//  Created by Bryan Bolivar Martinez on 4/29/15.
//  Copyright (c) 2015 Bryan Bolivar Martinez. All rights reserved.
//

import UIKit
import XCTest
import CoreData
class ArmyOfOnesTests: XCTestCase {
    var currency: Currency!
    var viewController: ViewController!
    override func setUp() {
        super.setUp()
        self.currency = Currency()
        self.viewController = ViewController()
    }
    override func tearDown() {
        super.tearDown()
    }
    func testExample() {
        XCTAssert(true, "Pass")
    }
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }
  
    func testThatCurrencyExtendendsFromNSManagedObject(){
        XCTAssertTrue(self.currency.isKindOfClass(NSManagedObject), "Currency Class should be of type NSManagedObject")
    }
    
    func testCurrentDateEqualsTodayDate(){
        let date = NSDate()
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MMM/dd/yyyy hh:mm"
        var dateString = dateFormatter.stringFromDate(date)
        XCTAssertEqual(dateString, viewController.dateToString(), "Dates Should be the same")
    }
    
    func testThatDollarToDollarConversionEqualsOne(){
        XCTAssertTrue(viewController.makeConversionFromDollars(1, currency: 1) == 1 , "1 Dollar to dollar conversion should be 1")
    }
}
