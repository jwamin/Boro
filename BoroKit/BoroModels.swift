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
    case out = "Out of NYC"
    case template = "NYC"
    case brooklyn = "Brooklyn"
    case manhattan = "Manhattan"
    case queens = "Queens"
    case bronx = "The Bronx"
    case statenIsland = "Staten Island"
    case six = "6th Borough"
    
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
    
    public var float: Float {
        let options = Boro.allCases.filter({ $0.isValid })
        let selfIndex = options.firstIndex(of: self) ?? 0
        let resultFloat:Float = Float(1.0) + (Float(1.0/Float(options.count)) * Float(selfIndex))
        return resultFloat
    }
    
    public var isValid: Bool {
        [.system,.out,.template].contains(self) ? false : true
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
