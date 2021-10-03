//
//  ContentView.swift
//  Boro WatchKit Extension
//
//  Created by Joss Manger on 10/2/21.
//

import SwiftUI
import CoreLocation
class LocationFinder {
  init(){
    CLLocationManager().requestWhenInUseAuthorization()
  }
}

struct ContentView: View {
  
  var locationOwner = LocationFinder()
  
    var body: some View {
        Text("Hello, World!")
            .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
