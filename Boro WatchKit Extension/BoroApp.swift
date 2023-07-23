//
//  BoroApp.swift
//  Boro WatchKit Extension
//
//  Created by Joss Manger on 10/2/21.
//

import SwiftUI
import BoroKit

@main
struct BoroApp: App {
  
  @WKApplicationDelegateAdaptor var extensionDelegate: ExtensionDelegate
    
    var body: some Scene {
        WindowGroup {
            BoroRootView(manager: extensionDelegate.boroManager)
        }
    }
  
}
