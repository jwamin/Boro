//
//  Location.swift
//  Boro
//
//  Created by Joss Manger on 8/10/18.
//  Copyright © 2018 Joss Manger. All rights reserved.
//

import Foundation
import CoreLocation

class Locator : NSObject, CLLocationManagerDelegate{
    
    var manager:CLLocationManager!
    var coder:CLGeocoder!
    override init() {
        super.init()
        print("hello from location handler",CLLocationManager.locationServicesEnabled())
        if(CLLocationManager.locationServicesEnabled()){
            manager = CLLocationManager()
            manager.requestAlwaysAuthorization()
            manager.activityType = .other
            manager.delegate = self
            manager.startMonitoringSignificantLocationChanges()
            coder = CLGeocoder()
            
        } else {
            print("no location services")
        }
        
    }
    
    private func reverseGeocodeCompletion(_ placemarks:[CLPlacemark]?,_ error:Error?){
        if(error != nil){
            fatalError((error?.localizedDescription)!)
        }
        print(placemarks)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //print(locations)
        coder.reverseGeocodeLocation(locations.first!, completionHandler: reverseGeocodeCompletion(_:_:))
    }
    
}
