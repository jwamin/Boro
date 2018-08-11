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

enum Borough {
    case manhattan
    case brooklyn
    case queens
    case bronx
    case statenIsland
    
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
    
}
