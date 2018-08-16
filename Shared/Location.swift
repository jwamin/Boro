//
//  Location.swift
//  Boro
//
//  Created by Joss Manger on 8/10/18.
//  Copyright © 2018 Joss Manger. All rights reserved.
//

import Foundation
import os
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
    var state:BoroughState! = .initialised{
        didSet{
            if(state == .timeoutError){
                coder.cancelGeocode()
                manager.stopUpdatingLocation()
                delegate?.locatorError(errorMsg: "Error")
            }
        }
    }
    
    //Timeout Date
    var updatedOn:Date? = nil
    
    //Timeout Objects
    let timeout:TimeInterval! = 60
    
    //Instance Methods
    
    override init() {
        super.init()
        
        coder = CLGeocoder()
        manager = CLLocationManager()
        manager.requestAlwaysAuthorization()
        
        doUpdate()
        
    }
    
    //log when object is deallocated
    deinit {
       os_log("deinitialising Locator")
    }
    
    //Primary Update Method
    
    func doUpdate(){
        
        if(state == .updating){
            return
        }
        
        state = .updating
        
        if(checkExistingLocationIsCurrent()){
            state = .valid
            return
        }
        
        print("will update location")
        
        if(CLLocationManager.locationServicesEnabled()){
            //setup locationManager
            manager.activityType = .other
            manager.desiredAccuracy = kCLLocationAccuracyKilometer
            manager.delegate = self
            manager.allowsBackgroundLocationUpdates = true
            //start locationManager
            manager.startUpdatingLocation()
           
        } else {
            print("no location services")
            state = .timeoutError
        }
        
    }
    
    //Checks validity of existing information
    private func checkExistingLocationIsCurrent()->Bool{
        
        //allow refresh sooner if curernt borough is 'out of NYC'
        if(borough == .outOfNYC){
            return false
        }
        
        if let updatedDate = updatedOn{
            
            //check for timeout
            let checkDate = Date() < updatedDate.addingTimeInterval(timeout)

            //if within timeout cooldown, within NYC, return true
            if(checkDate){
                print("within timeout duration, returning existing status borough enum")
                delegate?.locationUpdated(self)
                return true
            }
            
        }
        
        //current info is out of date, proceed with lookup
        return false
    }
    
    
    // Callbacks
    private func reverseGeocodeCompletion(_ placemarks:[CLPlacemark]?,_ error:Error?){
        
        if(error != nil){
            print("geocoder error",error?.localizedDescription)
            self.state = .timeoutError
            return
        }
        
        print("in geocode callback, no errors")
        
        self.updatedOn = Date()
        state = .valid
        
        if(placemarks?.first?.administrativeArea == ADMINISTRATIVE_AREA && placemarks?.first?.country == COUNTRY){
            //in NY, USA
            let subLocality = placemarks?.first?.subLocality ?? ""
            
            guard let isNYCBorough = Borough.checkBorough(subLocality) else {
                print("guess that's not in NYC")
                borough = .outOfNYC
                return
            }
            
            borough = isNYCBorough
        
            print("in ny ",isNYCBorough)
            return
            
        } else {
            //not in NY
            borough = .outOfNYC
            state = .valid
            print("guess that's not in new york state")
            manager.stopUpdatingLocation()
            return
        }
        
    }
    
    //CLLocatonManager Delegate methods
    
    
    //if locationamanger fails
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("locationmanager error")
        print(error.localizedDescription)
        manager.stopUpdatingLocation()
        state = .timeoutError
    }
    
    //if locationamanager succeeds
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("updated location, stopping cllocation updates")
        //stop after 1 hit
        manager.stopUpdatingLocation()
    
        coder.reverseGeocodeLocation(locations.first!, completionHandler: reverseGeocodeCompletion(_:_:))
        print("started coder")
        
    }
    
}
