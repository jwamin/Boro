//
//  Location.swift
//  Boro
//
//  Created by Joss Manger on 8/10/18.
//  Copyright © 2018 Joss Manger. All rights reserved.
//

import Foundation
import CoreLocation

//1. request for location, geocoder checks if within area and sets status accordingly
//2. request for location update, geocoder checks if timeout has occurred, if so, reloads geocoder. IF location the same, state unchanged, if changed, state changed,
// callback from delegate will reset state to current
//X. 2


// delegation protocol to notify UI / Delegate
protocol LocatorProtocol {
    func locationUpdated(_ locator:Locator)
    func locatorError(errorMsg:String)
}

//Locator Class - Reverse Geocodes location in one of the 5 New York Boroughs
class Locator : NSObject, CLLocationManagerDelegate{
    
    //Core Location Objects
    var manager:CLLocationManager!
    var coder:CLGeocoder!
    
    //Delegation
    var delegate:LocatorProtocol?
    
    //Model
    private var borough:Borough = .outOfNYC {
        didSet{
            delegate?.locationUpdated(self)
        }
    }
    
    public func getBorough()->Borough{
        return borough
    }
    
    //State
    var updating = false
    var state:BoroughState! = .initialised{
        didSet{
            if(state == .timeoutError){
                delegate?.locatorError(errorMsg: "Error")
            }
        }
    }
    
    //Timeout Date
    var updatedOn:Date? = nil
    
    //Timeout Objects
    let timeout:TimeInterval! = 60
    var geoTimer:Timer!
    
    
    //Instance Methods
    
    override init() {
        super.init()
        coder = CLGeocoder()
        manager = CLLocationManager()
        manager.requestAlwaysAuthorization()
    }
    
    deinit {
        print("deinitialising locator")
    }
    
    //Primary Update Method
    
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

            manager.activityType = .other
            manager.desiredAccuracy = kCLLocationAccuracyKilometer
            manager.delegate = self
            manager.allowsBackgroundLocationUpdates = true
            manager.startUpdatingLocation()
           
        } else {
            print("no location services")
            updating = false
        }
        
    }
    
    //Checks validity of existing information
    private func checkExisting()->Bool{
        
        if(borough == .outOfNYC){
            return false
        }
        
        if let updatedDate = updatedOn{
            
            let checkDate = Date() < updatedDate.addingTimeInterval(timeout)

            if(checkDate){
                print("within timeout duration, returning existing status borough enum")
                delegate?.locationUpdated(self)
                return true
            }
            
        } else {
            print("optional unwrap failed")
            print(updating,updatedOn)
        }
        
        return false
    }
    
    
    // Callbacks
    private func reverseGeocodeCompletion(_ placemarks:[CLPlacemark]?,_ error:Error?){
        geoTimer.invalidate()
        if(error != nil){
            self.state = .timeoutError
            return
        }
        print("in geocode callback")
        
        //if let subLocality = placemarks?.first?.subLocality, let locality = placemarks?.first?.locality{
        if(placemarks?.first?.administrativeArea == ADMINISTRATIVE_AREA && placemarks?.first?.country == COUNTRY){
            //in NY, USA
            let subLocality = placemarks?.first?.subLocality ?? ""
            
            guard let isNYCBorough = Borough.checkBorough(subLocality) else {
                print("guess that's not in NYC")
                updating = false
                updatedOn = Date()
                borough = .outOfNYC
                state = .valid
                
                return
            }
            
            borough = isNYCBorough
            state = .valid
            self.updating = false
            self.updatedOn = Date()
            
            delegate?.locationUpdated(self)
            
            print("setting date",updatedOn,"expires at \(updatedOn?.addingTimeInterval(timeout))")
            print("in ny",isNYCBorough)
            
            
        } else {
            //not in NY
            borough = .outOfNYC
            updatedOn = Date()
            state = .valid
            print("guess that's not in new york state")
            manager.stopUpdatingLocation()
        }
        
        updating = false
        
    }
    
    //Delegate methods
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("updated location, stopping refresh")
        manager.stopUpdatingLocation()
        let interval:TimeInterval = 10
        geoTimer = Timer(fire: Date().addingTimeInterval(interval), interval: 0.0, repeats: false) { (timer) in
            timer.invalidate()
            self.coder.cancelGeocode()
            self.state = BoroughState.timeoutError
        }
        coder.reverseGeocodeLocation(locations.first!, completionHandler: reverseGeocodeCompletion(_:_:))
    }
    
}
