//
//  ContentView.swift
//  Boro WatchKit Extension
//
//  Created by Joss Manger on 10/2/21.
//

import SwiftUI
import BoroKit

struct ContentView: View {
  
  var current: Boro
  
    var body: some View {
      Text(current.rawValue)
            .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
      Group{
        ContentView(current: .manhattan)
        ContentView(current: .bronx)
      }
    }
}
