//
//  SectionCourseTableViewController.swift
//  NewE-learning
//
//  Created by admsup on 2015/9/6.
//  Copyright (c) 2015年 test. All rights reserved.
//

import UIKit

class SectionCourseTableViewController: UITableViewController {
    @IBOutlet var SectionTbkl: UITableView!
    @IBOutlet weak var navItem: UINavigationItem!
    
    @IBOutlet weak var navBar: UINavigationBar!
    var week:String = ""
    
    var sectionArray: NSMutableArray = []
    var selectedPeriod:[Boolean] = [0,0,0,0,0,0,0,0,0,0,0,0,0]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navItem.title = week
        navBar!.frame = CGRectMake(navBar!.frame.origin.x, navBar!.frame.origin.y, navBar!.frame.size.width, navBar!.frame.size.height+20)
        
        let Array: NSMutableArray = Course_Session[week as String] as! NSMutableArray
        var i = 0, check = 0
        var hei = 1
        while(i < Array.count){
            if Array[i] as! NSObject == 1 {
                selectedPeriod[i] = 1
                //println(i)
                //println(contentWeek.key)
                //println(weekIndex)
                //if check == 0 {
                //}
                //SelectStr += i as! String + ", "
                //check = 1
            }
            i++
        }

        
        sectionArray.addObject("第一節")
        sectionArray.addObject("第二節")
        sectionArray.addObject("第三節")
        sectionArray.addObject("第四節")
        sectionArray.addObject("第五節")
        sectionArray.addObject("第六節")
        sectionArray.addObject("第七節")
        sectionArray.addObject("第八節")
        sectionArray.addObject("第九節")
        sectionArray.addObject("第A節")
        sectionArray.addObject("第B節")
        sectionArray.addObject("第C節")
        sectionArray.addObject("第D節")
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
        //Course_Session["星期一"]
        var mon = Course_Session[week as String] as! NSMutableArray
        mon.replaceObjectAtIndex(indexPath.row, withObject: true)
        var cell = tableView.cellForRowAtIndexPath(indexPath) as! SectionCourseTableViewCell
        cell.SelectImageView?.hidden = false
        //println(mon[indexPath.row])
    }
    
    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        var mon = Course_Session[week as String] as! NSMutableArray
        mon.replaceObjectAtIndex(indexPath.row, withObject: false)
        var cell = tableView.cellForRowAtIndexPath(indexPath) as! SectionCourseTableViewCell
        cell.SelectImageView?.hidden = true
        //println(mon[indexPath.row])
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
        return 13
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCellWithIdentifier("SectionTblCell", forIndexPath: indexPath) as! UITableViewCell
        
        //cell.textLabel?.text = "\(sectionArray.objectAtIndex(indexPath.row))"
        
        let cell = tableView.dequeueReusableCellWithIdentifier("SectionTblCell", forIndexPath: indexPath) as! SectionCourseTableViewCell
        cell.titleLabel!.text = "\(sectionArray.objectAtIndex(indexPath.row))"
        cell.titleLabel?.font = cell.textLabel?.font.fontWithSize(15)
        cell.SelectImageView!.hidden = true
        
        if(selectedPeriod[indexPath.row] == 1){
            tableView.selectRowAtIndexPath(indexPath, animated: true, scrollPosition: UITableViewScrollPosition.None)
            cell.SelectImageView!.hidden = false
            println("!\(indexPath.row)")
        }
        return cell
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
