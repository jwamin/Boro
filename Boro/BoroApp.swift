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
                .frame(minWidth: 150,minHeight: 150)
        }
        #if os(macOS)
        .windowStyle(.hiddenTitleBar)
        .windowResizability(.contentSize)
        #endif
    }
}
