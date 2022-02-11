//
//  BoroKit.swift
//  BoroKit
//
//  Created by Joss Manger on 10/2/21.
//

import Foundation
import CoreLocation
import OSLog

public final class BoroManager: NSObject {
  
  struct Callback: Hashable {
    let uuid = UUID()
    let task: (Boro) -> Void
    
    func hash(into hasher: inout Hasher) {
      hasher.combine(uuid)
    }
    
    static func == (lhs: BoroManager.Callback, rhs: BoroManager.Callback) -> Bool {
      lhs.uuid == rhs.uuid
    }
    
  }
  
  public enum LocationRequestType: Hashable {
    case ui
    case complication
    case lifecycle
    case other(id:UUID)
  }
  
  private let logger = Logger(.default)
  private let coder = CLGeocoder()
  private let location: CLLocationManager
  private let queue = DispatchQueue(label: "com.jossy.borokit.background", attributes: .concurrent)
  
  private(set) var callbackSet = Dictionary<LocationRequestType,Callback>() {
    didSet{
      print("now at size: \(callbackSet.count): \(callbackSet)")
    }
  }
  
  @Published public private(set) var current: Boro = .system
  
  @UserDefault(key: .kCachedBorough, defaultValue: .system) public private(set) static var cached: Boro
  
  public override init(){
    
    location = CLLocationManager()
    location.desiredAccuracy = kCLLocationAccuracyHundredMeters
    
    super.init()
    
    location.delegate = self
    location.requestWhenInUseAuthorization()
    
    print("hello from boro command")
    
  }
  
  public func getCurrent(origin: LocationRequestType = .other(id: UUID()),_ completion: ((Boro) -> Void)? = nil) {
    
    if let completion = completion {
      
      let structCallback = Callback(task: completion)
      
      queue.async { [weak self] in
        self?.callbackSet[origin] = structCallback
      }
      
    }
    
    location.requestLocation()
    
  }
  
  func processUpdatedLocation(location: CLLocation?) {
    
    if let location = location {
      
      coder.reverseGeocodeLocation(location) { [weak self] placemarks, error in
        
        if error != nil {
          self?.logger.log("reverse geocoding error")
          return
        }
        
        if let placemark = placemarks?.first,
            let current = Boro(placemark: placemark),
            let callbackSet = self?.callbackSet {
          
          #if DEBUG
          self?.logger.log("current first placemark: \(placemark)")
          #endif
          
          self?.current = current
          BoroManager.cached = current
          
          for (key,item) in callbackSet {
            
            self?.queue.async(flags:.barrier){ [weak self] in
              self?.callbackSet.removeValue(forKey: key)
              item.task(current)
            }
            
          }
          
        }
        
      }
      
    }
    
  }
  
}


extension BoroManager: CLLocationManagerDelegate {
  
  public func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
    print("location authorization changed now: \(manager.authorizationStatus.rawValue)")
    
    switch manager.authorizationStatus {
    case .denied, .notDetermined, .restricted:
      return
    default:
      break
    }
    
    getCurrent(origin:.lifecycle){ boro in
      print("updated location following authorization change")
    }
  }
  
  public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    processUpdatedLocation(location: locations.first)
  }
  
  public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    print(error)
    logger.log("Error")
  }
  
}

