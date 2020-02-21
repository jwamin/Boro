//
//  nyc.swift
//  Boro
//
//  Created by Joss Manger on 8/10/18.
//  Copyright © 2018 Joss Manger. All rights reserved.
//

import Foundation

let ADMINISTRATIVE_AREA = "NY"
let COUNTRY = "United States"

enum BoroughState{
    case initialised
    case updating
    case valid
    case timeoutError
}

public enum Borough {
    case manhattan
    case brooklyn
    case queens
    case bronx
    case statenIsland
    case outOfNYC
    
    static func checkBorough(_ str:String) -> Borough? {
        switch str {
        case "Manhattan":
            return .manhattan
        case "Brooklyn":
            return .brooklyn
        case "Queens":
            return .queens
        case "Bronx":
            return .bronx
        case "Staten Island":
            return .statenIsland
        default:
            return nil
        }
    }
    
    func getString()->String{
        switch self {
        case .manhattan:
            return "Manhattan"
        case .brooklyn:
            return "Brooklyn"
        case .queens:
            return "Queens"
        case .bronx:
            return "Bronx"
        case .statenIsland:
            return "Staten Island"
        default:
            return "Out Of NYC"
        }
    }
    
    func getAbbrString()->String{
        switch self {
        case .manhattan:
            return "Ny"
        case .brooklyn:
            return "Br"
        case .queens:
            return "Qu"
        case .bronx:
            return "Bx"
        case .statenIsland:
            return "Si"
        default:
            return "Out"
        }
    }
    
}
