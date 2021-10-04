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
  
  func applicationDidFinishLaunching() {
    print("we loaded")

    #if DEBUG
    scheduleUpdate(at: Date().addingTimeInterval(10))
    #else
    scheduleUpdate()
    #endif
  }
  
  func scheduleUpdate(at date:Date? = nil){
    let wkExtension = WKExtension.shared()
    let date = date ?? Date().addingTimeInterval(60 * 15)
    wkExtension.scheduleBackgroundRefresh(withPreferredDate: date, userInfo: nil) { error in
      if let error = error {
        print("there was an error \(error) for scheduled task at \(date)")
      }
      
      print("there was a successful background refresh registration for scheduled task at \(date)")
      
    }
  }
  
  func handle(_ backgroundTasks: Set<WKRefreshBackgroundTask>) {
    for task in backgroundTasks{
      boroManager.getCurrent { newBoro in
        print("background Task got new Boro: \(newBoro)")
        let compServer = CLKComplicationServer.sharedInstance()
        if let activeComplications = compServer.activeComplications {
          for comp in activeComplications{
            compServer.reloadTimeline(for: comp)
          }
        }
        task.setTaskCompletedWithSnapshot(true)
      }
    }
    scheduleUpdate()
  }
}
