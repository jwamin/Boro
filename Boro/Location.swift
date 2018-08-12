//
//  Location.swift
//  Boro
//
//  Created by Joss Manger on 8/10/18.
//  Copyright © 2018 Joss Manger. All rights reserved.
//

import Foundation
import CoreLocation

protocol LocatorProtocol {
    func locationUpdated(_ location:String)
}

class Locator : NSObject, CLLocationManagerDelegate{
    
    var manager:CLLocationManager!
    var coder:CLGeocoder!
    var delegate:LocatorProtocol?
    
    var borough:Borough?
    
    override init() {
        super.init()
        print("hello from location handler",CLLocationManager.locationServicesEnabled())
        doUpdate()
        
    }
    
    func doUpdate(){
        if(CLLocationManager.locationServicesEnabled()){
            print("debug print")
            manager = CLLocationManager()
            manager.requestAlwaysAuthorization()
            manager.activityType = .other
            manager.desiredAccuracy = kCLLocationAccuracyKilometer
            manager.delegate = self
            manager.startUpdatingLocation()
            coder = CLGeocoder()
            
        } else {
            print("no location services")
        }
    }
    
    private func reverseGeocodeCompletion(_ placemarks:[CLPlacemark]?,_ error:Error?){
        if(error != nil){
            fatalError((error?.localizedDescription)!)
        }
        
        //if let subLocality = placemarks?.first?.subLocality, let locality = placemarks?.first?.locality{
        if(placemarks?.first?.administrativeArea == ADMINISTRATIVE_AREA && placemarks?.first?.country == COUNTRY){
            //in NY, USA
            let subLocality = placemarks?.first?.subLocality ?? ""
            
            guard let isNYCBorough = Borough.checkBorough(subLocality) else {
                print("guess that's not in NYC")
                delegate?.locationUpdated("guess that's not in NYC")
                manager.stopUpdatingLocation()
                return
            }
            
            borough = isNYCBorough
            delegate?.locationUpdated("\(subLocality)")
            
            print(isNYCBorough)
            
            
            
        } else {
            //not in NY
            borough = nil
            print("guess that's not in new york state")
            manager.stopUpdatingLocation()
        }

        
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("updating locations")
        coder.reverseGeocodeLocation(locations.first!, completionHandler: reverseGeocodeCompletion(_:_:))
    }
    
}
