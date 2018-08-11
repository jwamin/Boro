//
//  InterfaceController.swift
//  Boro WK Extension
//
//  Created by Joss Manger on 8/10/18.
//  Copyright © 2018 Joss Manger. All rights reserved.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController,LocatorProtocol {
    
    func locationUpdated(_ location: String) {
        label.setText(location)
    }
    
    var locator:Locator!
    
    @IBOutlet var label: WKInterfaceLabel!
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)

        // Configure interface objects here.
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        label.setText("")
        locator = Locator()
        locator.delegate = self
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
        locator = nil
        
    }

}
