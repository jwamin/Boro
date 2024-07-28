//
//  Boro_MultiplatformApp.swift
//  Boro-Multiplatform
//
//  Created by Joss Manger on 7/28/24.
//

import SwiftUI
import BoroKit
import BoroKitUI

@main
struct Boro_MultiplatformApp: App {
    
#if os(iOS)
    @UIApplicationDelegateAdaptor private var appDelegate: BoroAppDelegate
    typealias MainBoroView = BoroIconRect
#elseif os(watchOS)
    @WKApplicationDelegateAdaptor var appDelegate: ExtensionDelegate
    typealias MainBoroView = BoroIconRound
#else
    @NSApplicationDelegateAdaptor private var appDelegate: BoroAppDelegate
    typealias MainBoroView = BoroIconRect
#endif
    
    @State var currentBoro: Boro = .system
    
    var body: some Scene {
        WindowGroup {
            MainBoroView(boro: currentBoro)
                .onReceive(appDelegate.boroManager.$current) { output in
                    DispatchQueue.main.asyncAfter(deadline: .now() + TimeInterval(1)){
                        print("did get update from boromanager \(output)")
                        currentBoro = output
                    }
                }.onTapGesture {
                    print("hello world")
                    appDelegate.boroManager.getCurrent()
                }.toolbarBackground(.hidden, for: .automatic)
        }
        
    }
    
}
