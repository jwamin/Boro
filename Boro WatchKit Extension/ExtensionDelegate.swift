//
//  ExtensionDelegate.swift
//  Boro WatchKit Extension
//
//  Created by Joss Manger on 10/4/21.
//

import WatchKit
import BoroKit

class ExtensionDelegate: NSObject, WKExtensionDelegate {
  
  private(set) var boroManager: BoroManager = BoroManager()
  
  func applicationDidFinishLaunching() {
    print("we loaded")
    boroManager.getCurrent { currentBoro in
      print("extension received \(currentBoro)")
      print("currentBoro: \(currentBoro)")
    }
  }
  
  
  
  func handle(_ backgroundTasks: Set<WKRefreshBackgroundTask>) {
    for task in backgroundTasks{
      task.setTaskCompletedWithSnapshot(true)
    }
  }
}
