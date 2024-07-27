//
//  BoroKit-Styles.swift
//  BoroKitUI
//
//  Created by Joss Manger on 7/27/24.
//

import BoroKit
import SwiftUI

public protocol ForegroundAndBackgroundColorProviding {
    var foregroundColor: Color { get }
    var backgroundColor: Color { get }
}

public protocol InitializesWithBoro {
    init(boro: Boro)
}

public struct BoroColorScheme: InitializesWithBoro & ForegroundAndBackgroundColorProviding {
    
    let boro: Boro
    
    public init(boro: Boro) {
        self.boro = boro
    }
    
    public var foregroundColor: Color {
        
        @Environment(\.colorScheme) var colorScheme: ColorScheme
        
        if colorScheme == .dark /*&& darkMode*/ {
            return .white
        }
        
        switch(boro){
        case .brooklyn:
            return .black
        default:
            return .white
        }
    }

    public var backgroundColor: Color {
        switch(boro){
        case .template:
            return .orange
        case .manhattan:
            return .red
        case .brooklyn:
            return .yellow
        case .bronx:
            return .green
        case .queens:
            return .purple
        case .statenIsland:
            return .indigo
        case .six:
            return .blue
        default:
            return .gray
        }
    }

}

