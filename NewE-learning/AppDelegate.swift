//
//  AppDelegate.swift
//  NewE-learning
//
//  Created by admsup on 2015/7/28.
//  Copyright (c) 2015年 test. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate{

    var window: UIWindow?
    var isOpen = 0
    var locmanager: CLLocationManager?
    var backgroundUpdateTask: UIBackgroundTaskIdentifier!
    var currentLocation:CLLocation?
    var location_run:Boolean = 0

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        
        // Override point for customization after application launch.
        //註冊push notification
        if ((UIDevice.currentDevice().systemVersion as NSString).floatValue >= 8.0)
        {
            // iOS 8 Notifications
            application.registerUserNotificationSettings(UIUserNotificationSettings(forTypes: (.Badge | .Sound | .Alert), categories: nil));
            application.registerForRemoteNotifications()
        }
        else
        {
            // iOS < 8 Notifications
            application.registerForRemoteNotificationTypes(.Badge | .Sound | .Alert)
        }
        
        //APP在未開啟的情況下收到推播
        if let remoteNotification = launchOptions?[UIApplicationLaunchOptionsRemoteNotificationKey] as? NSDictionary {
            println(remoteNotification)
            
            var tt: AnyObject? = (remoteNotification["aps"] as! [NSObject: AnyObject])["alert"]
            var mess: AnyObject? = (tt as! [NSObject: AnyObject])["loc-key"]
            
            var courseid: AnyObject? = (remoteNotification["aps"] as! [NSObject: AnyObject])["courseid"]
            
            isPush = 1
            pushWeb = pushWeb + (courseid as! String)

            /*var alertView = UIAlertView()
            alertView.addButtonWithTitle("確定")
            alertView.title = "推播資訊"
            alertView.delegate = self
            //alertView.message = (userInfo["aps"] as! [NSObject: AnyObject])["alert"] as? String
            alertView.message = courseid as! String
            alertView.show()*/
            
            //self.presentViewControllerWithPushInfo(courseid as! String)
        }
        //println("uuuuuuuuuuuuuuu")
        SavePeriodTime() //將節次對應時間表填入資料
        
        //如果課程教材通知功能有開啟,則執行課程資料判斷
        locmanager = CLLocationManager()
        locmanager?.delegate = self
        locmanager?.activityType = .Fitness
        locmanager?.desiredAccuracy = kCLLocationAccuracyBest  //定位精準度
        //locmanager?.distanceFilter = kCLDistanceFilterNone   //每隔多少米定位儀次
        locmanager?.disallowDeferredLocationUpdates()
        
        //setUpLocationTraker()
        
        return true
    }
    
    
    //接收token
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        
        var characterSet: NSCharacterSet = NSCharacterSet( charactersInString: "<>" )
        
        deviceTokenString = ( deviceToken.description as NSString )
            .stringByTrimmingCharactersInSet( characterSet )
            .stringByReplacingOccurrencesOfString( " ", withString: "" ) as String
        
        //println("deviceToken")
        //println(deviceTokenString)
        
    }
    
    //錯誤訊息
    func application( application:
        UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError ) {
            
            println( error.localizedDescription )
    }
    
    
    //程式正在運行
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        isOpen = 1
        
        //APP在背景執行時收到推播
        //println(((userInfo["aps"] as! [NSObject :AnyObject])["alert"] as? String)! + "?")
        //var alertStr = (userInfo["aps"] as! [NSObject: AnyObject]) as? String
        //println("////////////////////")
        
        var alertStr: AnyObject? = (userInfo["aps"] as! [NSObject: AnyObject])["alert"]
        var mess: AnyObject? = (alertStr as! [NSObject: AnyObject])["loc-key"]
        
        courseId = (userInfo["aps"] as! [NSObject: AnyObject])["courseid"]
        
        
        //APP在啓動的狀態時加入alert view提醒user
        if(application.applicationState != UIApplicationState.Inactive){
            //println("front!!")
            //1
            tit = (alertStr as! [NSObject: AnyObject])["title"]
            var alertView = UIAlertView()
            alertView.addButtonWithTitle("關閉")
            alertView.addButtonWithTitle("顯示")
            alertView.title = tit as! String
            alertView.delegate = self
            alertView.message = mess as? String
            alertView.show()
            
            //println(userInfo)
            //println(userInfo["aps"])
            //println(alertStr)

            //self.presentViewControllerWithPushInfo()
            
        }
        else{
            //println("background!!")
            //isPush = 1
            //pushWeb = "http://120.113.173.134/moodle/mod/assign/view.php?id=" + (courseId as! String)
            tit = (alertStr as! [NSObject: AnyObject])["title"]
            self.presentViewControllerWithPushInfo()
            /*if tit as! String == "上課通知" {
                
                pushWeb = "http://120.113.173.134/moodle/course/view.php?id=" + (courseId as! String)
            }
            else{
                pushWeb = "http://120.113.173.134/moodle/mod/assign/view.php?id=" + (courseId as! String)
            }
            
            //跳回主頁面顯示---
            self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
            var storyboard = UIStoryboard(name: "Main", bundle: nil)
            var initialViewController = storyboard.instantiateViewControllerWithIdentifier("ViewController") as! UIViewController
            self.window?.rootViewController = initialViewController
            self.window?.makeKeyAndVisible()
            //跳回主頁面顯示---*/
            
            //NSNotificationCenter.defaultCenter().postNotificationName("reloadWebview", object: nil)
            //println("!!")
            //var vc:ViewController = ViewController()
            //println(vc.loginweburl)
            //vc.loadurl(pushWeb, web: vc.webView)
            //NSNotificationCenter.defaultCenter().postNotificationName("applicationWillResignActive", object: pushWeb)
            
            /*var alertView = UIAlertView()
            alertView.addButtonWithTitle("確定")
            
            alertView.title = "推播資訊"
            alertView.delegate = self
            alertView.message = mess as? String
            alertView.show()
            
            println(userInfo)
            println(userInfo["aps"])
            println(alertStr)*/
        }
    }
    
    func alertView(View: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        switch buttonIndex{
            case 0:
                break
            default:
                self.presentViewControllerWithPushInfo()
                break
        }
    }
    
    func presentViewControllerWithPushInfo() {
        //println("??")
        isPush = 1
        //pushWeb = "http://120.113.173.134/moodle/mod/assign/view.php?id=" + (courseId as! String)
        
        if tit as! String == "上課通知" {
            pushWeb = "http://120.113.173.134/moodle/course/view.php?id=" + (courseId as! String)
        }
        else{
            pushWeb = "http://120.113.173.134/moodle/mod/assign/view.php?id=" + (courseId as! String)
        }
        
        //跳回主頁面顯示---
        
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        var storyboard = UIStoryboard(name: "Main", bundle: nil)
        var initialViewController = storyboard.instantiateViewControllerWithIdentifier("ViewController") as! UIViewController
        self.window?.rootViewController = initialViewController
        self.window?.makeKeyAndVisible()
        //}
        //跳回主頁面顯示---
        
        
        /*if isOpen == 1 {
            var vc = ViewController()
            vc.loadurl(pushWeb, web: vc.webView)
        }*/
        /*if(loadingData()){
            pushAssgin = true
            var pushJudge: NSUserDefaults = NSUserDefaults.standardUserDefaults()
            pushJudge.setObject("push", forKey: "push")
            pushJudge.synchronize()
            println("!!")
            assignString = "http://120.113.173.134/moodle/"
            let gameScene = UIStoryboard(name: "Main", bundle:nil).instantiateViewControllerWithIdentifier("PDFViwerViewController") as! UIViewController
            let appDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
            appDelegate.window?.rootViewController = gameScene
        }
        else{
            println("No userData")
        }*/
        
        
        /*let mainStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let vc: UIViewController = mainStoryboard.instantiateViewControllerWithIdentifier("MapViewController") as! UIViewController
        self.window?.rootViewController?.presentViewController(vc, animated: true, completion: nil)*/
        /*let vc = self.window?.rootViewController?.storyboard?.instantiateViewControllerWithIdentifier("TableViewController") as! TableViewController
        self.window?.rootViewController?.navigationController!.pushViewController(vc, animated: true)*/
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        //println("become background")
        //執行課程資料判斷
        if(BackTaskRunning == 0){
            doBackgroundTask()
            BackTaskRunning = 1
        }
        /*while(StopWhile == 0)
        {
            //backgroundTimeRemaining time does not go down.
            
            doBackgroundTask()

            //println("Background time Remaining: \(UIApplication.sharedApplication().backgroundTimeRemaining)")
            NSThread.sleepForTimeInterval(60) //wait for 1 sec
        }  */      //setUpLocationTraker()
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        //println("become forground")
        
        //isPush = 1
        //pushWeb = "http://120.113.173.134/moodle/course/view.php?id=9"
        /*self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        var storyboard = UIStoryboard(name: "Main", bundle: nil)
        var initialViewController = storyboard.instantiateViewControllerWithIdentifier("NavigationVC") as! UINavigationController*/
        //var initialViewController = storyboard.instantiateViewControllerWithIdentifier("ViewController") as! UIViewController
        //self.window?.makeKeyAndVisible()
        //self.window?.rootViewController?.presentViewController(initialViewController, animated: false, completion: nil)
        //self.window?.backgroundColor = UIColor.whiteColor()
        //self.window?.rootViewController = initialViewController
        //self.window?.makeKeyAndVisible()
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "com.ncyu.itlab.NewE_learning" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1] as! NSURL
    }()

    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = NSBundle.mainBundle().URLForResource("NewE_learning", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()

    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
        // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        var coordinator: NSPersistentStoreCoordinator? = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("NewE_learning.sqlite")
        var error: NSError? = nil
        var failureReason = "There was an error creating or loading the application's saved data."
        if coordinator!.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil, error: &error) == nil {
            coordinator = nil
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason
            dict[NSUnderlyingErrorKey] = error
            error = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(error), \(error!.userInfo)")
            abort()
        }
        
        return coordinator
    }()

    lazy var managedObjectContext: NSManagedObjectContext? = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        if coordinator == nil {
            return nil
        }
        var managedObjectContext = NSManagedObjectContext()
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        if let moc = self.managedObjectContext {
            var error: NSError? = nil
            if moc.hasChanges && !moc.save(&error) {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                NSLog("Unresolved error \(error), \(error!.userInfo)")
                abort()
            }
        }
    }
    
    
    //Extra--------------------------------------
    
    func startCoursePeriodWork(){
        //println("YAAAA")
        if(fetchSettingItemState() == true){ //有開啟課程教材通知
            //println("CPW")
            locmanager?.requestAlwaysAuthorization()
            //locmanager?.requestWhenInUseAuthorization()
            var dateTime = NSDate()
            var timeFormat = NSDateFormatter()
            timeFormat.dateFormat = "HH:mm" //目前時間
            let Current_time = timeFormat.stringFromDate(dateTime)
            timeFormat.dateFormat = "EEE"
            let week = timeFormat.stringFromDate(dateTime)
            //println("\(Current_time) \(week)")
            var Current_week = ""
        
            if(week == "Mon" || week == "週一"){
                Current_week = "星期一"
            }
            else if(week == "Tue" || week == "週二"){
                Current_week = "星期二"
            }
            else if(week == "Wed" || week == "週三"){
                Current_week = "星期三"
            }
            else if(week == "Thu" || week == "週四" ){
                Current_week = "星期四"
            }
            else if(week == "Fri" || week == "週五"){
                Current_week = "星期五"
            }
            else if(week == "Sat" || week == "週六"){
                Current_week = "星期六"
            }
            else if(week == "Sun" || week == "週日"){
                Current_week = "星期日"
            }
            //println(Current_week)
            //test()
            fetchMatchCourseData(Current_time, currentWeekDay: Current_week)
            
            //locmanager?.requestAlwaysAuthorization()
            //locmanager?.startMonitoringSignificantLocationChanges()
            //println("CPW2")
            //locmanager?.pausesLocationUpdatesAutomatically = false
            //println(locmanager?.pausesLocationUpdatesAutomatically)
            //locmanager?.startUpdatingLocation()
       }
        else{
            //println("no period")
            self.endBackgroundUpdateTask()
            //locmanager?.stopMonitoringSignificantLocationChanges()
            //locmanager?.stopUpdatingLocation()
        }
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        println("error: \(error)")
    }
    
    //開始判斷目前時間及定位抓取目前位置
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        //println("!!%%%")
        /*if location_run == 1 {
            locmanager?.stopUpdatingLocation()
            location_run = 0
        }*/
        //location_run = 0
        manager.stopUpdatingLocation()
        
        var locValue:CLLocationCoordinate2D = manager.location.coordinate
        currentLocation = CLLocation(latitude: locValue.latitude, longitude: locValue.longitude)
        //location_run = 1
        //println("\(locValue.latitude), \(locValue.longitude)")
        
    }
    
    func beginBackgroundUpdateTask() {
        self.backgroundUpdateTask = UIApplication.sharedApplication().beginBackgroundTaskWithExpirationHandler({
            self.endBackgroundUpdateTask()
        })
    }
    
    func endBackgroundUpdateTask() {
        UIApplication.sharedApplication().endBackgroundTask(self.backgroundUpdateTask)
        self.backgroundUpdateTask = UIBackgroundTaskInvalid
    }
    
    func doBackgroundTask() {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            self.beginBackgroundUpdateTask()
            // Do something with the result.
            
            
            //---每隔1分鐘執行課程資料判斷---
            var timer = NSTimer.scheduledTimerWithTimeInterval(60.0, target: self, selector: "startCoursePeriodWork", userInfo: nil, repeats: false)
            NSRunLoop.currentRunLoop().addTimer(timer, forMode: NSDefaultRunLoopMode)
            NSRunLoop.currentRunLoop().run()
            //var timer = NSTimer.scheduledTimerWithTimeInterval(60.0, target: self, selector: "startCoursePeriodWork", userInfo: nil, repeats: false)
            
            self.doBackgroundTask()
            //---每隔15秒執行課程資料判斷---
            while(true)
            {
                //backgroundTimeRemaining time does not go down.
                if(fetchSettingItemState()==false){
                    break
                }
                //println("Background time Remaining: \(UIApplication.sharedApplication().backgroundTimeRemaining)")
                NSThread.sleepForTimeInterval(60) //wait for 1 sec
            }
            
            
            // End the background task.
            //self.endBackgroundUpdateTask()
        })
    }
    
    /*func CompareLoc(NewPoint: CLLocationCoordinate2D) -> bool {
        
        return
    }*/
    
    func fetchMatchCourseData(currentTime:String, currentWeekDay:String){
        //println("\(currentTime) \(currentWeekDay)")
        var currentPeriod:NSNumber = 0
        
        //判斷目前時間是否是某節次的上課時間-----------------------------
        let fetchRequest = NSFetchRequest(entityName: "PeriodTime")
        fetchRequest.returnsObjectsAsFaults = false
        var error: NSError?
        var C_Time:String = String(currentTime[advance(currentTime.startIndex, 3)]) + String(currentTime[advance(currentTime.startIndex, 4)])
        //println(C_Time)
        var current:String
        
        //var timeRange:Int = 0
        
        //while timeRange <= 40 {
            //current = String(currentTime[advance(currentTime.startIndex, 0)]) + String(currentTime[advance(currentTime.startIndex, 1)]) + String(currentTime[advance(currentTime.startIndex, 2)]) + C_Time
            fetchRequest.predicate = NSPredicate(format: "begin_time = %@", currentTime)
            
            //Course_count = context!.countForFetchRequest(fetchRequest, error: nil)
            // Execute the fetch request, and cast the results to an array of LogItem objects
            if let fetchResults = context!.executeFetchRequest(fetchRequest, error: &error) as? [PeriodTime] {
                //fecth CourseName
                //println("course time")
                //println(fetchResults)
                for Result in fetchResults as [PeriodTime] {
                    currentPeriod = Result.period
                    //println("\(Result.period)!!\(Result.begin_time)")
                }
            }
            else {
                println("fetch error: \(error)")
            }
            
          //  C_Time = String(C_Time.toInt()! - 1)
        //    timeRange++
        //}
        //判斷目前時間是否是某節次的上課時間END---------------------------
        //currentPeriod = 2
        //println("pass 1")
        println(currentPeriod)
        //若目前時間符合某節的上課時間,抓取符合此上課節次的資料
        if currentPeriod != 0 {
            //抓取符合上課時間的課程==================================
            let fetchCourseRequest = NSFetchRequest(entityName: "SettingCoursePushData")
            fetchCourseRequest.returnsObjectsAsFaults = false
            fetchCourseRequest.predicate = NSPredicate(format: "(weekdays = %@) AND (period = %@) ", currentWeekDay, currentPeriod)
            let count = context!.countForFetchRequest(fetchCourseRequest, error: nil)
            //抓取符合上課時間的課程==================================
            println(count)
            if count != 0{
                //println("pass 2")
                locmanager?.startUpdatingLocation() //抓定位
                NSThread.sleepForTimeInterval(0.4)
                var CourseError: NSError?
                // Execute the fetch request, and cast the results to an array of LogItem objects
                if let fetchCourseResults = context!.executeFetchRequest(fetchCourseRequest, error: &error) as? [SettingCoursePushData] {
                    //fecth MatchCourseData
                    for Result in fetchCourseResults as [SettingCoursePushData] {
                        //抓出座標判斷是否在範圍內
                        //println("test \(currentLocation?.coordinate.latitude) \(currentLocation?.coordinate.longitude)")
                        var location:CLLocation = CLLocation(latitude: Result.latitude, longitude: Result.longitude)
                        var distance = location.distanceFromLocation(currentLocation)
                        //println("distance:\(distance)")
                        
                        if distance < 100 { //如果所在地點小於10`0公尺則觸發課程教材通知
                            
                            
                            //----發送請求,server傳送通知
                            var link = NSString(string:"http://120.113.173.134/moodle/test/SendCoursePeriodMention.php?courseID=\(Result.courseId)&&token=\(deviceTokenString)")
                            var url = NSURL(string: link as String)
                            var SendCourseRequest = NSMutableURLRequest(URL: url!)
                            SendCourseRequest.HTTPMethod = "GET"
                            NSURLConnection.sendSynchronousRequest(SendCourseRequest, returningResponse: nil, error: nil)
                            //----發送請求,server傳送通知---END
    
                        }
                    }
                }
                else {
                    println("fetch error: \(CourseError)")
                }
            }
        }
        
    }
    
    /*func test(){
        var dataString = "21:10" as String
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        dateFormatter.timeZone = NSTimeZone.localTimeZone()
        
        // convert string into date
        let dateValue = dateFormatter.dateFromString(dataString) as NSDate!
        var time = dateValue.timeIntervalSince1970
        println("test \(dateValue) !!\(time)")
    }*/
}

