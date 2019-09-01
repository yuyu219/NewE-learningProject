//
//  SetCourseTableViewController.swift
//  NewE-learning
//
//  Created by admsup on 2015/8/31.
//  Copyright (c) 2015年 test. All rights reserved.
//

import UIKit
import CoreData

class SetCourseTableViewController: UITableViewController {
    @IBOutlet var SetCourseTableView: UITableView!
    var context=(UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    var courseName_array:NSMutableArray = []
    var courseID_array:NSMutableArray = []
    //var Course_count:Int = 0
    
    @IBOutlet weak var navBar: UINavigationBar!
    override func viewDidLoad() {
        super.viewDidLoad()
        navBar!.frame = CGRectMake(navBar!.frame.origin.x, navBar!.frame.origin.y, navBar!.frame.size.width, navBar!.frame.size.height+20)
        SettingCourseName = ""
        SettingCourseID = ""
        fetchCourseData()
        ResetCourseTime()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return courseName_array.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = SetCourseTableView!.dequeueReusableCellWithIdentifier("CourseCell", forIndexPath: indexPath) as! UITableViewCell

        // Configure the cell
        cell.textLabel!.text = "\(courseName_array.objectAtIndex(indexPath.row))"
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        return cell
    }


    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("SettingCourseSegue", sender: nil)
    }
    
    //MARK: - Navigation,順便將欲編輯的courseID和courseName傳到下個頁面
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "SettingCourseSegue"){
            var indexPath = SetCourseTableView!.indexPathForSelectedRow()
            var settingCourseDataCL = segue.destinationViewController as! SetCourseDataViewController
            //var settingCourseDataCL = segue.destinationViewController as! SetCourseDataViewController
            SettingCourseID = courseID_array[indexPath!.row] as! String
            SettingCourseName = courseName_array[indexPath!.row] as! String
        }
    }
    
    //fetch all names of courses
     func fetchCourseData(){
        let fetchRequest = NSFetchRequest(entityName: "CourseData")
        fetchRequest.returnsObjectsAsFaults = false
        
        var error: NSError?
        //Course_count = context!.countForFetchRequest(fetchRequest, error: nil)
        
        // Execute the fetch request, and cast the results to an array of LogItem objects
        if let fetchResults = context!.executeFetchRequest(fetchRequest, error: &error) as? [CourseData] {
                //fecth CourseName
            for Result in fetchResults as [CourseData] {
                courseName_array.addObject(Result.courseName)
                courseID_array.addObject(Result.courseId)
                //println(Result.courseName)
                self.SetCourseTableView!.reloadData()
            }
        }
        else {
            println("fetch error: \(error)")
        }
        
    }
    
    //將Course_Session內的值全部重設回false
    func ResetCourseTime(){
        for contentWeek in Course_Session {
            let Array: NSMutableArray = contentWeek.value as! NSMutableArray
            var i = 0, check = 0
            var hei = 1
            while(i < Array.count){
                if Array[i] as! NSObject == 1 {
                    Array.replaceObjectAtIndex(i, withObject: false)
                }
                i++
            }
        }
    }

}
