//
//  ExtensionDelegate.swift
//  Boro WatchKit Extension
//
//  Created by Joss Manger on 10/4/21.
//

import WatchKit
import BoroKit
import ClockKit

class ExtensionDelegate: NSObject, WKExtensionDelegate {
  
  private(set) var boroManager: BoroManager = BoroManager()
  private let compServer = CLKComplicationServer.sharedInstance()
  
  var hasActiveComplications: Bool {
    !(compServer.activeComplications ?? []).isEmpty
  }
  
  private let wkExtension = WKExtension.shared()
  
  func applicationDidFinishLaunching() {
    print("application loaded")
  }
  
  func applicationDidBecomeActive() {
    print("application became active")
    requestUpdate(lifecycle:.ui)
    scheduleUpdate()
  }
  
  func applicationDidEnterBackground() {
    print("application entered background")
    scheduleUpdate()
  }
  
  func requestUpdate(lifecycle: BoroManager.LocationRequestType = .lifecycle, callback: ((Boro) -> Void)? = nil) {
    boroManager.getCurrent(origin:lifecycle){ [weak self] newBoro in
      print("background Task got new Boro: \(newBoro)")
      self?.updateComplications()
      callback?(newBoro)
    }
  }
  
  func scheduleUpdate(at date:Date? = nil){
    
    var updateDate: Date = Date()
    
    //Allow for override date
    if let overrideDate = date {
      updateDate = overrideDate
    } else {
    
      if hasActiveComplications {
        // if we have complications, schedule updates "more often"
        print("we have active complications - schedule for the future")
        updateDate.addTimeInterval(60 * 5)
      } /*else if wkExtension.isApplicationRunningInDock {
        // if we're only running in the dock, schedule snapshot updates once per hour
        //this does not appear to work correctly
      } */ else {
        
        //we are not running on the clock or the dock, do not schedule an update
        print("we do not have any active complications - schedule for the future")
        updateDate.addTimeInterval(60 * 60)
        
      }
      
    }
   
    //schedule an update with the system at time.
    wkExtension.scheduleBackgroundRefresh(withPreferredDate: updateDate, userInfo: nil) { [hasActiveComplications, unowned wkExtension] error in
      if let error = error {
        print("there was an error \(error) for scheduled task at \(updateDate)")
        return
      }
      
      print("there was a successful background refresh registration for scheduled task at \(updateDate) has complications: \(hasActiveComplications) is on dock: \(wkExtension.isApplicationRunningInDock)")
      
    }
    
  }
  
  func updateComplications(){
    
    if let activeComplications = compServer.activeComplications {
      for comp in activeComplications {
        compServer.reloadTimeline(for: comp)
      }
    }
  }
  
  func handle(_ backgroundTasks: Set<WKRefreshBackgroundTask>) {
    for task in backgroundTasks{
      requestUpdate(lifecycle: .complication){ _ in
        task.setTaskCompletedWithSnapshot(true)
      }
    }
    scheduleUpdate()
  }
  

  
}
