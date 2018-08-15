//
//  ExtensionDelegate.swift
//  Boro WK Extension
//
//  Created by Joss Manger on 8/10/18.
//  Copyright © 2018 Joss Manger. All rights reserved.
//

import WatchKit

class ExtensionDelegate: NSObject, WKExtensionDelegate,LocatorProtocol {

    //var myComplicationData:Dictionary<String,String>!
    var backgroundTask:WKRefreshBackgroundTask?
    var locator:Locator!
    var storedBorough:Borough = Borough.outOfNYC
    var interface:InterfaceController?
    var updateComplication = false;
    var firstLoad = true
    override init() {
        super.init()
        print("initialised")
        DispatchQueue.main.async {
            self.locator = Locator()
            self.locator.delegate = self
        }

    }
    
    func applicationDidFinishLaunching() {
        // Perform any final initialization of your application.
        //myComplicationData = NSDictionary(contentsOfFile: Bundle.main.path(forResource: "text", ofType: "strings")!) as! Dictionary<String,String>
        //print(myComplicationData)print
        print("initialising delegate")

    }

    func applicationDidBecomeActive() {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        print("became active")
        locator.doUpdate()
        scheduleBackgroundTask()
    }
    
    func applicationDidEnterBackground() {
        // save current Borough String to NSUD for retrieval on next init
    }
    
    func scheduleBackgroundTask(){
        let timeInterval:TimeInterval = 60 * 8 //8 mins from now
        let firedate = Date().addingTimeInterval(timeInterval)
        let userinfo:NSDictionary = NSDictionary(dictionary: ["refresh":"complication","time":firedate])
        WKExtension.shared().scheduleBackgroundRefresh(withPreferredDate: firedate, userInfo: userinfo, scheduledCompletion: scheduledCompletionHandler(_:))
        print("scheduled background task, will fire at \(firedate)")
    }
    
    func scheduledCompletionHandler(_ error:Error?) -> Void{
        if let error = error{
            print("background refresh error")
            print(error.localizedDescription)
            return
        }
        print("background refresh successful")
    }

    func applicationWillResignActive() {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, etc.
        print("active resigned")
    
    }
    
    func locationUpdated(_ locator: Locator) {
        
        print("location updated")
        
        let newBoro = locator.getBorough()
        
        if (storedBorough != newBoro){
            print("updating borough stored in delegate")
            storedBorough = newBoro
            
            //notify interface
            interface?.locationUpdated(locator)
            
            updateComplication = true
        }
        
        //we must be in a background task AND the updat complication mist be set in order to trigger complication update
        if((backgroundTask != nil||firstLoad==true) && updateComplication == true){
            
            if(firstLoad==true){
                print("we are in first run, resetting")
                firstLoad = false
            }
            
            print("location has changed, will update complication")
            
            let server =  CLKComplicationServer.sharedInstance()
                                                                   
            guard let complications = server.activeComplications else {
                return
            }
            
            for complication in complications{
                //full reload is crude but since we arent adding to a timeline, it's ok for our needs
                server.reloadTimeline(for: complication)
            }
            
            //reset update flag
            updateComplication = false
            releaseBackgroundTask(doShapshot: true)
            return
            
        }
        
        //if we didnt return, we get here... (background task, but no updateComplication flag)
        print("didnt update local borough \(storedBorough.getString())")
        
        //release
         releaseBackgroundTask(doShapshot: false)
        
    }
    
    func releaseBackgroundTask(doShapshot:Bool){
        if(self.backgroundTask != nil){
            self.backgroundTask?.setTaskCompletedWithSnapshot(doShapshot)
            self.backgroundTask = nil
        }
    }
    
    func locatorError(errorMsg: String) {
        print("error")
        self.backgroundTask?.setTaskCompletedWithSnapshot(false)
    }
    
    func updateComplication(task:WKApplicationRefreshBackgroundTask){
        
        let server =  CLKComplicationServer.sharedInstance()
        guard let _ = server.activeComplications else {
            task.setTaskCompletedWithSnapshot(false)
            return
        }
        //self.complications = complications
        self.backgroundTask = task
        locator.doUpdate()
        
    }
    
    func handle(_ backgroundTasks: Set<WKRefreshBackgroundTask>) {
        
        // Sent when the system needs to launch the application in the background to process tasks. Tasks arrive in a set, so loop through and process each one.
        for task in backgroundTasks {
            // Use a switch statement to check the task type
            switch task {
            case let backgroundTask as WKApplicationRefreshBackgroundTask:
                
                // Be sure to complete the background task once you’re done.
                print("background refresh task")
                
                scheduleBackgroundTask()
                updateComplication(task:backgroundTask)
            
                //backgroundTask.setTaskCompletedWithSnapshot(false)
                
            case let snapshotTask as WKSnapshotRefreshBackgroundTask:
                // Snapshot tasks have a unique completion call, make sure to set your expiration date
                snapshotTask.setTaskCompleted(restoredDefaultState: true, estimatedSnapshotExpiration: Date.distantFuture, userInfo: nil)
            case let connectivityTask as WKWatchConnectivityRefreshBackgroundTask:
                // Be sure to complete the connectivity task once you’re done.
                connectivityTask.setTaskCompletedWithSnapshot(false)
            case let urlSessionTask as WKURLSessionRefreshBackgroundTask:
                // Be sure to complete the URL session task once you’re done.
                urlSessionTask.setTaskCompletedWithSnapshot(false)
            default:
                // make sure to complete unhandled task types
                task.setTaskCompletedWithSnapshot(false)
            }
        }
    }

}
