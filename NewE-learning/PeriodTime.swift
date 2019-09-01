//
//  PeriodTime.swift
//  NewE-learning
//
//  Created by admsup on 2015/10/10.
//  Copyright (c) 2015年 test. All rights reserved.
//

import UIKit
import CoreData

@objc(PeriodTime)
class PeriodTime: NSManagedObject {
    @NSManaged var period:NSNumber
    @NSManaged var begin_time:String
}
