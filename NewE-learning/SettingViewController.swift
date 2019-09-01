//
//  SettingViewController.swift
//  NewE-learning
//
//  Created by admsup on 2015/8/25.
//  Copyright (c) 2015年 test. All rights reserved.
//

import UIKit
import CoreData
class SettingViewController: UIViewController {
    @IBOutlet weak var btnPushCourseData: UIButton!
    @IBOutlet weak var switchCourseData: UISwitch!
    var context=(UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext

    
    @IBAction func clickSwitch(sender: AnyObject) {
       
        if switchCourseData.on {
            DeleteSettingState("PushItem")
            SaveSettingState("PushItem", 1)
            btnPushCourseData.enabled = true
            btnPushCourseData.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
            self.performSegueWithIdentifier("settingCourseListSegue", sender: nil)
            //var destViewController:SetCourseTableViewController = self.storyboard?.instantiateViewControllerWithIdentifier("SetCourseTableViewController") as! SetCourseTableViewController
            //self.performSegueWithIdentifier("settingCourseSegue", sender: nil)
            //self.navigationController?.pushViewController(destViewController, animated: true)

        }
        else {
            DeleteSettingState("PushItem")
            SaveSettingState("PushItem", 0)
            btnPushCourseData.enabled = false
            btnPushCourseData.setTitleColor(UIColor.lightGrayColor(), forState: UIControlState.Disabled)
        }
    }
    
    @IBAction func clickCourseDatabtn(sender: AnyObject) {
        self.performSegueWithIdentifier("settingCourseListSegue", sender: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        switchCourseData.on = fetchSettingItemState()
        
        if(switchCourseData.on){
            btnPushCourseData.enabled = true
            btnPushCourseData.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)

        }
        else{
            btnPushCourseData.enabled = false
            btnPushCourseData.setTitleColor(UIColor.lightGrayColor(), forState: UIControlState.Disabled)
        }
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //fetch PushItem
    /*func fetchSettingItemState(){
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
                    self.switchCourseData.on = true
                }
                else{
                    self.switchCourseData.on = false
                }
            }
        }
        else {
            println("fetch error: \(error)")
        }
        
    }*/

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
