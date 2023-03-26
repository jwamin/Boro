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
  
  @State var current: Boro = .system
  
    var body: some Scene {
        WindowGroup {
            BoroIcon(boro: current)
            .onReceive(extensionDelegate.boroManager.$current) { output in
              current = output
            }
        }
    }
  
}
