//
//  ExtensionDelegate.swift
//  Boro WK Extension
//
//  Created by Joss Manger on 8/10/18.
//  Copyright © 2018 Joss Manger. All rights reserved.
//

import WatchKit

class ExtensionDelegate: NSObject, WKExtensionDelegate,LocatorProtocol {

    let refreshMinutes:TimeInterval = 5
    
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
        
        if let testStoredBorough = UserDefaults.standard.string(forKey: "storedBorough"){
            if let returnedBorough = Borough.checkBorough(testStoredBorough){
                print("got existing UserDefault \(returnedBorough.getString())")
                storedBorough = returnedBorough
            }
        }
        
        //DispatchQueue.main.sync {
            self.locator = Locator()
            self.locator.delegate = self
        //z}

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
    print("storing savedBorough into UD \(storedBorough.getString())")
        UserDefaults.standard.set(storedBorough.getString(), forKey: "storedBorough")
    }
    
    public func scheduleBackgroundTask(){
        
        let timeInterval:TimeInterval = 60 * refreshMinutes //x mins from now
        let firedate = Date().addingTimeInterval(timeInterval)
        
        //send arbitrary dictionary to squelch additional logging
        let userinfo:NSDictionary = NSDictionary(dictionary: ["refresh":"complication","time":firedate])
        
        //schedule background task
        WKExtension.shared().scheduleBackgroundRefresh(withPreferredDate: firedate, userInfo: userinfo, scheduledCompletion: scheduledCompletionHandler(_:))
        
        print("scheduled background task, will fire at \(firedate)")
        
    }
    
    private func scheduledCompletionHandler(_ error:Error?) -> Void{
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
        
        print("WK location extension delegate called")
        
        //notify interface, if any
        interface?.locationUpdated(locator)
        
        let newBoro = locator.getBorough()
        
        if (storedBorough != newBoro){
            print("updating borough stored in delegate")
            print("location has changed from \(storedBorough) to \(newBoro)")
            storedBorough = newBoro
            updateComplication = true
        }
        
        //we must be in a background task AND the updat complication mist be set in order to trigger complication update
        //if((backgroundTask != nil||firstLoad==true || updateComplication == true){
        if( firstLoad == true || updateComplication == true ){
            
            if(firstLoad==true){
                print("we are in first run, resetting")
                firstLoad = false
            }
            
            print("location has changed, will update complication")
            
            let server =  CLKComplicationServer.sharedInstance()
            
            // if there arent any active complications, simply return out
            guard let complications = server.activeComplications else {
                return
            }
            
            //reset update flag
            updateComplication = false
            
            for complication in complications{
                //full reload is crude but since we arent adding to a timeline, it's ok for our needs
                server.reloadTimeline(for: complication)
            }
            
            releaseBackgroundTask(doShapshot: true)
            return
            
        }
        
        //if we didnt return, we get here... (background task, but no updateComplication flag)
        print("didnt update local borough \(storedBorough.getString())")
        firstLoad = false
        
        //release
         releaseBackgroundTask(doShapshot: false)
        
    }
    
    //release task when complete
    private func releaseBackgroundTask(doShapshot:Bool){
        if(self.backgroundTask != nil){
            self.backgroundTask?.setTaskCompletedWithSnapshot(doShapshot)
            self.backgroundTask = nil
        }
    }
    
    // if delegate method is fired, schedule new update, do not snapshot, send optional error message to interface
    func locatorError(errorMsg: String) {
        print("error")
        interface?.locatorError(errorMsg: errorMsg)
        self.backgroundTask?.setTaskCompletedWithSnapshot(false)
        scheduleBackgroundTask()
    }
    
    private func updateComplication(task:WKApplicationRefreshBackgroundTask){
        print("update complication called")
        let server =  CLKComplicationServer.sharedInstance()
        
        //There ARE no complications
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
                print("background refresh task provided by system")
                
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
