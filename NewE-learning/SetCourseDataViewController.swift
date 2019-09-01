//
//  SetCourseDataViewController.swift
//  NewE-learning
//
//  Created by admsup on 2015/8/31.
//  Copyright (c) 2015年 test. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import CoreData

class SetCourseDataViewController: UIViewController, CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource{

    @IBOutlet weak var courseTimeTableView: UITableView!
    
    var locmanager: CLLocationManager?
    var courseTimeArray:NSMutableArray = []
    var segueSourse:Boolean = 0
    
    @IBOutlet weak var course_locat_coord_label: UILabel!
    @IBOutlet weak var naviga_item: UINavigationItem!
    @IBOutlet weak var navBar: UINavigationBar!
    
    var context=(UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    override func viewDidLoad() {
        // Do any additional setup after loading the view.
        super.viewDidLoad()
        naviga_item.title = SettingCourseName
        navBar!.frame = CGRectMake(navBar!.frame.origin.x, navBar!.frame.origin.y, navBar!.frame.size.width, navBar!.frame.size.height+20)
        locmanager = CLLocationManager()
        locmanager?.delegate = self
        locmanager?.desiredAccuracy = kCLLocationAccuracyBest
        
        if(segueSourse == 0){ //從課程清單點進來,初始化課程資料
            //println("initial")
            if(!FetchCourseData()){
                self.course_locat_coord_label.text = "目前沒有資料"
            }
            else{
                self.course_locat_coord_label.text = "\(Course_longitude) , \(Course_latitude)"
            }
        }
        else{
            println("has data")
            if(Course_latitude != 0.0 || Course_longitude != 0.0){
                course_locat_coord_label.text = "\(Course_longitude) , \(Course_latitude)"
            }
        }
        
        //顯示設定的課程時間
        var SelectStr:String = ""
        for contentWeek in Course_Session {
            let Array: NSMutableArray = contentWeek.value as! NSMutableArray
            var i = 0, check = 0
            var hei = 1
            while(i < Array.count){
                if Array[i] as! NSObject == 1 {
                    if i < 9 {   //1~9節
                        SelectStr = "\(contentWeek.key) 第\(i+1)節"
                    }
                    else{   //A,B,C,D
                        SelectStr = "\(contentWeek.key) 第"
                        switch i {
                        case 9:
                            SelectStr += "A"
                        case 10:
                            SelectStr += "B"
                        case 11:
                            SelectStr += "C"
                        case 12:
                            SelectStr += "D"
                        default:
                            SelectStr += "error"
                        }
                        SelectStr += "節"
                    }
                    //println(SelectStr)
                    courseTimeArray.addObject(SelectStr)
                }
                i++
            }
        }
        
        if courseTimeArray.count == 0 {
            courseTimeArray.addObject("尚未設定")
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //儲存此課程的設定地點及時間
    @IBAction func clickSaveBtn(sender: AnyObject) {
        var MemoAlert = UIAlertView()
        
        if(course_locat_coord_label.text == "目前沒有資料"){ //未設定地點
            MemoAlert.addButtonWithTitle("確定")
            MemoAlert.title = "失敗"
            MemoAlert.delegate = self
            MemoAlert.message = "未設定座標"
        }
        else if(courseTimeArray.count == 1 && courseTimeArray.objectAtIndex(0) as! String == "尚未設定"){ //未設定時間
            MemoAlert.addButtonWithTitle("確定")
            MemoAlert.title = "失敗"
            MemoAlert.delegate = self
            MemoAlert.message = "未設定時間"
        }
        else{
            MemoAlert.addButtonWithTitle("確定")
            MemoAlert.title = "成功"
            MemoAlert.delegate = self
            MemoAlert.message = "已成功儲存資料！"
            SaveCoursePushData()
        }
        MemoAlert.show()
    }
    
    //按下抓取定位按鈕
    @IBAction func clickFetchLocationBtn(sender: AnyObject) {
        //println("##")
        locmanager?.requestWhenInUseAuthorization()
        locmanager?.startUpdatingLocation()
        //println("##2")
    }
    
    //開始定位抓取目前位置
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        println("!?")
        manager.stopUpdatingLocation()
        
        println("!!")
        let location = locations[0] as! CLLocation
        let geoCoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(location, completionHandler: {(data, error) -> Void in
            let placeMarks = data as! [CLPlacemark]
            let loc: CLPlacemark = placeMarks[0]
            println("!!!!!!~~~~")
            //calculate coordinate
            var locValue:CLLocationCoordinate2D = manager.location.coordinate
            Course_latitude = locValue.latitude
            Course_longitude = locValue.longitude
            
            //show coordinate
            self.course_locat_coord_label.text = "\(Course_longitude) , \(Course_latitude)"
            //println(self.course_locat_coord_label.text)
        })
        
    }
    
    
    //-------設定的課程時間顯示
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return courseTimeArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = courseTimeTableView.dequeueReusableCellWithIdentifier("courseTimeCell", forIndexPath: indexPath) as! UITableViewCell
        
        //println(weekArray.objectAtIndex(indexPath.row))
        cell.textLabel?.text = "\(courseTimeArray.objectAtIndex(indexPath.row))"
        //cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        return cell
    }
    //-------設定的課程時間顯示
    
    
    //MARK: - Navigation,順便將欲編輯的courseID和courseName傳到下個頁面
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "SettingCourseSegueweek"){
            var settingCourseDataCL = segue.destinationViewController as! WeekCourseDataTableViewController
            //var settingCourseDataCL = segue.destinationViewController as! SetCourseDataViewController
            //settingCourseDataCL.courseID = courseID
            //settingCourseDataCL.courseName = courseName
        }
    }
    
    //------------課程資料存取------------
    func SaveCoursePushData(){
        let fetchRequest = NSFetchRequest(entityName: "SettingCoursePushData")
        fetchRequest.predicate = NSPredicate(format: "courseId = %@", SettingCourseID)
        let count = context!.countForFetchRequest(fetchRequest, error: nil)
        //println(count)
        //刪掉原本的設定資料
        if count != 0 {
            let fetchResults: NSArray = (context!.executeFetchRequest(fetchRequest, error: nil) as? [SettingCoursePushData])!
            //println("!!")
            for var i = 0; i < count; i++ {
                context!.deleteObject(fetchResults[i] as! NSManagedObject)
                //println(i)
            }
            context!.save(nil)
        }
        
        //儲存新設定資料
        let entityDescription = NSEntityDescription.entityForName("SettingCoursePushData", inManagedObjectContext: context!)
        var i = 0
        for i in 0..<courseTimeArray.count {
            //let entityDescription = NSEntityDescription.entityForName("SettingCoursePushData", inManagedObjectContext: context!)
            let newSettingCourseDate = SettingCoursePushData(entity:entityDescription!, insertIntoManagedObjectContext: context)

            newSettingCourseDate.courseId = SettingCourseID
            newSettingCourseDate.longitude = Course_longitude
            newSettingCourseDate.latitude = Course_latitude
            
            
            //weekday
            let str:String = courseTimeArray.objectAtIndex(i) as! String
            var week_period:[String] = split(str, maxSplit: Int.max, allowEmptySlices: false, isSeparator: {$0 == " "})
            newSettingCourseDate.weekdays = week_period[0]
            
            //period
            let periodStrIndex = advance(week_period[1].startIndex, 1)
            let period = week_period[1][periodStrIndex]
            var p_index:String
            switch period{
                case "A":p_index = "10"
                case "B":p_index = "11"
                case "C":p_index = "12"
                case "D":p_index = "13"
                default:p_index = String(period)
            }
            var pe = NSNumber(integer: p_index.toInt()!)
            //println(pe)
            newSettingCourseDate.period = pe
            
            
            //println("\(newSettingCourseDate.courseId) \(newSettingCourseDate.longitude) \(newSettingCourseDate.latitude)  \(newSettingCourseDate.weekdays) \(newSettingCourseDate.period)")
            var e: NSError?
            
            if context?.save(&e) != true {
                println("insert error \(e?.localizedDescription)")
            }
            context!.save(nil)
        }

    }
    
    func FetchCourseData()->Bool{
        let fetchRequest = NSFetchRequest(entityName: "SettingCoursePushData")
        //println(SettingCourseID)
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: "courseId == %@", SettingCourseID)
        
        var error: NSError?
        let fetchResults: NSArray = (context!.executeFetchRequest(fetchRequest, error: &error) as? [SettingCoursePushData])!
        
        if fetchResults.count == 0{
            return false
        }
        else{
            for Result in fetchResults{
                Course_latitude = Result.latitude
                Course_longitude =  Result.longitude

                
                var mon = Course_Session[Result.weekdays] as! NSMutableArray
                mon.replaceObjectAtIndex(Int(Result.period)-1, withObject: true)
                //println(Result.courseId)
                self.courseTimeTableView!.reloadData()
            }
            return true
        }
    }
    //------------課程資料存取------------END
}
