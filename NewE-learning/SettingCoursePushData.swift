//
//  SettingCoursePushData.swift
//  NewE-learning
//
//  Created by admsup on 2015/9/1.
//  Copyright (c) 2015年 test. All rights reserved.
//

import UIKit
import Foundation
import CoreData

@objc(SettingCoursePushData)
class SettingCoursePushData: NSManagedObject {
    @NSManaged var courseId:String
    @NSManaged var longitude:Double
    @NSManaged var latitude:Double
    @NSManaged var weekdays:String
    @NSManaged var period:NSNumber
}
