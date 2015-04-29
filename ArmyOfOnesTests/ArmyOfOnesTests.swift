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
    override func setUp() {
        super.setUp()
        self.currency = Currency()
        self.currency.value = 1
        self.currency.country = ""
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
    func testThatDollarCurrencyEqualsOne(){
        XCTAssertTrue(self.currency.convertToCurrency(.USD, andValue:1) == 1, "Convert 1 dollar to dollar should be 1")
    }
    
    func testThatCurrencyExtendendsFromNSManagedObject(){
        XCTAssertTrue(self.currency.isKindOfClass(NSManagedObject), "Currency Class should be of type NSManagedObject")
    }
    
    func testThatSaveCurrencyDoesNotAcceptNilValues(){
        
        XCTAssertFalse(currency.save(), "Currency should not accept nil or empty values")
    }
    
}
