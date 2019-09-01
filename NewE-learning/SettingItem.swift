//
//  SettingItem.swift
//  NewE-learning
//
//  Created by admsup on 2015/9/1.
//  Copyright (c) 2015年 test. All rights reserved.
//

import UIKit
import CoreData

@objc(SettingItem)
class SettingItem: NSManagedObject {
    @NSManaged var itemName:String
    @NSManaged var state:Boolean
}
