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
    

    
    //var locator:Locator!
    
    @IBOutlet var label: WKInterfaceLabel!
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
        delegate = WKExtension.shared().delegate as! ExtensionDelegate
        delegate.interface = self
        label.setText("")
        
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        // try update on appear
        delegate.locator.doUpdate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()

    }
    
    //Locator Delegation methods
    func locationUpdated(_ locator: Locator) {
        print("got location")
        label.setText(locator.getBorough().getString())
        label.setHidden(false)
    }
    
    func locatorError(errorMsg: String) {
        label.setText(errorMsg)
    }
    
}
