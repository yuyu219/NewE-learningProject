//
//  UserData.swift
//  NewE-learning
//
//  Created by admsup on 2015/9/4.
//  Copyright (c) 2015年 test. All rights reserved.
//

import UIKit
import CoreData

@objc(UserData)
class UserData: NSManagedObject {
    @NSManaged var userName:String
    @NSManaged var passWord:String

}
