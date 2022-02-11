//
//  BoroModels.swift
//  BoroKit
//
//  Created by Joss Manger on 10/4/21.
//

import CoreLocation

public enum Boro: String, Codable, CaseIterable, Identifiable {
    
    public var id: String {
        self.rawValue
    }
    
    case system = ""
    case template = "NYC"
    case brooklyn = "Brooklyn"
    case manhattan = "Manhattan"
    case queens = "Queens"
    case bronx = "The Bronx"
    case statenIsland = "Staten Island"
    case six = "6th Borough"
    case out = "Out of NYC"
    
    public func shortText() -> String {
        let shortText: String
        switch self {
        case .brooklyn:
            shortText = "Bk"
        case .manhattan:
            shortText = "NYC"
        case .bronx:
            shortText = "Bx"
        case .queens:
            shortText = "Qu"
        case .statenIsland:
            shortText = "SI"
        case .six:
            shortText = "6th"
        case .template:
            shortText = "NYC"
        case .out:
            shortText = "Out"
        default:
            return ""
        }
        return shortText
    }
    
    public init?(placemark: CLPlacemark){
        
        guard let adminArea = placemark.administrativeArea, let subLocality = placemark.subLocality, let subAdminArea = placemark.subAdministrativeArea else {
            self = .out
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
            switch(subAdminArea) {
            case "Hudson County":
                self = .six
            default:
                self = .out
            }
            
        default:
            self = .out
        }
    }
    
}
