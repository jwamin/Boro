//
//  BoroApp.swift
//  Boro
//
//  Created by Joss Manger on 7/23/23.
//

import SwiftUI
import BoroKit

@MainActor let manager = BoroManager()

@main
struct BoroApp: App {
    
    var body: some Scene {
        WindowGroup {
            BoroRootView(manager: manager)
                .aspectRatio(1, contentMode: .fit)
                .padding()
                .frame(minWidth: 250,minHeight: 250)
        }
        #if os(macOS)
        .windowResizability(.contentSize)
        #endif
    }
}
