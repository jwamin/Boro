//
//  BoroKit.swift
//  BoroKit
//
//  Created by Joss Manger on 10/2/21.
//

import Foundation
import CoreLocation
import OSLog

public enum Boro: String, Codable {
  case system = ""
  case brooklyn = "Brooklyn"
  case manhattan = "Manhattan"
  case queens = "Queens"
  case bronx = "The Bronx"
  case statenIsland = "Staten Island"
  case six
  case out
  
  public init?(placemark: CLPlacemark){
    
    guard let adminArea = placemark.administrativeArea, let subLocality = placemark.subLocality else {
      self.init(rawValue: "out")
      return
    }
    
    switch adminArea {
    case "NY":
      if let cityBoro = Boro(rawValue: subLocality) {
        self = cityBoro
        return
      } else {
        self = .out
        return
      }
    case "NJ":
      self = .six
    default:
      self = .out
    }
  }
  
}



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
  
  private let logger = Logger(.default)
  private let coder = CLGeocoder()
  private let location: CLLocationManager
  private let queue = DispatchQueue(label: "com.jossy.borokit.background")
  private let dispatchGroup = DispatchGroup()
  private let semaphore = DispatchSemaphore(value: 0)
  
  private(set) var callbackSet = Set<Callback>() {
    didSet{
      print("now at size: \(callbackSet.count)")
    }
  }
  
  @Published public private(set) var current: Boro = .system
  
  public override init(){
    
    location = CLLocationManager()
    location.desiredAccuracy = kCLLocationAccuracyReduced
    
    super.init()
    
    location.delegate = self
    location.requestWhenInUseAuthorization()
    
    print("hello from boro command")
    //    getCurrent { current in
    //      self.current = current
    //      print("manager received \(current)")
    //    }
    
  }
  
  public func getCurrent(_ completion: @escaping (Boro) -> Void) {
    
    let structCallback = Callback(task: completion)
    
    queue.async(flags:.barrier){ [weak self] in
      self?.callbackSet.insert(structCallback)
    }
    
    location.requestLocation()
    
  }
  
  func processUpdatedLocation() {
    
    if let location = location.location {
      
      coder.reverseGeocodeLocation(location) { [weak self] placemarks, error in
        
        if error != nil {
          self?.logger.log("we got an error")
          return
        }
        
        if let placemark = placemarks?.first, let current = Boro(placemark: placemark), let callbackSet = self?.callbackSet {
          
          self?.current = current
          
          for item in callbackSet {
            
            self?.queue.async(flags:.barrier){ [weak self] in
              item.task(current)
              self?.callbackSet.remove(item)
            }
            
          }
          
        }
        
      }
      
    }
    
  }
  
}


extension BoroManager: CLLocationManagerDelegate {
  
  public func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
    print("location authorization changed")
    getCurrent { boro in
      print("updated location following authorization change")
    }
  }
  
  public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    processUpdatedLocation()
  }
  
  public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    logger.log("Error")
  }
  
}

