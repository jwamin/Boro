//
//  AppDelegate.swift
//  Boro-Multiplatform
//
//  Created by Joss Manger on 7/28/24.
//

#if !os(macOS)
import UIKit
typealias AppDelegate = UIApplicationDelegate
#else
import AppKit
typealias AppDelegate = NSApplicationDelegate
#endif
import BoroKit

class BoroAppDelegate: NSObject, AppDelegate {
    
    private(set) var boroManager: BoroManager = BoroManager()
#if !os(macOS)
    func applicationDidFinishLaunching(_ application: UIApplication) {
        print("ui app launch")
    }
#else
    func applicationDidFinishLaunching(_ notification: Notification) {
        print("appkit app launch")
    }
#endif
}
