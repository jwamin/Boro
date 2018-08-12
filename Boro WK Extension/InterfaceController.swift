//
//  InterfaceController.swift
//  Boro WK Extension
//
//  Created by Joss Manger on 8/10/18.
//  Copyright © 2018 Joss Manger. All rights reserved.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController, LocatorProtocol{
    
    var delegate:ExtensionDelegate!
    
    func locationUpdated(_ location: String) {
        print("got location")
        label.setText(location)
        label.setHidden(false)
    }
    
    //var locator:Locator!
    
    @IBOutlet var label: WKInterfaceLabel!
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        delegate = WKExtension.shared().delegate as! ExtensionDelegate
        delegate.interface = self
        label.setText("")
        // Configure interface objects here.
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        
//        if(delegate.locator == nil){
//            print("delegate locator is nil")
//            delegate.applicationDidBecomeActive()
//        }
//        locator = delegate.locator
//
//        if(locator.borough==nil){
//            if(!locator.updating){
//                print("not updating, doing update")
//                locator.doUpdate()
//            }
//        } else {
//            print("location already availalbe")
//            locationUpdated((locator.borough?.getString())!)
//
//        }
        
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
       // locator = nil
        
    }
    
}
