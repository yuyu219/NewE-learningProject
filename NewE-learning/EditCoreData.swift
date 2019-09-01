//
//  EditCoreData.swift
//  NewE-learning
//
//  Created by admsup on 2015/7/28.
//  Copyright (c) 2015年 test. All rights reserved.
//

import Foundation
import UIKit
import CoreData

var context=(UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext

//delete User data
func deleteUserData(){
    //println("delete data")
    let fetchRequest = NSFetchRequest(entityName: "UserData")
    let count = context!.countForFetchRequest(fetchRequest, error: nil)
    if let fetchResults: NSArray = context!.executeFetchRequest(fetchRequest, error: nil) as? [UserData] {
        for var i = 0; i < count; i++ {
            context!.deleteObject(fetchResults[0] as! NSManagedObject)
        }
    }
    context!.save(nil)
}


//save User data
func SaveUserData(username:String, password:String){
    //println("save data")
    let entityDescription = NSEntityDescription.entityForName("UserData", inManagedObjectContext: context!)
    let newUserData = UserData(entity:entityDescription!, insertIntoManagedObjectContext: context)
    //var newUserData = NSEntityDescription.insertNewObjectForEntityForName("UserData", inManagedObjectContext: context!) as! UserData
    
    newUserData.userName = username
    newUserData.passWord = password
    
    //println(newUserData)
    
    var e: NSError?
    
    if context?.save(&e) != true {
        println("insert error \(e?.localizedDescription)")
    }
    context!.save(nil)
}

//save course id,name
func SaveCourseNameId(courseid:String, coursename:String){
    //println("save course data")
    let entityDescription = NSEntityDescription.entityForName("CourseData", inManagedObjectContext: context!)
    let newCourseData = CourseData(entity:entityDescription!, insertIntoManagedObjectContext: context)
    //var newUserData = NSEntityDescription.insertNewObjectForEntityForName("UserData", inManagedObjectContext: context!) as! UserData
    
    newCourseData.courseId = courseid
    newCourseData.courseName = coursename
    
    println(newCourseData)
    
    var e: NSError?
    
    if context?.save(&e) != true {
        println("insert error \(e?.localizedDescription)")
    }
    context!.save(nil)
}

//delete course id,name
func deleteCourseData(){
    //println("delete course data")
    let fetchRequest = NSFetchRequest(entityName: "CourseData")
    let count = context!.countForFetchRequest(fetchRequest, error: nil)
    if let fetchResults: NSArray = context!.executeFetchRequest(fetchRequest, error: nil) as? [CourseData] {
        for var i = 0; i < count; i++ {
            context!.deleteObject(fetchResults[i] as! NSManagedObject)
        }
    }
    context!.save(nil)
}


//save Setting Item
func SaveSettingState(itemName:String, state:Boolean){
    //println("save data")
    let entityDescription = NSEntityDescription.entityForName("SettingItem", inManagedObjectContext: context!)
    let newSettingItem = SettingItem(entity:entityDescription!, insertIntoManagedObjectContext: context)
    
    newSettingItem.itemName = itemName
    newSettingItem.state = state
    
    var e: NSError?
    
    if context?.save(&e) != true {
        println("insert error \(e?.localizedDescription)")
    }
    context!.save(nil)
}

//Delete specific Setting Item
func DeleteSettingState(itemName:String){
    //println("save data")
    
    let fetchRequest = NSFetchRequest(entityName: "SettingItem")
    fetchRequest.predicate = NSPredicate(format: "itemName = %@", itemName)
    
    if let fetchResults: NSArray = context!.executeFetchRequest(fetchRequest, error: nil) as? [SettingItem] {
        if fetchResults.count != 0 {
            context!.deleteObject(fetchResults[0] as! NSManagedObject)
        }
    }
    context!.save(nil)
}


//回傳課程教材推播設定的開啟狀態
func fetchSettingItemState()->Bool{
    let fetchRequest = NSFetchRequest(entityName: "SettingItem")
    fetchRequest.returnsObjectsAsFaults = false
    fetchRequest.predicate = NSPredicate(format: "itemName = %@", "PushItem")
    var error: NSError?
    //Course_count = context!.countForFetchRequest(fetchRequest, error: nil)
    
    // Execute the fetch request, and cast the results to an array of LogItem objects
    if let fetchResults = context!.executeFetchRequest(fetchRequest, error: &error) as? [SettingItem] {
        //fecth CourseName
        for Result in fetchResults as [SettingItem] {
            if Result.state == 1{
                return true
            }
            else{
                return false
            }
        }
    }
    else {
        println("fetch error: \(error)")
    }
    return false
}


//儲存個節次時間
func SavePeriodTime(){
    
    let fetchRequest = NSFetchRequest(entityName: "PeriodTime")
    let count = context!.countForFetchRequest(fetchRequest, error: nil)
    //println("period count:\(count)")
    
    if count == 0 {

        let entityDescription = NSEntityDescription.entityForName("PeriodTime", inManagedObjectContext: context!)

        for var i:Int = 1; i < 14; i++ {
            let newSettingItem = PeriodTime(entity:entityDescription!, insertIntoManagedObjectContext: context)
            newSettingItem.period = NSNumber(integer: i)
            switch(i){
                case 1: newSettingItem.begin_time = "08:10"
                case 2: newSettingItem.begin_time = "09:10"
                case 3: newSettingItem.begin_time = "10:10"
                case 4: newSettingItem.begin_time = "11:10"
                case 5: newSettingItem.begin_time = "13:20"
                case 6: newSettingItem.begin_time = "14:20"
                case 7: newSettingItem.begin_time = "15:20"
                case 8: newSettingItem.begin_time = "16:20"
                case 9: newSettingItem.begin_time = "17:20"
                case 10: newSettingItem.begin_time = "18:30"
                case 11: newSettingItem.begin_time = "19:20"
                case 12: newSettingItem.begin_time = "20:10"
                default: newSettingItem.begin_time = "21:00"
            }
            var e: NSError?
    
            if context?.save(&e) != true {
                println("insert error \(e?.localizedDescription)")
            }
            context!.save(nil)
        }
    }
}

//刪除節次時間
func DeletePeriodTime(){
    //println("delete Period Time")
    let fetchRequest = NSFetchRequest(entityName: "PeriodTime")
    let count = context!.countForFetchRequest(fetchRequest, error: nil)
    if let fetchResults: NSArray = context!.executeFetchRequest(fetchRequest, error: nil) as? [PeriodTime] {
        for var i = 0; i < count; i++ {
            context!.deleteObject(fetchResults[i] as! NSManagedObject)
        }
    }
    context!.save(nil)
}

//delete course push data
func DeleteCoursePushData(){
    //println("delete course push data")
    let fetchRequest = NSFetchRequest(entityName: "SettingCoursePushData")
    let count = context!.countForFetchRequest(fetchRequest, error: nil)
    if let fetchResults: NSArray = context!.executeFetchRequest(fetchRequest, error: nil) as? [SettingCoursePushData] {
        for var i = 0; i < count; i++ {
            context!.deleteObject(fetchResults[i] as! NSManagedObject)
        }
    }
    context!.save(nil)
}