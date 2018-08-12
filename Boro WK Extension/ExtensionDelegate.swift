//
//  ExtensionDelegate.swift
//  Boro WK Extension
//
//  Created by Joss Manger on 8/10/18.
//  Copyright © 2018 Joss Manger. All rights reserved.
//

import WatchKit

class ExtensionDelegate: NSObject, WKExtensionDelegate,LocatorProtocol {

    var myComplicationData:Dictionary<String,String>!
    var backgroundTask:WKRefreshBackgroundTask?
    var locator:Locator!
    var interface:InterfaceController?
    
    func applicationDidFinishLaunching() {
        // Perform any final initialization of your application.
        myComplicationData = NSDictionary(contentsOfFile: Bundle.main.path(forResource: "text", ofType: "strings")!) as! Dictionary<String,String>
        print(myComplicationData)
    }

    func applicationDidBecomeActive() {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        print("became active")
        locator = Locator()
        locator.delegate = self
    }

    func applicationWillResignActive() {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, etc.
        print("active resigned")
        locator.delegate = nil
        locator = nil
    }

    func locationUpdated(_ location: String) {
        
        interface?.locationUpdated(location)
        
        if(backgroundTask != nil){
            let server =  CLKComplicationServer.sharedInstance()
            
            guard let complications = server.activeComplications else {
                return
            }
            
            for complication in complications{
                server.reloadTimeline(for: complication)
            }
            
            self.backgroundTask?.setTaskCompletedWithSnapshot(false)
            self.backgroundTask = nil
        }

        
    }
    
    func handle(_ backgroundTasks: Set<WKRefreshBackgroundTask>) {
        
        print("background task")
        
        // Sent when the system needs to launch the application in the background to process tasks. Tasks arrive in a set, so loop through and process each one.
        for task in backgroundTasks {
            // Use a switch statement to check the task type
            switch task {
            case let backgroundTask as WKApplicationRefreshBackgroundTask:
                
                
                // Be sure to complete the background task once you’re done.
                print("background refresh")
                
                let server =  CLKComplicationServer.sharedInstance()
                guard let _ = server.activeComplications else {
                    backgroundTask.setTaskCompletedWithSnapshot(false)
                    return
                }
                //self.complications = complications
                self.backgroundTask = backgroundTask
                locator.doUpdate()
                
                
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
