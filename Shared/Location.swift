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
    var state:BoroughState! = .initialised{
        didSet{
            if(state == .timeoutError){
                geoTimer.invalidate()
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
    var geoTimer:Timer!
    
    
    //Instance Methods
    
    override init() {
        super.init()
        coder = CLGeocoder()
        manager = CLLocationManager()
        manager.requestAlwaysAuthorization()
        doUpdate()
    }
    
    deinit {
        print("deinitialising locator")
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
                updatedOn = Date()
                borough = .outOfNYC
                state = .valid
                return
            }
            
            borough = isNYCBorough
            state = .valid
            self.updatedOn = Date()
            
            print("in ny",isNYCBorough)
            return
            
        } else {
            //not in NY
            borough = .outOfNYC
            updatedOn = Date()
            state = .valid
            print("guess that's not in new york state")
            manager.stopUpdatingLocation()
            return
        }
        
    }
    
    //CLLocatonManager Delegate methods
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("locationmanager error")
        print(error.localizedDescription)
        manager.stopUpdatingLocation()
        state = .timeoutError
        self.state = BoroughState.timeoutError
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("updated location, stopping cllocation updates")
        //stop after 1 hit
        manager.stopUpdatingLocation()
        
        let interval:TimeInterval = 10
        geoTimer = Timer(fire: Date().addingTimeInterval(interval), interval: 0.0, repeats: false) { (timer) in
            print("timer ran, must be connectivity errors")
            self.state = BoroughState.timeoutError
        }
        RunLoop.current.add(geoTimer, forMode: .defaultRunLoopMode)
        
        coder.reverseGeocodeLocation(locations.first!, completionHandler: reverseGeocodeCompletion(_:_:))
    }
    
}
