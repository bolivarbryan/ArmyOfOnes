//
//  Currency.swift
//  ArmyOfOnes
//
//  Created by Bryan Bolivar Martinez on 4/29/15.
//  Copyright (c) 2015 Bryan Bolivar Martinez. All rights reserved.
//

import Foundation
import CoreData

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
    @NSManaged var country: String!
    @NSManaged var value: NSNumber!
}
