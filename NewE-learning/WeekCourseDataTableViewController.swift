//
//  WeekCourseDataTableViewController.swift
//  NewE-learning
//
//  Created by admsup on 2015/9/4.
//  Copyright (c) 2015年 test. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class WeekCourseDataTableViewController: UITableViewController, CLLocationManagerDelegate {
    @IBOutlet var weektbl: UITableView!
    @IBOutlet weak var navItem: UINavigationItem!
    @IBOutlet weak var navBar: UINavigationBar!
    var weekArray:NSMutableArray = []
    //var SelectStr:String = ""
    var SelectedWeek:NSMutableArray = []
    //var courseName:String = ""
    var locmanager: CLLocationManager?
    var latittude:Double = 0.0
    var longittude:Double = 0.0

    override func viewDidLoad() {
        super.viewDidLoad()
        navItem.title = SettingCourseName
        navBar!.frame = CGRectMake(navBar!.frame.origin.x, navBar!.frame.origin.y, navBar!.frame.size.width, navBar!.frame.size.height+20)
        locmanager = CLLocationManager()
        locmanager?.delegate = self
        locmanager?.desiredAccuracy = kCLLocationAccuracyBest
        
        
        //let contentWeek: NSMutableArray
        for contentWeek in Course_Session {
            let Array: NSMutableArray = contentWeek.value as! NSMutableArray
            var i = 0, check = 0
            var hei = 1
            while(i < Array.count){
                if Array[i] as! NSObject == 1 {
                    SelectedWeek.addObject(contentWeek.key)
                    //println(contentWeek.key)
                    //println(i)
                    break
                    //if check == 0 {
                    //SelectStr = "\(SelectStr)\n\(contentWeek.key) 第\(i+1)節"
                    //}
                    //SelectStr += i as! String + ", "
                    //check = 1
                }
                i++
            }
        }
        /*println(SelectStr)
        if SelectStr == "" {
            weekArray.addObject("尚未設定")
        }
        else {
            weekArray.addObject(SelectStr)
        }*/
        weekArray.addObject("星期一")
        weekArray.addObject("星期二")
        weekArray.addObject("星期三")
        weekArray.addObject("星期四")
        weekArray.addObject("星期五")
        weekArray.addObject("星期六")
        weekArray.addObject("星期日")
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //if indexPath.row != 0 {
            self.performSegueWithIdentifier("SettingCourseSeguesection", sender: nil)
        //}
    }
    
    //MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "SettingCourseSeguesection"){
            var indexPath = weektbl!.indexPathForSelectedRow()
            var settingCourseDataCL = segue.destinationViewController as! SectionCourseTableViewController
            settingCourseDataCL.week = weekArray[indexPath!.row] as! String
        }
        else if(segue.identifier == "WeekBackToCourseData"){
            var settingCourseDataCL = segue.destinationViewController as! SetCourseDataViewController
            settingCourseDataCL.segueSourse = 1
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return 7
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = weektbl.dequeueReusableCellWithIdentifier("WeekTblCell", forIndexPath: indexPath) as! UITableViewCell
        
        //println(weekArray.objectAtIndex(indexPath.row))
        if(SelectedWeekOrNot(weekArray.objectAtIndex(indexPath.row) as! String)){
            //星期幾
            var time = "\(weekArray.objectAtIndex(indexPath.row)) (第"
            
            //第幾節
            let Array: NSMutableArray = Course_Session[weekArray.objectAtIndex(indexPath.row) as! String] as! NSMutableArray
            var i = 0, temp = 0
            while(i < Array.count){
                if Array[i] as! NSObject == 1 {
                    if i < 9 {   //1~9節
                        if temp == 0{
                            time += "\(i+1)"
                            temp = 1
                        }
                        else{
                            time += ", \(i+1)"
                        }
                    }
                    else{   //A,B,C,D
                        //println(i)
                        if temp == 0{
                            switch i {
                            case 9:
                                time += "A"
                            case 10:
                                time += "B"
                            case 11:
                                time += "C"
                            case 12:
                                time += "D"
                            default:
                                time += "error"
                            }
                            temp = 1
                        }
                        else{
                            time += ", "
                            switch i {
                            case 9:
                                time += "A"
                            case 10:
                                time += "B"
                            case 11:
                                time += "C"
                            case 12:
                                time += "D"
                            default:
                                time += "error"
                            }
                        }
                    }
                }
                i++
            }
            cell.textLabel?.text = time + "節)"
        }
        else{
            cell.textLabel?.text = "\(weekArray.objectAtIndex(indexPath.row))"
        }
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        return cell
    }

    func SelectedWeekOrNot(dayStr:String)->Bool{
        for i in 0..<SelectedWeek.count{
            if(SelectedWeek.objectAtIndex(i) as! String == dayStr){
                return true
            }
        }
        return false
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
