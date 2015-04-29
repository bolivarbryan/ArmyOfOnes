//
//  Currency.swift
//  ArmyOfOnes
//
//  Created by Bryan Bolivar Martinez on 4/29/15.
//  Copyright (c) 2015 Bryan Bolivar Martinez. All rights reserved.
//

import Foundation
import CoreData
import UIKit
enum Country: Int {
    case USD
    case GBP
    case EUR
    case JPY
    case BRL
    init() {
        self = .USD
    }
}
class Currency: NSManagedObject {

    @NSManaged var country: String
    @NSManaged var value: NSNumber
    func convertToCurrency(newCountry: Country, andValue: Int) -> Double{
        switch newCountry{
        case .USD:
            return 1
        case .GBP:
            return 2
        case .EUR:
            return 3
        case .JPY:
            return 4
        case .BRL:
            return 5
        default:
            return 0
        }
    }
    
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    func save() -> Bool{
        if (country.isEmpty == true){
            return false
        }
        //var currencies = [NSManagedObject]()
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext!
        //let entity =  NSEntityDescription.entityForName("Currency",
        //    inManagedObjectContext:
        //    managedContext)
        //let currency = NSManagedObject(entity: entity!,
        //    insertIntoManagedObjectContext:managedContext)
        //currency.setValue(value, forKey: "value")
        //currency.setValue(country!, forKey: "country")
        var error: NSError?
        if !managedContext.save(&error) {
            println("Could not save \(error), \(error?.userInfo)")
            return false
        }
        
        return true
    }

}
