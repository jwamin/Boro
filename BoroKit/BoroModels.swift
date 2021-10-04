//
//  BoroModels.swift
//  BoroKit
//
//  Created by Joss Manger on 10/4/21.
//

import CoreLocation

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
