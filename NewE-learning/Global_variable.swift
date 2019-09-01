//
//  Global_variable.swift
//  NewE-learning
//
//  Created by admsup on 2015/8/31.
//  Copyright (c) 2015年 test. All rights reserved.
//

import Foundation

//var Current_latitude:Double?
//var Current_longitude:Double?
var tit:AnyObject?
var courseId:AnyObject?

var SettingCourseName = ""
var SettingCourseID = ""
//var setCourse_switch_state:Bool = false
//var course_array:NSArray = []

var BackTaskRunning = 0

var Course_latitude:Double = 0.0
var Course_longitude:Double = 0.0
var Course_Session: NSDictionary = [
        "星期一": [false,false,false,false,false,false,false,false,false,false,false,false,false] as NSMutableArray,
        "星期二": [false,false,false,false,false,false,false,false,false,false,false,false,false] as NSMutableArray,
        "星期三": [false,false,false,false,false,false,false,false,false,false,false,false,false] as NSMutableArray,
        "星期四": [false,false,false,false,false,false,false,false,false,false,false,false,false] as NSMutableArray,
        "星期五": [false,false,false,false,false,false,false,false,false,false,false,false,false] as NSMutableArray,
        "星期六": [false,false,false,false,false,false,false,false,false,false,false,false,false] as NSMutableArray,
        "星期日": [false,false,false,false,false,false,false,false,false,false,false,false,false] as NSMutableArray  ]