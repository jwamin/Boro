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
    var updating = false
    var updatedOn:Date? = nil
    let timeout:TimeInterval! = 60
    
    override init() {
        super.init()
        doUpdate()
    }
    
    private func checkExisting()->Bool{
        if let updatedDate = updatedOn{
            let checkDate = Date() < updatedDate.addingTimeInterval(timeout)
            print("checkdate", checkDate)
                if(checkDate){
                    print("within timeout duration, returning existing borough enum")
                    guard let validBorough = borough else {
                    delegate?.locationUpdated("error")
                    return true
                }
                delegate?.locationUpdated(validBorough.getString())
                return true
            }
        } else {
        print("optional unwrap failed")
        print(updating,updatedOn)
        }
        return false
    }
    
    func doUpdate(){
        
        if(updating){
            return
        }
        updating = true
        if(checkExisting()){
            updating = false
            return
        }
        
        print("will update location")
        
        if(CLLocationManager.locationServicesEnabled()){
            manager = CLLocationManager()
            manager.requestAlwaysAuthorization()
            manager.activityType = .other
            manager.desiredAccuracy = kCLLocationAccuracyKilometer
            manager.delegate = self
            manager.allowsBackgroundLocationUpdates = true
            manager.startUpdatingLocation()
            coder = CLGeocoder()
        } else {
            print("no location services")
            updating = false
        }
        
    }
    
    private func reverseGeocodeCompletion(_ placemarks:[CLPlacemark]?,_ error:Error?){
        if(error != nil){
            delegate?.locationUpdated("Connection Error")
            return
        }
        print("in geocode callback")
        //if let subLocality = placemarks?.first?.subLocality, let locality = placemarks?.first?.locality{
        if(placemarks?.first?.administrativeArea == ADMINISTRATIVE_AREA && placemarks?.first?.country == COUNTRY){
            //in NY, USA
            let subLocality = placemarks?.first?.subLocality ?? ""
            
            guard let isNYCBorough = Borough.checkBorough(subLocality) else {
                print("guess that's not in NYC")
                delegate?.locationUpdated("guess that's not in NYC")
                manager.stopUpdatingLocation()
                updating = false
                updatedOn = nil
                borough = nil
                return
            }
            
            borough = isNYCBorough
            
            self.updating = false
            self.updatedOn = Date()
            
            delegate?.locationUpdated("\(subLocality)")
            
            
            print("setting date",updatedOn,"expires at \(updatedOn?.addingTimeInterval(timeout))")
            print("in ny",isNYCBorough)
            
            
            
        } else {
            //not in NY
            borough = nil
            updatedOn = nil
            print("guess that's not in new york state")
            manager.stopUpdatingLocation()
        }
        
        updating = false
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("updated location, stopping refresh")
        manager.stopUpdatingLocation()
        coder.reverseGeocodeLocation(locations.first!, completionHandler: reverseGeocodeCompletion(_:_:))
    }
    
    deinit {
        print("deinitialising locator")
    }
    
}
