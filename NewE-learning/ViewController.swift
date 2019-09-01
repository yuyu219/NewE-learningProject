//
//  ViewController.swift
//  NewE-learning
//
//  Created by admsup on 2015/7/28.
//  Copyright (c) 2015年 test. All rights reserved.
//

import UIKit
import CoreData
//import CoreLocation

class ViewController: UIViewController{
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var loading: UIActivityIndicatorView!
    @IBOutlet weak var SettingBtn: UIButton!
    //userdata
    var Username:String = ""
    var Password:String = ""
    //var locmanager: CLLocationManager?
    
    //wrburl
    var loginweburl = "http://120.113.173.134/moodle/login/index.php"
    var indexurl = "http://120.113.173.134/moodle"
    var weburl = "http://120.113.173.134/moodle/my"
    
    //login & logout 判斷
    var login: Int = 0   //0:未登入 1:登入中(登入失敗) 2:登入成功
    
    //存課程資料
    var hasCourse = 0   //0:尚未存取
    
    //上一頁
    @IBAction func GoBack(sender: AnyObject) {
        webView.goBack()
    }
    //下一頁
    @IBAction func GoNext(sender: AnyObject) {
        webView.goForward()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.autoresizingMask = UIViewAutoresizing.FlexibleHeight
        /*locmanager = CLLocationManager()
        locmanager?.delegate = self
        locmanager?.desiredAccuracy = kCLLocationAccuracyBest
        if(fetchSettingItemState() == true){
            println("CPW")
            locmanager?.requestAlwaysAuthorization()
            locmanager?.startMonitoringSignificantLocationChanges()
        }
        else{
            locmanager?.stopMonitoringSignificantLocationChanges()
        }*/
        // Do any additional setup after loading the view, typically from a nib.
        
        /*let reque = NSFetchRequest(entityName: "UserData")
        reque.returnsObjectsAsFaults = false
        let result: NSArray = context?.executeFetchRequest(reque, error: nil) as! [UserData]
        println(result.count)*/
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "reloadWebview", name: "reloadWebview", object: nil)
        
        loading.startAnimating()
        
        //loadJsonData()
        
        //NSNotificationCenter.defaultCenter().addObserver(self, selector: "applicationWillResignActive", name: "funcNameToFire", object: nil)
        
