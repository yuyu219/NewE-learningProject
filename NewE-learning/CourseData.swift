//
//  CourseData.swift
//  NewE-learning
//
//  Created by admsup on 2015/9/4.
//  Copyright (c) 2015年 test. All rights reserved.
//

import UIKit
import CoreData

@objc(CourseData)
class CourseData: NSManagedObject {
    @NSManaged var courseId:String
    @NSManaged var courseName:String
}
