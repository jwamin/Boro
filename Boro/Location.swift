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
    override init() {
        super.init()
        print("hello from location handler",CLLocationManager.locationServicesEnabled())
        if(CLLocationManager.locationServicesEnabled()){
            manager = CLLocationManager()
            manager.requestAlwaysAuthorization()
            manager.activityType = .other
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
        
        print(placemarks)
        
        //if let subLocality = placemarks?.first?.subLocality, let locality = placemarks?.first?.locality{
        if(placemarks?.first?.administrativeArea == ADMINISTRATIVE_AREA && placemarks?.first?.country == COUNTRY){
            //in NY, USA
            let subLocality = placemarks?.first?.subLocality ?? ""
            delegate?.locationUpdated("\(subLocality)")
            
        } else {
            //not in NY
            print("guess that's not in new york state")
        }

        
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //print(locations)
        coder.reverseGeocodeLocation(locations.first!, completionHandler: reverseGeocodeCompletion(_:_:))
    }
    
}