        //判斷資料庫是否具有UserData
        if(loadingData()){
            //println("has UserData")
            loginrequest(loginweburl)
        }
        else{
            //println("no UserData")
            loadurl(weburl, web: webView)
        }
    }
    
    //override func viewDidUnLoad() {
        
    //}
    
    func reloadWebview(notification: NSNotification){
        loadurl(pushWeb, web: webView)
    }
    
    func unrefisterForNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "reloadWebview", object: nil)
    }
    
    func funcNameToFire(notification: NSNotification){
        loadurl(pushWeb, web: webView)
    }
    
    override func didReceiveMemoryWarning() {
        self.unrefisterForNotifications()
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //url建立
    func loadurl(url: String, web: UIWebView){
        //println("YA")
        let aUrl = NSURL(string: url)!
        let request = NSURLRequest(URL:aUrl)
        webView.loadRequest(request)
    }
    
    //開始load網頁
    func webViewDidStartLoad(webView: UIWebView){
        //println("start")
        loading.startAnimating()
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        //println(isPush)
        
    }
    
    //取js的回傳值
    func webView(webView: UIWebView!, shouldStartLoadWithRequest request: NSURLRequest!, navigationType: UIWebViewNavigationType) -> Bool{
        updateAddress(request)
        
        return true
    }
    
    //結束load網頁
    func webViewDidFinishLoad(webView: UIWebView){
        //println("finish")
        loading.stopAnimating()
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        
        //當前網址
        var url = webView.request?.URL
        var currentUrl: NSString = webView.request!.URL!.absoluteString!
        
        //存course data
        if login == 2 {
            SettingBtn.enabled = true
            //fetch course sata
            let fetchRequest = NSFetchRequest(entityName: "CourseData")
            var error: NSError?
            
            if let fetchResults = context!.executeFetchRequest(fetchRequest, error: &error) as? [CourseData] {
                if fetchResults.count <= 0 {
                    
                    var html = webView.stringByEvaluatingJavaScriptFromString("document.body.innerHTML")
                    var htmlNSString: NSString = html!
                    
                    //截取1
                    //(#)sb-1 ~ (不含前)
                    var cutString1 = "sb-1"
                    var cutString2 = ""
                    var tempRange1: NSRange = htmlNSString.rangeOfString(cutString1)
                    var tempRange2: NSRange
                    //拿掉 (#)sb-1(含) 以前的字串
                    htmlNSString=htmlNSString.substringFromIndex(tempRange1.location + tempRange1.length)
                    
                    //截取2
                    //(#)sb-1 ~ sb-1 (不含前後)
                    tempRange1 = htmlNSString.rangeOfString(cutString1)
                    //只取 (#)sb-1 ~ sb-1 (不含前後) 的中間
                    htmlNSString = htmlNSString.substringToIndex(tempRange1.location)
                    
                    //截取3(取course id & name)
                    var courseid = ""
                    var coursename = ""
                    while(htmlNSString.containsString("course-"))
                    {
                        //裁htmlNSString("course-"~ (不含前))
                        cutString1 = "course-"
                        cutString2 = "\""
                        tempRange1 = htmlNSString.rangeOfString(cutString1)
                        htmlNSString = htmlNSString.substringFromIndex(tempRange1.location + tempRange1.length)
                        
                        //裁course id
                        tempRange2 = htmlNSString.rangeOfString(cutString2)
                        courseid = htmlNSString.substringToIndex(tempRange2.location)
                        
                        //course name
                        cutString1 = "class=\"title\"><a title=\""
                        cutString2 = "   "
                        tempRange1 = htmlNSString.rangeOfString(cutString1)
                        tempRange2 = htmlNSString.rangeOfString(cutString2)
                        coursename = htmlNSString.substringWithRange(NSMakeRange(tempRange1.location + tempRange1.length, (tempRange2.location-tempRange1.location-tempRange1.length)))
                        //println(htmlNSString)
                        SaveCourseNameId(courseid, coursename)
                    }
                    //println(courseid)
                    hasCourse = 1
                }
            }
        }
        else{
            SettingBtn.enabled = false
        }
        
        //first login
        if currentUrl.containsString("/login") {
            //println(login)
            login = 1
        }
        else if login == 1 && (currentUrl == weburl || currentUrl == weburl + "/" || currentUrl == indexurl || currentUrl == indexurl + "/") {
            //did not login,and return to home page
            if Username == "" && Password == "" {
                login = 0
            }
            //first login success
            else {
                login = 2
                SaveUserData(Username, Password)
                
                //====send the deviceToken to server====
                var link = NSString(string:"http://120.113.173.134/moodle/test/store_token.php?username=\(Username)&token=\(deviceTokenString)")
                var url = NSURL(string: link as String)
                var SendTokenRequest = NSMutableURLRequest(URL: url!)
                SendTokenRequest.HTTPMethod = "GET"
                NSURLConnection.sendSynchronousRequest(SendTokenRequest, returningResponse: nil, error: nil)
                //====send the deviceToken to server END====
                
                //push
                if(isPush == 1){
                    //pushWeb = pushWeb +
                    loadurl(pushWeb, web: webView)
                }
                //not push
                else {
                    loadurl(weburl, web: webView)
                }
            }
        }
        //login failed
        else if login == 1 {
            //println("login failed")
            Username = ""
            Password = ""
        }
        
        //如果是外部網站,webView回到上一頁
        if !currentUrl.containsString("120.113.173.134") {
            webView.goBack()
        }
        
        //redirect的檢查
        var request: NSURLRequest = webView.request!
        updateAddress(request)
    }
    
    //redirect
    func updateAddress(request: NSURLRequest){
        //println("redirect")
        //取登入時輸入的帳密,無論正確與否
        if login == 1 {
            Username = self.webView.stringByEvaluatingJavaScriptFromString("document.getElementById('username').value")!
            Password = self.webView.stringByEvaluatingJavaScriptFromString("document.getElementById('password').value")!
        }
        
        //轉址過程的all網址
        var url: NSURL = request.mainDocumentURL!
        var absolute: NSString = url.absoluteString!
        
        //連向外部網站
        if !absolute.containsString("120.113.173.134"){
            //使用內建safari開啟
            UIApplication.sharedApplication().openURL(url)
        }
        //logout
        else if absolute.containsString("logout.php") {
            login = 0
            Username = ""
            Password = ""
            deleteUserData()
            
            hasCourse = 0
            deleteCourseData()
            
            SettingCourseName = ""
            SettingCourseID = ""
            
            
            DeleteSettingState("PushItem")
            DeletePeriodTime()
            DeleteCoursePushData()
            
            //send logout message
            var link = NSString(string:"http://120.113.173.134/moodle/test/app_logout.php?token=\(deviceTokenString)")
            var url = NSURL(string: link as String)
            var SendTokenRequest = NSMutableURLRequest(URL: url!)
            SendTokenRequest.HTTPMethod = "GET"
            NSURLConnection.sendSynchronousRequest(SendTokenRequest, returningResponse: nil, error: nil)
            
        }
        //登入後,又進入登入頁面(ex:上一頁,下一頁)
        else if login == 2 && absolute.containsString("/login") {
            loadurl(weburl, web: webView)
        }
    }
    
    //確認資料庫中是否存在UserData
    func loadingData()->Bool{
        //println("??")
        // Create a new fetch request using the LogItem entity
        let fetchRequest = NSFetchRequest(entityName: "UserData")
        //fetchRequest.returnsObjectsAsFaults = false
        
        var error: NSError?
        let count = context!.countForFetchRequest(fetchRequest, error: &error)
        
        //println("!!")
        // Execute the fetch request, and cast the results to an array of LogItem objects
        if let fetchResults = context!.executeFetchRequest(fetchRequest, error: &error) as? [UserData]
           {
            if fetchResults.count <= 0 {
                return false
            }
            else {
                //fecth userName and password
                /*for Result in fetchResults as! [UserData] {
                    Username = Result.userName
                    Password = Result.passWord
                }*/
                Username = fetchResults[0].userName
                Password = fetchResults[0].passWord
            }
        }
        else {
            println("fetch error: \(error)")
        }
        
        return true
    }
    
    //資料庫存在UserData時,自動login
    func loginrequest(webstr:NSString){
        var url:NSURL = NSURL(string:webstr as String)!
        let request = NSMutableURLRequest(URL:url)
        let loginStr = NSString(format:"username=%@&password=%@", Username, Password)
        let data:NSData = loginStr.dataUsingEncoding(NSUTF8StringEncoding)!
        request.HTTPMethod = "POST"
        request.HTTPBody = data
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler:{
            (response,data,error)-> Void in
            
            if (error != nil) {
                println("error:" + error.description)
            }
            else{
                var response:NSString = NSString(data:data, encoding:NSUTF8StringEncoding)!
                //println(response)
                
                //自動登入成功
                if self.successornot(response) == true {
                    self.login = 2
                    
                    //Push
                    if(isPush == 1){
                        /*var alertView1 = UIAlertView()
                        alertView1.addButtonWithTitle("確定")
                        alertView1.title = "推播資訊2"
                        alertView1.delegate = self
                        //alertView1.message = (userInfo["aps"] as! [NSObject: AnyObject])["alert"] as? String
                        alertView1.message = pushWeb
                        alertView1.show()*/
                        self.loadurl(pushWeb, web: self.webView)
                        isPush = 0
                    }
                    //not push
                    else {
                        self.loadurl(self.weburl, web: self.webView)
                    }
                }
                //自動登入失敗
                else {
                    var alertView = UIAlertView()
                    alertView.addButtonWithTitle("OK")
                    alertView.title = "Login Failed"
                    alertView.message = "The username or password is changed."
                    alertView.delegate = self
                    alertView.show()
                    
                    self.login = 0
                }
            }
            
        })
    }
    
    func successornot(str:NSString)->Bool{
        if str.containsString("登入無效")||str.containsString("尚未登入"){
            return false
        }
        return true
    }
    
    func alertView(View: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        switch buttonIndex{
        case 0:
            //loading.startAnimating()
            Username = ""
            Password = ""
            deleteUserData()
            self.loadurl(self.loginweburl, web: self.webView)
            break
        default:
            break
        }
    }
    
    @IBAction func clickSettingBtn(sender: AnyObject) {
        self.performSegueWithIdentifier("settingSegue", sender: nil)
    }
    
    //開始判斷目前時間及定位抓取目前位置
    /*func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        
        println("!!%%%")
        let location = locations[0] as! CLLocation
        let geoCoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(location, completionHandler: {(data, error) -> Void in
            let placeMarks = data as! [CLPlacemark]
            let loc: CLPlacemark = placeMarks[0]
            //println("!!!!!!~~~~")
            //calculate coordinate
            //var locValue:CLLocationCoordinate2D = manager.location.coordinate
            
            var timeFormat = NSDateFormatter()
            timeFormat.dateFormat = "HH:mm"
            let Current_time = timeFormat.stringFromDate(NSDate())
            println(Current_time)
            //println("\(locValue.latitude), \(locValue.longitude)")
            //println("#############")
        })
        
    }*/
    
}

