//
//  ContentView.swift
//  Boro WatchKit Extension
//
//  Created by Joss Manger on 10/2/21.
//

import SwiftUI
import BoroKit

struct BoroView: View {
  
  var current: Boro
  
    var body: some View {
      Circle().stroke(
        style: StrokeStyle(lineWidth: 2, lineCap: CGLineCap.round, lineJoin: CGLineJoin.round, miterLimit: 2, dash: [1], dashPhase: 1)
      ).foregroundColor(Color.red)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
      Group{
        BoroView(current: .manhattan)
        BoroView(current: .bronx)
      }
    }
}
